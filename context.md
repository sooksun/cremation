# Cremation Welfare Management System for Teachers

## 1. Domain overview

This system manages a **cremation welfare association for teachers**.
The association can serve **multiple schools**, with **multiple member types**, and operates **across many years**.

The legacy reference is "Cremation Good App", which has 9 main menu groups:
1. User/role rights configuration
2. Master data & initial settings (chart of accounts, expense types, bank books)
3. Member management (registry, new application, status changes)
4. Registry & death case management (beneficiaries, group changes, death recording, benefit calculation)
5. Finance (receipts, payments, monthly welfare rate)
6. Accounting (ledgers, trial balance, balance sheet, P&L, assets & depreciation)
7. Bank (deposit/withdraw slips)
8. Reports (daily, monthly, yearly, utility for closing periods)
9. Exit

Our system brings these ideas to the web, for teachers across multiple schools.

### High level goals

- Reduce manual work and errors when managing welfare money.
- Provide clear and traceable records for all money movements.
- Make it easy to see:
  - How many members (by school, type, status, year).
  - Who has paid/not paid welfare in each month.
  - Death benefit calculations and payments.
  - Financial position of the welfare fund (cash, bank, assets, liabilities).

## 2. Core concepts & entities

### Association & Schools

- **School**: Each teacher belongs to one school. One association can serve many schools.
  - `id`, `code`, `name`, `district`, `province`, etc.

### Members & Types

- **MemberType**:
  - Example: REGULAR_TEACHER, RETIRED_TEACHER, STAFF, OTHER.
  - Can affect welfare rate and benefit policies.

- **Member**:
  - Personal info: name, ID card, birthday, address, phone.
  - Relation to school: `schoolId`, `employeeCode`.
  - Group: optional group (similar to "หมู่บ้าน/กลุ่ม" used for collection).
  - Status: `ACTIVE`, `RESIGNED`, `DECEASED`, `ARREARS`, `SUSPENDED`.
  - JoinDate, ResignDate, DeathDate (if applicable).

- **Beneficiary**:
  - People who will receive benefit when member dies.
  - May store up to 3 beneficiaries with relationship and phone.

### Contributions (เงินสงเคราะห์ / เงินบำรุง)

- **ContributionPeriod**:
  - Identified by `year` and `month`.
  - Defines welfare rate (amount per member) and service fee for that period.

- **MemberContribution**:
  - For each member and period:
    - AmountDue (welfare + service fee)
    - AmountPaid
    - PaidDate
    - Collector / GroupLeader
    - ReceiptId (link to financial document)
    - IsArrears flag.

### Death claims & benefit calculation

- **DeathClaim**:
  - Links to a deceased member.
  - Contains:
    - DateReported, DateOfDeath, cause of death.
    - Beneficiary (main receiver).
    - Calculation snapshot:
      - Number of active members on calculation date.
      - Welfare rate per member.
      - Total collected welfare for this case.
      - Association's contribution / subsidy.
      - Various deductions (fees, service charge).
      - Net amount to pay to beneficiary.

- **DeathBenefitPayment**:
  - Actual payment record:
    - PaymentDate
    - PaymentMethod (cash / bank transfer)
    - Bank account
    - PaymentVoucherId (accounting link).

### Finance & accounting

- **Account**:
  - Chart of accounts (assets, liabilities, equity, income, expense).
  - Example: Cash on hand, Welfare revenue, Benefit expense, Service fee income.

- **LedgerEntry**:
  - Double-entry accounting record (debit/credit).
  - Linked to Receipts/PaymentVouchers/DeathClaims where appropriate.

- **Receipt**:
  - Income side:
    - Member payments (welfare, membership fee, book fee, annual fee).
    - Other income.

- **PaymentVoucher**:
  - Expense side:
    - Death benefit payment.
    - Operating expenses.
    - Bank charges, etc.

### Bank & assets

- **BankAccount**: association bank accounts.
- **CashBook**: cash on hand tracking.
- **Asset** & **Depreciation**: optional but should be modelled for future use.

## 3. User roles & permissions (simplified)

- **ADMIN**: full access, manage users, master data.
- **FINANCE**: manage receipts, payments, contributions, bank operations.
- **ACCOUNTING**: manage chart of accounts, ledger, financial statements.
- **GROUP_LEADER**: view and record contributions for members in their group.
- **VIEWER**: read-only access to reports.

## 4. Reports

- **Daily**:
  - Cash & bank movement by day.
  - Daily receipts & payments summary.
- **Monthly**:
  - New/resigned/deceased members.
  - Arrears by school / group.
  - Summary of income & expenses.
- **Yearly**:
  - Member statistics by year.
  - Annual welfare paid and collected.
  - Financial statements.

## 5. Non-functional

- Multi-year: all tables must include dates and be queryable by year/month.
- Multi-school: almost all operational data is scoped to a school.
- Demo DB: use `prisma/seed.ts` to create realistic Thai teacher data and sample transactions.
- UI: Thai language labels, simple pastel theme, easy-to-read for admin staff.
