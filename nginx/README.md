# Nginx SSL Setup for n8n

This directory contains the nginx configuration and SSL certificate setup for n8n.kamka.cloud.

## Initial SSL Certificate Setup

Before running the services, you need to obtain SSL certificates from Let's Encrypt:

1. **Ensure DNS is configured**: Make sure `n8n.kamka.cloud` points to your server IP (132.220.216.17)

2. **Start nginx without SSL first** (optional - nginx will start but HTTPS won't work until certs are obtained):
   ```bash
   docker compose up -d nginx
   ```

3. **Run the SSL initialization script**:
   ```bash
   ./nginx/init-letsencrypt.sh
   ```

   This script will:
   - Create dummy certificates so nginx can start
   - Start nginx
   - Request real certificates from Let's Encrypt
   - Reload nginx with the real certificates

4. **Verify SSL is working**:
   - Visit `https://n8n.kamka.cloud` in your browser
   - Check that you see a valid SSL certificate

## Automatic Certificate Renewal

The `certbot` service in docker-compose.yml automatically renews certificates every 12 hours. Certificates are valid for 90 days, so this ensures they're always renewed before expiration.

You can also manually renew certificates by running:
```bash
./nginx/renew.sh
```

## Configuration Files

- `nginx.conf` - Main nginx configuration with SSL and proxy settings
- `init-letsencrypt.sh` - Script to initialize Let's Encrypt certificates
- `renew.sh` - Script to manually renew certificates

## Troubleshooting

### Certificates not working
- Check that DNS is properly configured: `dig n8n.kamka.cloud` or `nslookup n8n.kamka.cloud`
- Ensure ports 80 and 443 are open in your firewall
- Check nginx logs: `docker compose logs nginx`
- Check certbot logs: `docker compose logs certbot`

### Certificate renewal failing
- Ensure the certbot container is running: `docker compose ps certbot`
- Check certbot logs for errors
- Verify DNS still points to the correct IP

### nginx not starting
- Check if certificates exist: `docker compose exec nginx ls -la /etc/letsencrypt/live/n8n.kamka.cloud/`
- Run the init script again if certificates are missing

