import 'reflect-metadata';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { SubmitApplicationDto } from './submit-application.dto';

describe('SubmitApplicationDto', () => {
  it('accepts the beneficiary payload sent by the registration page', async () => {
    const dto = plainToInstance(SubmitApplicationDto, {
      type: 'ordinary',
      governmentAgency: 'โรงเรียนแม่ฟ้าหลวง',
      fullName: 'สมชาย ใจดี',
      beneficiaries: [
        {
          name: 'สมหญิง ใจดี',
          relationship: 'คู่สมรส',
          nationalId: '1234567890123',
          houseNo: '99/1',
          moo: '2',
          road: 'ถนนทดสอบ',
          soi: 'ซอยทดสอบ',
          subdistrict: 'แม่ฟ้าหลวง',
          district: 'แม่ฟ้าหลวง',
          province: 'เชียงราย',
          zip: '57110',
          phone: '0812345678',
          contactPerson: 'สมชาย ใจดี',
          contactPhone: '0899999999',
        },
      ],
    });

    const errors = await validate(dto, {
      whitelist: true,
      forbidNonWhitelisted: true,
    });

    expect(errors).toEqual([]);
  });
});
