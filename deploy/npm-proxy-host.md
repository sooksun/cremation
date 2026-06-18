# Nginx Proxy Manager — Cremation Welfare System

Deploy path บน server: `/DATA/AppData/www/cremation`  
Ports (LAN only): web `9930`, api `9931`

## Proxy Host

| Tab | Field | Value |
|-----|-------|-------|
| Details | Domain Names | `your-domain.example` |
| Details | Forward Hostname/IP | LAN IP ของ host (`hostname -I`) |
| Details | Forward Port | `9930` |
| Details | Cache Assets / Block Common Exploits / Websockets | ✓ |
| Custom locations | Define location | `/api/` |
| Custom locations | Forward to | `<HOST_IP>:9931` |
| Custom locations | Custom Nginx Configuration | `client_max_body_size 25M; proxy_read_timeout 300s; proxy_send_timeout 300s;` |
| SSL | SSL Certificate | Request a new SSL Certificate |
| SSL | Force SSL / HTTP-2 | ✓ |
| SSL | HSTS | OFF จนกว่า HTTPS เสถียร 24h+ |

## หลัง deploy

```bash
cd /DATA/AppData/www/cremation
docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f api
```

## Security checklist

- อย่า port-forward `9930/9931` ที่ router — เปิดแค่ 80/443 ผ่าน NPM
- เปลี่ยนรหัส seed (`owner123!`) ทันทีหลัง login
- `.env.production` ต้องอยู่ใน `.gitignore`