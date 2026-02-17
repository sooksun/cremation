# cremation
# Cremation Welfare Management System for Teachers

ระบบบริหารจัดการสมาชิกฌาปนกิจสงเคราะห์สำหรับครูและบุคลากรทางการศึกษา  
รองรับหลายโรงเรียน หลายประเภทสมาชิก และใช้งานได้หลายปี

## Tech Stack

- **Backend**: NestJS, TypeScript, Prisma, MySQL
- **Frontend**: Next.js 14 (App Router), TypeScript, TailwindCSS
- **Monorepo**: pnpm workspaces

## Getting Started

### Prerequisites

- Node.js 18+
- pnpm 8+
- MySQL Server (or Laragon/XAMPP)

### 📖 คู่มือการ Setup

- **Ubuntu**: ดูคู่มือละเอียดที่ [SETUP_UBUNTU.md](./SETUP_UBUNTU.md)
- **Windows (Laragon)**: ดูด้านล่าง

### 1. Clone & Install

```bash
git clone <repository>
cd cremation
pnpm install
```

### 2. Environment Setup

Create `.env` file in root directory:

```env
# Database
DATABASE_URL="mysql://root:@localhost:3306/cremation_db"

# JWT
JWT_SECRET="your-super-secret-jwt-key-change-in-production"
JWT_EXPIRES_IN="7d"

# API
API_PORT=3001

# CORS (comma-separated for multiple origins)
CORS_ORIGINS="http://localhost:3000,http://203.172.184.47:8889"
# Or use single origin:
# FRONTEND_URL="http://localhost:3000"

# Frontend
NEXT_PUBLIC_API_URL="http://localhost:3001/api"
```

### 3. Database Setup

```bash
# Create database (using MySQL CLI)
mysql -u root -e "CREATE DATABASE cremation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Generate Prisma client
cd apps/api
npx prisma generate

# Run migrations
npx prisma migrate dev --name init

# Seed demo data
npx ts-node prisma/seed.ts
```

### 4. Run Development Servers

```bash
# From root directory
pnpm dev:api   # Start NestJS API on port 3001
pnpm dev:web   # Start Next.js on port 3000

# Or run both
pnpm dev
```

### 5. Access

- **Frontend**: http://localhost:3000
- **API**: http://localhost:3001/api
- **Prisma Studio**: `cd apps/api && npx prisma studio`

## Test Accounts

| Username | Password | Role     | Description        |
|----------|----------|----------|--------------------|
| admin    | 1234     | ADMIN    | ผู้ดูแลระบบ        |
| finance  | 1234     | FINANCE  | เจ้าหน้าที่การเงิน |
| account  | 1234     | ACCOUNTING | เจ้าหน้าที่บัญชี  |

## Project Structure

```
cremation/
├── apps/
│   ├── api/                 # NestJS Backend
│   │   ├── src/
│   │   │   ├── auth/        # Authentication module
│   │   │   ├── users/       # User management
│   │   │   ├── schools/     # School management
│   │   │   ├── members/     # Member registry
│   │   │   ├── contributions/ # Monthly welfare
│   │   │   ├── death-claims/  # Death claims & benefits
│   │   │   ├── accounts/    # Chart of accounts
│   │   │   ├── receipts/    # Income receipts
│   │   │   ├── payments/    # Payment vouchers
│   │   │   └── reports/     # Reporting
│   │   └── prisma/          # Prisma schema & seed
│   │
│   └── web/                 # Next.js Frontend
│       └── src/
│           ├── app/         # App Router pages
│           ├── components/  # Reusable components
│           ├── lib/         # Utilities & API client
│           └── store/       # Zustand state
│
├── prisma/                  # Legacy prisma files (deprecated)
├── context.md               # Domain documentation
├── plan.md                  # Project roadmap
└── tasks.md                 # Task tracking
```

## Main Features

### 1. User & Role Management
- Multi-role support: ADMIN, FINANCE, ACCOUNTING, GROUP_LEADER, VIEWER
- JWT-based authentication

### 2. Master Data
- Schools management (multi-school support)
- Member types (regular teacher, retired, staff)
- Collection groups
- Chart of accounts
- Bank accounts

### 3. Member Registry
- Member CRUD with status tracking
- Beneficiary management (up to 3 per member)
- Status lifecycle: ACTIVE → ARREARS → RESIGNED/DECEASED

### 4. Monthly Contributions (เงินสงเคราะห์)
- Contribution period setup
- Auto-generate contributions for active members
- Payment recording with receipt generation
- Arrears tracking

### 5. Death Claims (แจ้งเสียชีวิต)
- Death claim registration
- Benefit calculation (members × rate + association support - deductions)
- Payment tracking with voucher generation

### 6. Finance & Accounting
- Receipt management (income)
- Payment voucher management (expense)
- Auto-generated ledger entries (double-entry)
- Trial balance report

### 7. Bank Operations
- Bank account management
- Transaction history

### 8. Reports
- Dashboard with KPIs
- Member statistics by school/status
- Contribution collection reports
- Financial summary
- Death benefit reports

## API Endpoints

```
POST   /api/auth/login          # Login
GET    /api/auth/me             # Current user

GET    /api/schools             # List schools
POST   /api/schools             # Create school
GET    /api/members             # List members
POST   /api/members             # Create member
PATCH  /api/members/:id/status  # Change status

GET    /api/contributions/periods        # List periods
POST   /api/contributions/periods        # Create period
POST   /api/contributions/periods/:id/generate  # Generate contributions

GET    /api/death-claims        # List claims
POST   /api/death-claims        # Create claim
POST   /api/death-claims/:id/payment     # Record payment

GET    /api/reports/dashboard   # Dashboard data
GET    /api/reports/financial   # Financial summary
```

## Development Notes

- All dates are stored in ISO format (ค.ศ./Gregorian)
- UI displays Thai calendar (พ.ศ.) - conversion done in frontend
- Multi-tenant queries always filter by schoolId
- Soft-delete implemented via isActive/status fields

## License

Private - Internal use only
