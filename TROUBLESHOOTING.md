# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 1. WordPress Multisite Not Working

**Symptoms:**
- Redirect loops on subsite admin
- 404 errors for CSS/JS files
- "Constant WP_ALLOW_MULTISITE already defined" errors

**Solutions:**

#### Check Domain Configuration
Ensure your `.env` file has the correct domain:
```env
DOMAIN_CURRENT_SITE=your-actual-domain.com
```

#### Verify HTTPS Configuration
If using HTTPS, ensure WordPress is configured for it:
```bash
# Check current site URL
docker exec -it CONTAINER_NAME wp option get home --allow-root
docker exec -it CONTAINER_NAME wp option get siteurl --allow-root
```

#### Check Multisite Constants
Verify multisite is properly configured:
```bash
# Check wp-config.php constants
docker exec -it CONTAINER_NAME wp config get MULTISITE --allow-root
docker exec -it CONTAINER_NAME wp config get DOMAIN_CURRENT_SITE --allow-root
```

#### Check .htaccess File
Ensure the .htaccess file exists and has proper multisite rules:
```bash
# Check if .htaccess exists
docker exec -it CONTAINER_NAME ls -la /var/www/html/.htaccess

# View .htaccess content
docker exec -it CONTAINER_NAME cat /var/www/html/.htaccess
```

#### Check Database Tables
Verify multisite database tables are properly set up:
```bash
# Check if multisite tables exist
docker exec -it CONTAINER_NAME wp db query "SHOW TABLES LIKE 'wp_blogs'" --allow-root
docker exec -it CONTAINER_NAME wp db query "SHOW TABLES LIKE 'wp_site'" --allow-root

# Check if main site is properly registered
docker exec -it CONTAINER_NAME wp db query "SELECT * FROM wp_blogs WHERE blog_id = 1" --allow-root
```

### 2. Database Connection Issues

**Error:**
```
Access denied for user 'wpuser'@'172.19.0.4' (using password: YES)
```

**Solution:**
- Verify `.env` file has correct database credentials
- Ensure MariaDB container is running
- Check network connectivity between containers

### 3. WP-CLI Initialization Issues

**Error:**
```
wp-cli-init container exits with error
```

**Solutions:**

#### Check Container Logs
```bash
docker-compose logs wp-cli-init
```

#### Verify Database is Ready
The WP-CLI container waits for the database. If it fails:
```bash
# Check database container
docker-compose logs db

# Restart the stack
docker-compose restart
```

#### Check File Permissions
```bash
# Verify WordPress files are accessible
docker exec -it CONTAINER_NAME ls -la /var/www/html/
```

### 4. Port Access Issues

**Issue:** Port 8080 not responding

**Solutions:**

#### Check Container Status
```bash
docker ps
docker logs CONTAINER_NAME-wordpress-1
```

#### Verify Port Mapping
```bash
# Check if port is actually bound
netstat -tlnp | grep 8080
```

#### Test Container Directly
```bash
# Test WordPress inside container
docker exec -it CONTAINER_NAME curl localhost
```

### 5. Permission Issues

**Error:**
```
Warning: Unable to create directory wp-content/uploads/2025/08
```

**Solution:**
This is normal for host-mounted volumes. WordPress will create directories as needed:
```bash
# WordPress handles this automatically
# No manual intervention required
```

### 6. Memory/Resource Issues

**Error:**
```
Container killed due to memory limit
```

**Solution:**
- Increase Docker memory limits
- Optimize PHP settings
- Monitor resource usage

## Debugging Commands

### Check Container Logs
```bash
# All containers
docker-compose logs

# Specific service
docker-compose logs wordpress
docker-compose logs db
docker-compose logs wp-cli-init
```

### Check Container Status
```bash
# Running containers
docker ps

# All containers (including stopped)
docker ps -a
```

### Test Services
```bash
# Test database connection
docker exec -it CONTAINER_NAME mysql -u root -p -e "SHOW DATABASES;"

# Test Redis connection
docker exec -it CONTAINER_NAME-redis-1 redis-cli ping

# Test WordPress
docker exec -it CONTAINER_NAME wp core version --allow-root
```

### Check Network
```bash
# List networks
docker network ls

# Inspect network
docker network inspect wordpress-multisite-docker_wordpress_network
```

## Common Portainer Issues

### 1. Repository Deployment Fails

**Solution:**
- Check repository URL is correct
- Verify compose path is `docker-compose.yml`
- Ensure all required files are in the repository

### 2. Environment Variables Not Loading

**Solution:**
- Use the Environment Variables section in Portainer
- Don't rely on `.env` file for repository deployment
- Add variables manually in Portainer interface

### 3. Volume Mounting Issues

**Solution:**
- Use named volumes instead of bind mounts
- Create volumes manually in Portainer if needed
- Check volume permissions

## Performance Issues

### 1. Slow Loading

**Diagnosis:**
```bash
# Check resource usage
docker stats

# Check WordPress logs
docker exec -it CONTAINER_NAME tail -f /var/log/apache2/access.log
```

**Solutions:**
- Enable Redis caching
- Optimize PHP settings
- Increase container resources

### 2. High Memory Usage

**Solutions:**
- Reduce PHP worker processes
- Optimize MariaDB settings
- Enable Redis for object caching

## SSL/HTTPS Issues

### 1. SSL Certificate Problems

**Solution:**
- Use a reverse proxy (like Traefik, Caddy, or Nginx Proxy Manager) for SSL termination
- Configure SSL in reverse proxy
- Verify certificate paths and permissions

### 2. Mixed Content Warnings

**Solution:**
- Update WordPress site URL to HTTPS
- Configure proper security headers
- Use relative URLs in content

## Backup and Recovery

### Database Backup
```bash
# Create backup
docker exec -it CONTAINER_NAME mysqldump -u root -p wordpress > backup.sql

# Restore backup
docker exec -i CONTAINER_NAME mysql -u root -p wordpress < backup.sql
```

### File Backup
```bash
# Backup WordPress files
docker cp CONTAINER_NAME:/var/www/html ./wordpress-backup

# Backup volumes
docker run --rm -v wordpress-multisite-docker_wordpress_data:/data -v $(pwd):/backup alpine tar czf /backup/wordpress-backup.tar.gz -C /data .
```

## Getting Help

1. **Check logs first** - Most issues are visible in container logs
2. **Verify configuration** - Ensure `.env` file is properly configured
3. **Test step by step** - Start with basic deployment, then add features
4. **Use debugging commands** - The commands above help identify issues
5. **Check documentation** - Review README.md for setup instructions

## Emergency Recovery

If the stack is completely broken:

```bash
# Stop and remove everything
docker-compose down -v

# Clean up volumes
docker volume prune

# Start fresh
docker-compose up -d
```

## WP-CLI Management

### Common WP-CLI Commands
```bash
# List all sites
docker exec -it CONTAINER_NAME wp site list --allow-root

# Create new site
docker exec -it CONTAINER_NAME wp site create --slug=newsite --title="New Site" --allow-root

# Update WordPress
docker exec -it CONTAINER_NAME wp core update --allow-root
docker exec -it CONTAINER_NAME wp core update-db --allow-root

# Check multisite status
docker exec -it CONTAINER_NAME wp core is-installed --network --allow-root
```

---

**Most issues can be resolved by checking logs and verifying the `.env` configuration.** 🔍 