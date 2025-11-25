# Nginx SSL Setup Instructions

## Prerequisites

1. **DNS Configuration**: Ensure `n8n.kamka.cloud` DNS A record points to `132.220.216.17`
2. **Firewall**: Ensure ports 80 and 443 are open on your server
3. **Email**: Update the email in `init-letsencrypt.sh` (line 11) if needed

## Setup Steps

### 1. Verify DNS is configured
```bash
dig n8n.kamka.cloud
# or
nslookup n8n.kamka.cloud
```
Should return: `132.220.216.17`

### 2. Start the services (without SSL first)
```bash
docker compose up -d nginx certbot
```

### 3. Initialize SSL certificates
```bash
cd /Users/macbook/Documents/elepzia/n8n-autoscaling
./nginx/init-letsencrypt.sh
```

This script will:
- Create temporary dummy certificates
- Start nginx
- Request real Let's Encrypt certificates
- Reload nginx with real certificates

### 4. Verify SSL is working
Visit `https://n8n.kamka.cloud` in your browser. You should see:
- A valid SSL certificate (green lock icon)
- The n8n interface

### 5. Start all services
```bash
docker compose up -d
```

## Automatic Certificate Renewal

The `certbot` service automatically renews certificates every 12 hours. Certificates are valid for 90 days.

## Manual Certificate Renewal

If needed, you can manually renew:
```bash
./nginx/renew.sh
```

## Troubleshooting

### nginx won't start
- Check logs: `docker compose logs nginx`
- Verify nginx.conf syntax: `docker compose exec nginx nginx -t`

### SSL certificate errors
- Verify DNS: `dig n8n.kamka.cloud`
- Check certbot logs: `docker compose logs certbot`
- Ensure ports 80/443 are accessible from the internet

### Can't access n8n
- Check nginx is running: `docker compose ps nginx`
- Check n8n is running: `docker compose ps n8n`
- Verify nginx can reach n8n: `docker compose exec nginx wget -O- http://n8n:5678`

