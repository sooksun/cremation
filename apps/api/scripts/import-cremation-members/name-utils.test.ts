import assert from 'node:assert';
import { normalizeIdCard, parseThaiName, nameKey } from './name-utils';

// normalizeIdCard
assert.strictEqual(normalizeIdCard('1501100007745'), '1501100007745');
assert.strictEqual(normalizeIdCard('1-5011-00007-74-5'), '1501100007745');
assert.strictEqual(normalizeIdCard('  3569900071638 '), '3569900071638');
assert.strictEqual(normalizeIdCard('123'), null);
assert.strictEqual(normalizeIdCard(null), null);
assert.strictEqual(normalizeIdCard(undefined), null);
assert.strictEqual(normalizeIdCard(1501100007745), '1501100007745'); // number input

// parseThaiName — คงคำนำหน้าใน firstName
assert.deepStrictEqual(parseThaiName('นางสาวศิริพร  ดวงดี'), { firstName: 'นางสาวศิริพร', lastName: 'ดวงดี' });
assert.deepStrictEqual(parseThaiName('นายเกรียงศักดิ์  ฝึกฝน'), { firstName: 'นายเกรียงศักดิ์', lastName: 'ฝึกฝน' });
assert.deepStrictEqual(parseThaiName('นาง  สมพร  ใจดี  มาก'), { firstName: 'นางสมพร', lastName: 'ใจดี มาก' });
assert.deepStrictEqual(parseThaiName('ว่าที่ร้อยตรีบรรจง สุทธสม'), { firstName: 'ว่าที่ร้อยตรีบรรจง', lastName: 'สุทธสม' });
// ไม่มีคำนำหน้า → firstName = token แรก
assert.deepStrictEqual(parseThaiName('สมชาย ใจดี'), { firstName: 'สมชาย', lastName: 'ใจดี' });
// ไม่มีนามสกุล
assert.deepStrictEqual(parseThaiName('นายสมชาย'), { firstName: 'นายสมชาย', lastName: '' });

// nameKey — strip title + ทุก whitespace
assert.strictEqual(nameKey('นางสาวศิริพร  ดวงดี'), 'ศิริพรดวงดี');
assert.strictEqual(nameKey('นาย เกรียงศักดิ์ ฝึกฝน'), 'เกรียงศักดิ์ฝึกฝน');
assert.strictEqual(nameKey(''), null);

console.log('name-utils: all assertions passed');
