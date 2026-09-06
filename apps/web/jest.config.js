/**
 * ชุดทดสอบฝั่งเว็บ — ตั้งใจครอบเฉพาะตรรกะล้วนก่อน (route-access, ตัวช่วยใน lib/)
 * ไม่ render React จึงไม่ต้องใช้ jsdom หรือ next/jest ทำให้ชุดทดสอบเบาและเร็ว
 * ถ้าจะเพิ่มเทสต์ที่ต้อง render component ค่อยเปลี่ยน testEnvironment เป็น jsdom
 */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  transform: {
    '^.+\.tsx?$': ['ts-jest', { tsconfig: { jsx: 'react-jsx', esModuleInterop: true } }],
  },
};
