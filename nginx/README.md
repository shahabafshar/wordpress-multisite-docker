# Nginx Configuration

This directory contains the Nginx configuration for the WordPress multisite Docker stack.

## Files

- `default.conf` - Main Nginx configuration file

## Configuration Features

### 🚀 Performance Optimizations
- **Gzip compression** - Optimized for text files, fonts, and images
- **Static file caching** - 1-year cache for static assets
- **Font optimization** - woff/woff2 compression
- **XML sitemap caching** - 1-day cache for SEO
- **JSON API caching** - 1-hour cache for REST API

### 🔒 Security Features
- **Rate limiting** - wp-login.php (1r/s), wp-admin (2r/s)
- **Security headers** - HSTS, CSP, XSS Protection, Permissions Policy
- **File access control** - wp-config.php, .htaccess blocking
- **PHP execution blocking** - No PHP in uploads
- **Sensitive file protection** - readme, license files blocked

### 🎯 WordPress Optimizations
- **Multisite support** - Subdirectory routing
- **Plugin compatibility** - Wordfence, Yoast SEO, WooCommerce
- **AJAX support** - admin-ajax.php handling
- **Cron support** - wp-cron.php access
- **Rewrite rules** - SEO-friendly URLs

## Customization

### Basic Customization

1. **Change server name:**
   ```nginx
   server_name yourdomain.com www.yourdomain.com;
   ```

2. **Add SSL configuration:**
   ```nginx
   listen 443 ssl;
   ssl_certificate /path/to/cert.pem;
   ssl_certificate_key /path/to/key.pem;
   ```

3. **Custom headers:**
   ```nginx
   add_header X-Custom-Header "value" always;
   ```

### Advanced Customization

1. **Modify rate limiting:**
   ```nginx
   limit_req_zone $binary_remote_addr zone=login:10m rate=2r/s;
   limit_req_zone $binary_remote_addr zone=admin:10m rate=5r/s;
   ```

2. **Add custom locations:**
   ```nginx
   location /custom-path {
       try_files $uri $uri/ /index.php?$args;
   }
   ```

3. **Modify caching rules:**
   ```nginx
   location ~* \.(js|css)$ {
       expires 2y;
       add_header Cache-Control "public, immutable";
   }
   ```

## Deployment

The configuration is automatically mounted into the Nginx container at deployment time:

```yaml
volumes:
  - ./nginx:/etc/nginx/conf.d
```

## Troubleshooting

### Configuration Validation
```bash
# Test Nginx configuration
docker exec -it CONTAINER_NAME nginx -t

# Reload configuration
docker exec -it CONTAINER_NAME nginx -s reload
```

### Common Issues

1. **Configuration not loaded:**
   - Check file permissions
   - Verify volume mount
   - Restart nginx service

2. **Rate limiting too strict:**
   - Adjust rate values in limit_req_zone
   - Increase burst values

3. **Caching not working:**
   - Check file extensions in gzip_types
   - Verify cache headers

## Best Practices

1. **Always test configuration** before deployment
2. **Use version control** for configuration changes
3. **Document customizations** in comments
4. **Monitor logs** for configuration errors
5. **Backup configuration** before major changes

## Plugin Compatibility

This configuration is optimized for:
- ✅ **Wordfence** - Security scanning
- ✅ **Yoast SEO** - XML sitemaps, caching
- ✅ **WooCommerce** - E-commerce
- ✅ **Contact Form 7** - AJAX support
- ✅ **Caching plugins** - Performance optimization 