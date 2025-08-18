# WordPress Multisite Docker - Troubleshooting Guide

This guide covers common issues and solutions for the WordPress Multisite Docker stack.

## 🚨 Common Issues & Solutions

### 1. WordPress Not Responding

**Issue:** Port 8080 not responding after deployment

**Solutions:**

#### Check Container Status
```bash
docker ps
docker logs CONTAINER_NAME-wordpress-1
```

#### Verify Service Dependencies
The WordPress service depends on:
- Database (`db`) - must be started
- Redis (`redis`) - must be started  
- Initialization (`wp-init`) - must complete successfully

```bash
# Check all service statuses
docker-compose ps

# Check specific service logs
docker-compose logs db
docker-compose logs redis
docker-compose logs wp-init
docker-compose logs wordpress
```

#### Restart the Stack
```bash
docker-compose down
docker-compose up -d
```

### 2. Initialization Service Issues

**Error:**
```
wp-init container exits with error
```

**Solutions:**

#### Check Initialization Logs
```bash
docker-compose logs wp-init
```

#### Verify Database is Ready
The wp-init container waits for the database. If it fails:
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

### 3. Port Access Issues

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

### 4. Permission Issues

**Error:**
```
Warning: Unable to create directory wp-content/uploads/2025/08
```

**Solution:**
The wp-init service automatically creates all necessary upload directories with proper permissions. If you see this error:

```bash
# Check wp-init logs for permission setup
docker-compose logs wp-init | grep -i "upload\|permission"

# Restart the initialization service
docker-compose restart wp-init
```

### 5. Memory/Resource Issues

**Error:**
```
Container killed due to memory limit
```

**Solution:**
- Increase Docker memory limits
- Optimize PHP settings via environment variables
- Monitor resource usage

### 6. Upload Size Issues

**Error:**
```
File exceeds maximum upload size
```

**Solution:**
The stack is configured for 64MB uploads by default. To increase:

```bash
# Add to your .env file:
UPLOAD_MAX_FILESIZE=128M
POST_MAX_SIZE=128M
MEMORY_LIMIT=512M
```

The wp-init service creates a Must-Use plugin that enforces these limits at the WordPress application level.

## 🔍 Debugging Commands

### Check Container Logs
```bash
# All containers
docker-compose logs

# Specific service
docker-compose logs wordpress
docker-compose logs db
docker-compose logs wp-init
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
docker exec -it CONTAINER_NAME curl localhost
```

### Check WordPress Status
```bash
# Access wp-init container
docker exec -it CONTAINER_NAME-wp-init-1 bash

# Check WordPress installation
su -s /bin/sh www-data -c "wp core is-installed"

# Check multisite status
su -s /bin/sh www-data -c "wp site list"

# Check plugin status
su -s /bin/sh www-data -c "wp plugin list"
```

## 🚀 Performance Optimization

### Database Optimization
```bash
# Check database performance
docker exec -it CONTAINER_NAME mysql -u root -p -e "SHOW STATUS LIKE 'Slow_queries';"
```

### Redis Optimization
```bash
# Check Redis memory usage
docker exec -it CONTAINER_NAME-redis-1 redis-cli info memory
```

### WordPress Optimization
```bash
# Clear WordPress caches
docker exec -it CONTAINER_NAME-wp-init-1 su -s /bin/sh www-data -c "wp cache flush"

# Optimize database
docker exec -it CONTAINER_NAME-wp-init-1 su -s /bin/sh www-data -c "wp db optimize"
```

## 🔧 Advanced Troubleshooting

### Reset WordPress Installation
```bash
# Remove WordPress data volume
docker-compose down
docker volume rm wordpress-multisite-docker_wordpress_data

# Restart stack (will reinstall WordPress)
docker-compose up -d
```

### Debug PHP Configuration
```bash
# Check PHP settings inside WordPress container
docker exec -it CONTAINER_NAME php -i | grep -E "upload_max_filesize|post_max_size|memory_limit"
```

### Check File System
```bash
# Verify upload directory structure
docker exec -it CONTAINER_NAME ls -la /var/www/html/wp-content/uploads/

# Check permissions
docker exec -it CONTAINER_NAME ls -la /var/www/html/wp-content/
```

## 📞 Getting Help

If you continue to experience issues:

1. **Check logs first**: `docker-compose logs [service-name]`
2. **Verify environment variables**: Check your `.env` file
3. **Check system resources**: Ensure Docker has enough memory/CPU
4. **Review service dependencies**: Ensure all services start in correct order

The stack is designed to be self-healing and will automatically retry failed operations during initialization. 