import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

/**
 * Document Number Generation Service
 * รูปแบบเลขที่เอกสารอัตโนมัติ:
 * 
 * 1. ใบเสร็จรับเงิน (Receipt):      R202412-M0001, R202412-M0002, R202412-M0003...
 * 2. ใบสำคัญจ่าย (PaymentVoucher):  PV-2024-0001, PV-2024-0002, PV-2024-0003...
 * 3. สมาชิก (Member):               M0001, M0002, M0003...
 * 4. เรียกเก็บรายเดือน (Period):    CP-202412, CP-202501...
 * 5. แจ้งเสียชีวิต (DeathClaim):    DC-2024-0001, DC-2024-0002...
 * 6. ธุรกรรมธนาคาร (BankTxn):      BT-2024-0001, BT-2024-0002...
 */

export enum DocumentType {
  RECEIPT = 'RECEIPT',
  PAYMENT_VOUCHER = 'PAYMENT_VOUCHER',
  MEMBER = 'MEMBER',
  CONTRIBUTION_PERIOD = 'CONTRIBUTION_PERIOD',
  DEATH_CLAIM = 'DEATH_CLAIM',
  BANK_TRANSACTION = 'BANK_TRANSACTION',
}

@Injectable()
export class DocumentNumberService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * สร้างเลขที่เอกสารอัตโนมัติตามประเภท
   */
  async generateNumber(type: DocumentType): Promise<string> {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const yearMonth = `${year}${month}`;

    switch (type) {
      case DocumentType.RECEIPT:
        return this.generateReceiptNumber(yearMonth);
      case DocumentType.PAYMENT_VOUCHER:
        return this.generatePaymentVoucherNumber(year);
      case DocumentType.MEMBER:
        return this.generateMemberNumber();
      case DocumentType.CONTRIBUTION_PERIOD:
        return this.generateContributionPeriodNumber(yearMonth);
      case DocumentType.DEATH_CLAIM:
        return this.generateDeathClaimNumber(year);
      case DocumentType.BANK_TRANSACTION:
        return this.generateBankTransactionNumber(year);
      default:
        throw new Error(`Unknown document type: ${type}`);
    }
  }

  /**
   * ใบเสร็จรับเงิน: R202412-M0001
   *
   * ต้องนับใบเสร็จที่ถูกยกเลิก (voidedAt) รวมเข้ามาด้วยเสมอ ห้ามกรองออก
   * เลขที่ที่ออกไปแล้วถือว่าใช้ไปแล้วตลอดกาล ถ้ากรองใบที่ยกเลิกทิ้ง
   * เลขที่ของใบนั้นจะว่างกลับมาแล้วถูกออกซ้ำให้สมาชิกคนละคนคนละยอด
   */
  private async generateReceiptNumber(yearMonth: string): Promise<string> {
    const prefix = `R${yearMonth}-M`;

    return this.prisma.$transaction(async (tx) => {
      const lastReceipt = await tx.receipt.findFirst({
        where: { receiptNo: { startsWith: prefix } },
        orderBy: { receiptNo: 'desc' },
      });

      if (!lastReceipt) {
        return `${prefix}0001`;
      }

      const parts = lastReceipt.receiptNo.split('-M');
      const lastNum = parseInt(parts[1] || '0', 10);
      return `${prefix}${String(lastNum + 1).padStart(4, '0')}`;
    });
  }

  /**
   * ใบสำคัญจ่าย: PV-2024-0001
   */
  private async generatePaymentVoucherNumber(year: number): Promise<string> {
    const prefix = `PV-${year}-`;
    
    const lastPayment = await this.prisma.paymentVoucher.findFirst({
      where: {
        voucherNo: { startsWith: prefix },
      },
      orderBy: { voucherNo: 'desc' },
    });

    if (!lastPayment) {
      return `${prefix}0001`;
    }

    // Extract number from PV-2024-0001 -> 0001
    const parts = lastPayment.voucherNo.split('-');
    const lastNum = parseInt(parts[2] || '0', 10);
    return `${prefix}${String(lastNum + 1).padStart(4, '0')}`;
  }

  /**
   * สมาชิก: M0001
   */
  private async generateMemberNumber(): Promise<string> {
    const prefix = 'M';
    
    const lastMember = await this.prisma.member.findFirst({
      where: {
        memberNo: { startsWith: prefix },
      },
      orderBy: { memberNo: 'desc' },
    });

    if (!lastMember) {
      return `${prefix}0001`;
    }

    // Extract number from M0001 -> 0001
    const lastNum = parseInt(lastMember.memberNo.substring(1) || '0', 10);
    return `${prefix}${String(lastNum + 1).padStart(4, '0')}`;
  }

  /**
   * รอบเรียกเก็บเงิน: CP-202412
   */
  private async generateContributionPeriodNumber(yearMonth: string): Promise<string> {
    return `CP-${yearMonth}`;
  }

  /**
   * แจ้งเสียชีวิต: DC-2024-0001
   */
  private async generateDeathClaimNumber(year: number): Promise<string> {
    const prefix = `DC-${year}-`;
    
    const lastClaim = await this.prisma.deathClaim.findFirst({
      where: {
        claimNo: { startsWith: prefix },
      },
      orderBy: { claimNo: 'desc' },
    });

    if (!lastClaim) {
      return `${prefix}0001`;
    }

    // Extract number from DC-2024-0001 -> 0001
    const parts = lastClaim.claimNo.split('-');
    const lastNum = parseInt(parts[2] || '0', 10);
    return `${prefix}${String(lastNum + 1).padStart(4, '0')}`;
  }

  private async generateBankTransactionNumber(year: number): Promise<string> {
    const prefix = `BT-${year}-`;

    const last = await this.prisma.bankTransaction.findFirst({
      where: { transactionNo: { startsWith: prefix } },
      orderBy: { transactionNo: 'desc' },
    });

    if (!last) {
      return `${prefix}0001`;
    }

    const parts = last.transactionNo.split('-');
    const lastNum = parseInt(parts[2] || '0', 10);
    return `${prefix}${String(lastNum + 1).padStart(4, '0')}`;
  }

  /**
   * ดึงเลขลำดับถัดไป (preview only, ไม่บันทึก)
   */
  async getNextNumber(type: DocumentType): Promise<string> {
    return this.generateNumber(type);
  }

  /**
   * ตรวจสอบว่าเลขที่เอกสารซ้ำหรือไม่
   */
  async isDuplicate(type: DocumentType, number: string): Promise<boolean> {
    switch (type) {
      case DocumentType.RECEIPT:
        // รวมใบที่ยกเลิกแล้วด้วย — เลขที่ที่เคยออกไปถือว่าถูกใช้ไปแล้ว
        const receipt = await this.prisma.receipt.findFirst({
          where: { receiptNo: number },
        });
        return !!receipt;

      case DocumentType.PAYMENT_VOUCHER:
        const payment = await this.prisma.paymentVoucher.findFirst({
          where: { voucherNo: number },
        });
        return !!payment;

      case DocumentType.MEMBER:
        const member = await this.prisma.member.findFirst({
          where: { memberNo: number },
        });
        return !!member;

      case DocumentType.DEATH_CLAIM:
        const claim = await this.prisma.deathClaim.findFirst({
          where: { claimNo: number },
        });
        return !!claim;

      default:
        return false;
    }
  }
}

