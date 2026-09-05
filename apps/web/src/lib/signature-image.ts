// แปลงไฟล์รูปลายเซ็นที่ผู้ใช้อัปโหลดให้อยู่ในรูปแบบเดียวกับลายเซ็นที่วาดบนหน้าจอ
// (PNG พื้นหลังโปร่งใส ขนาดพอดีกับช่องลายเซ็นในใบเสร็จ) และไม่เกินขนาดคอลัมน์ TEXT ของ MySQL

export const SIGNATURE_MAX_DATA_URL_LENGTH = 60_000;

const ACCEPTED_TYPES = ['image/png', 'image/jpeg', 'image/webp'];
const MAX_UPLOAD_BYTES = 8 * 1024 * 1024;
// ค่าความสว่างที่ถือว่าเป็น "พื้นกระดาษ" — สแกน/ถ่ายรูปลายเซ็นมักได้พื้นออกเทาไม่ใช่ขาวสนิท
const BACKGROUND_LUMINANCE_THRESHOLD = 235;

export class SignatureImageError extends Error {}

function readAsDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result));
    reader.onerror = () => reject(new SignatureImageError('อ่านไฟล์รูปไม่สำเร็จ'));
    reader.readAsDataURL(file);
  });
}

function loadImage(dataUrl: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = () => reject(new SignatureImageError('ไฟล์นี้ไม่ใช่รูปภาพที่เปิดได้'));
    img.src = dataUrl;
  });
}

// ทำพื้นหลังสว่างให้โปร่งใส แล้วคืนกรอบสี่เหลี่ยมที่มีเนื้อลายเซ็นจริง เพื่อตัดขอบกระดาษที่ว่างทิ้ง
function removeBackground(ctx: CanvasRenderingContext2D, width: number, height: number) {
  const image = ctx.getImageData(0, 0, width, height);
  const data = image.data;
  let minX = width;
  let minY = height;
  let maxX = -1;
  let maxY = -1;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const i = (y * width + x) * 4;
      const luminance = 0.299 * data[i] + 0.587 * data[i + 1] + 0.114 * data[i + 2];
      if (data[i + 3] < 16 || luminance >= BACKGROUND_LUMINANCE_THRESHOLD) {
        data[i + 3] = 0;
        continue;
      }
      // ยิ่งเข้มยิ่งทึบ — ทำให้ขอบเส้นลายเซ็นไม่เป็นขั้นบันได
      data[i + 3] = Math.min(
        255,
        Math.round(((BACKGROUND_LUMINANCE_THRESHOLD - luminance) / BACKGROUND_LUMINANCE_THRESHOLD) * 255 * 1.6),
      );
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }
  }

  ctx.putImageData(image, 0, 0);
  if (maxX < 0 || maxY < 0) return null;
  return { minX, minY, maxX, maxY };
}

/**
 * รับไฟล์รูปลายเซ็น คืน data URL (PNG พื้นหลังโปร่งใส) ที่พร้อมบันทึกลงฐานข้อมูล
 * โยน SignatureImageError พร้อมข้อความภาษาไทยเมื่อไฟล์ใช้ไม่ได้
 */
export async function prepareSignatureImage(file: File): Promise<string> {
  if (!ACCEPTED_TYPES.includes(file.type)) {
    throw new SignatureImageError('รองรับเฉพาะไฟล์ PNG, JPG หรือ WebP');
  }
  if (file.size > MAX_UPLOAD_BYTES) {
    throw new SignatureImageError('ไฟล์รูปใหญ่เกิน 8 MB กรุณาย่อขนาดก่อนอัปโหลด');
  }

  const img = await loadImage(await readAsDataUrl(file));
  if (!img.naturalWidth || !img.naturalHeight) {
    throw new SignatureImageError('ไฟล์นี้ไม่ใช่รูปภาพที่เปิดได้');
  }

  // ขั้นแรกวาดลงผืนผ้าใบขนาดจำกัด เพื่อไม่ต้องไล่พิกเซลของรูปถ่ายความละเอียดสูงทั้งใบ
  const scanScale = Math.min(1, 1200 / img.naturalWidth, 600 / img.naturalHeight);
  const scanWidth = Math.max(1, Math.round(img.naturalWidth * scanScale));
  const scanHeight = Math.max(1, Math.round(img.naturalHeight * scanScale));

  const scan = document.createElement('canvas');
  scan.width = scanWidth;
  scan.height = scanHeight;
  const scanCtx = scan.getContext('2d');
  if (!scanCtx) throw new SignatureImageError('เบราว์เซอร์นี้ประมวลผลรูปภาพไม่ได้');
  scanCtx.drawImage(img, 0, 0, scanWidth, scanHeight);

  const bounds = removeBackground(scanCtx, scanWidth, scanHeight);
  if (!bounds) {
    throw new SignatureImageError('ไม่พบลายเส้นในรูป กรุณาใช้รูปลายเซ็นที่ชัดกว่านี้');
  }

  const padding = 6;
  const cropX = Math.max(0, bounds.minX - padding);
  const cropY = Math.max(0, bounds.minY - padding);
  const cropWidth = Math.min(scanWidth - cropX, bounds.maxX - bounds.minX + 1 + padding * 2);
  const cropHeight = Math.min(scanHeight - cropY, bounds.maxY - bounds.minY + 1 + padding * 2);

  // ย่อลงทีละขั้นจนกว่า data URL จะพอดีกับคอลัมน์ TEXT — รูปถ่ายพื้นมีนอยส์จะกินที่มากกว่าลายเส้นสะอาด
  for (const maxWidth of [600, 480, 360, 260, 180]) {
    const scale = Math.min(1, maxWidth / cropWidth, 220 / cropHeight);
    const outWidth = Math.max(1, Math.round(cropWidth * scale));
    const outHeight = Math.max(1, Math.round(cropHeight * scale));

    const out = document.createElement('canvas');
    out.width = outWidth;
    out.height = outHeight;
    const outCtx = out.getContext('2d');
    if (!outCtx) throw new SignatureImageError('เบราว์เซอร์นี้ประมวลผลรูปภาพไม่ได้');
    outCtx.clearRect(0, 0, outWidth, outHeight);
    outCtx.imageSmoothingQuality = 'high';
    outCtx.drawImage(scan, cropX, cropY, cropWidth, cropHeight, 0, 0, outWidth, outHeight);

    const dataUrl = out.toDataURL('image/png');
    if (dataUrl.length <= SIGNATURE_MAX_DATA_URL_LENGTH) return dataUrl;
  }

  throw new SignatureImageError(
    'รูปลายเซ็นมีรายละเอียดมากเกินไป กรุณาใช้รูปที่ตัดเฉพาะลายเซ็นบนพื้นขาว',
  );
}
