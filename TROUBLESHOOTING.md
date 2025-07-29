# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 1. Nginx Configuration Not Found

**Error:**
```
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf is not a file or does not exist
```

**Cause:** The Nginx configuration file is not being loaded properly.

**Solutions:**

#### Option A: Check File Exists
```bash
# Verify the nginx directory and file exist
ls -la nginx/
cat nginx/default.conf
```

#### Option B: Manual Configuration (Portainer)
If deploying via Portainer repository and the file isn't loading:

1. **Deploy without Nginx config first:**
   ```yaml
   # Temporarily comment out the configs section in docker-compose.yml
   # configs:
   #   nginx_config:
   #     file: ./nginx/default.conf
   ```

2. **Add configuration manually:**
   - Go to Portainer → Volumes
   - Create a new volume called `nginx_config`
   - Browse the volume and create `default.conf`
   - Copy content from `nginx/default.conf`

3. **Update docker-compose.yml:**
   ```yaml
   volumes:
     - nginx_config:/etc/nginx/conf.d
   ```

#### Option C: Embedded Configuration
If external file loading continues to fail, embed the configuration directly:

```yaml
configs:
  nginx_config:
    content: |
      # Copy the entire content of nginx/default.conf here
      server {
          listen 80;
          # ... rest of configuration
      }
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

### 3. WordPress Multisite Setup Issues

**Error:**
```
Table 'wordpress.wp_blogs' doesn't exist
```

**Solution:**
1. Complete WordPress installation first
2. Convert to multisite:
   ```bash
   docker exec -it CONTAINER_NAME wp core multisite-convert --path=/var/www/html --allow-root
   ```

### 4. Port Access Issues

**Issue:** Port 8080 not responding

**Solutions:**

#### Check Container Status
```bash
docker ps
docker logs CONTAINER_NAME-nginx-1
```

#### Verify Port Mapping
```bash
# Check if port is actually bound
netstat -tlnp | grep 8080
```

#### Test Container Directly
```bash
# Test nginx inside container
docker exec -it CONTAINER_NAME-nginx-1 nginx -t
docker exec -it CONTAINER_NAME-nginx-1 curl localhost
```

### 5. Permission Issues

**Error:**
```
Permission denied
```

**Solution:**
```bash
# Fix file permissions
chmod 644 nginx/default.conf
chmod 755 nginx/
```

### 6. Memory/Resource Issues

**Error:**
```
Container killed due to memory limit
```

**Solution:**
- Increase Docker memory limits
- Reduce worker processes in Nginx
- Optimize PHP-FPM settings

## Debugging Commands

### Check Container Logs
```bash
# All containers
docker-compose logs

# Specific service
docker-compose logs nginx
docker-compose logs wordpress
docker-compose logs db
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

# Test Nginx configuration
docker exec -it CONTAINER_NAME-nginx-1 nginx -t
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

# Check Nginx access logs
docker exec -it CONTAINER_NAME-nginx-1 tail -f /var/log/nginx/access.log
```

**Solutions:**
- Enable Redis caching
- Optimize Nginx configuration
- Increase container resources

### 2. High Memory Usage

**Solutions:**
- Reduce PHP-FPM worker processes
- Optimize MariaDB settings
- Enable Redis for object caching

## SSL/HTTPS Issues

### 1. SSL Certificate Problems

**Solution:**
- Use Nginx Proxy Manager for SSL termination
- Configure SSL in Nginx configuration
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

# Backup Nginx configuration
cp nginx/default.conf ./nginx-backup.conf
```

## Getting Help

1. **Check logs first** - Most issues are visible in container logs
2. **Verify configuration** - Ensure all files are properly configured
3. **Test step by step** - Start with basic deployment, then add features
4. **Use debugging commands** - The commands above help identify issues
5. **Check documentation** - Review README.md and other guides

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

---

**Most issues can be resolved by checking logs and verifying configuration files.** 🔍 