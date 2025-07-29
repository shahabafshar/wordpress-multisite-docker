# 🚀 Portainer Deployment Guide

## 🎯 Overview

This guide will walk you through deploying the WordPress Multisite Docker Stack using Portainer. The deployment is designed to be **one-click simple** and **production-ready**.

## 📋 Prerequisites

- ✅ **Portainer CE/EE** installed and running
- ✅ **Docker** and **Docker Compose** available
- ✅ **GitHub access** (for repository deployment)
- ✅ **Domain name** (optional, for production use)

## 🚀 Quick Deployment (Recommended)

### Step 1: Repository Deployment

1. **Open Portainer**
   - Navigate to your Portainer instance
   - Go to **Stacks** → **Add Stack**

2. **Configure Repository**
   - **Name:** `wordpress-multisite`
   - **Repository URL:** `https://github.com/yourusername/wordpress-multisite-docker`
   - **Repository reference:** `main` (or your preferred branch)
   - **Compose path:** `docker-compose.yml`
   - **Nginx configuration** will be automatically mounted from `nginx/default.conf`

3. **Environment Variables**
   - Click **Environment variables**
   - Add the following variables:

```bash
# Database settings
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=your-secure-password-here

# Redis
REDIS_VERSION=alpine

# Multisite settings
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=yourdomain.com
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1

# NGINX exposure
NGINX_LOCAL_PORT=8080
MARIADB_VERSION=11.5
```

4. **Deploy**
   - Click **Deploy the stack**
   - Wait for all services to start (2-3 minutes)

### Step 2: Verify Deployment

1. **Check Stack Status**
   - Go to **Stacks** → **wordpress-multisite**
   - All containers should show **Running** status

2. **Access WordPress**
   - Open browser to `http://your-server:8080`
   - Complete WordPress installation

3. **Convert to Multisite**
   ```bash
   # Get container name
   docker ps | grep wordpress
   
   # Convert to multisite
   docker exec -it CONTAINER_NAME wp core multisite-convert --path=/var/www/html --allow-root
   ```

## 🔧 Manual Deployment

### Step 1: Clone Repository

```bash
# SSH to your server
ssh user@your-server

# Clone the repository
git clone https://github.com/yourusername/wordpress-multisite-docker
cd wordpress-multisite-docker

# Copy environment file
cp env.example .env
```

### Step 2: Configure Environment

Edit `.env` file:

```bash
# Database settings
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=your-secure-password-here

# Redis
REDIS_VERSION=alpine

# Multisite settings
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=yourdomain.com
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1

# NGINX exposure
NGINX_LOCAL_PORT=8080
MARIADB_VERSION=11.5
```

### Step 3: Deploy in Portainer

1. **Upload Files**
   - Go to **Stacks** → **Add Stack**
   - **Name:** `wordpress-multisite`
   - **Build method:** Upload

2. **Upload Compose File**
   - Click **Choose file**
   - Select `docker-compose.yml`

3. **Upload Environment File**
   - Click **Environment variables**
   - Upload `.env` file or paste variables

4. **Deploy**
   - Click **Deploy the stack**

## 🔍 Post-Deployment Setup

### 1. WordPress Installation

1. **Access WordPress**
   - URL: `http://your-server:8080`
   - Complete the installation wizard
   - Create admin account

2. **Verify Installation**
   - Login to WordPress admin
   - Check that site is working

### 2. Multisite Conversion

```bash
# Get container name
docker ps | grep wordpress

# Convert to multisite
docker exec -it CONTAINER_NAME wp core multisite-convert --path=/var/www/html --allow-root

# Create .htaccess file
docker exec -it CONTAINER_NAME bash -c 'cat > /var/www/html/.htaccess << "EOF"
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF'
```

### 3. Verify Multisite

1. **Check Admin Bar**
   - Look for "My Sites" in admin bar
   - Click to access network admin

2. **Network Admin**
   - URL: `http://your-server:8080/wp-admin/network/`
   - Create additional sites

## 🔧 Nginx Configuration

### Customizing Nginx Configuration

The Nginx configuration is stored in `nginx/default.conf` and is automatically mounted into the container. You can customize it before deployment:

1. **Edit the configuration file:**
   ```bash
   # Modify nginx/default.conf to customize:
   # - Server name
   # - SSL settings
   # - Custom headers
   # - Rate limiting
   # - Caching rules
   ```

2. **Common customizations:**
   ```nginx
   # Change server name
   server_name yourdomain.com www.yourdomain.com;
   
   # Add SSL configuration
   listen 443 ssl;
   ssl_certificate /path/to/cert.pem;
   ssl_certificate_key /path/to/key.pem;
   
   # Custom headers
   add_header X-Custom-Header "value" always;
   ```

3. **After changes:**
   - Redeploy the stack to apply changes
   - Or restart the nginx service: `docker-compose restart nginx`

## 🔒 Security Configuration

### 1. Change Default Passwords

```bash
# Change database password
# Edit .env file and redeploy

# Change WordPress admin password
docker exec -it CONTAINER_NAME wp user update 1 --user_pass=your-new-password --path=/var/www/html --allow-root
```

### 2. Update Domain Settings

```bash
# Update site URL
docker exec -it CONTAINER_NAME wp option update home 'https://yourdomain.com' --path=/var/www/html --allow-root
docker exec -it CONTAINER_NAME wp option update siteurl 'https://yourdomain.com' --path=/var/www/html --allow-root
```

### 3. SSL Configuration

1. **Nginx Proxy Manager**
   - Add domain to NPM
   - Configure SSL certificate
   - Point to `nginx:80`

2. **Direct SSL**
   - Modify Nginx configuration
   - Add SSL certificates
   - Update port mapping

## 📊 Monitoring & Management

### 1. Container Monitoring

```bash
# Check container status
docker ps

# View logs
docker logs CONTAINER_NAME

# Monitor resources
docker stats
```

### 2. WordPress Management

```bash
# Create new site
docker exec -it CONTAINER_NAME wp site create --slug=newsite --title="New Site" --path=/var/www/html --allow-root

# List all sites
docker exec -it CONTAINER_NAME wp site list --path=/var/www/html --allow-root

# Update WordPress
docker exec -it CONTAINER_NAME wp core update --path=/var/www/html --allow-root
```

### 3. Database Management

```bash
# Backup database
docker exec -it CONTAINER_NAME mysqldump -u root -p wordpress > backup.sql

# Restore database
docker exec -i CONTAINER_NAME mysql -u root -p wordpress < backup.sql
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Database Connection Error
```bash
# Check database container
docker logs CONTAINER_NAME-db-1

# Verify environment variables
docker exec -it CONTAINER_NAME env | grep WORDPRESS_DB
```

#### 2. Multisite Setup Error
```bash
# Check if multisite is enabled
docker exec -it CONTAINER_NAME wp core is-installed --network --path=/var/www/html --allow-root

# Manual conversion
docker exec -it CONTAINER_NAME wp core multisite-convert --path=/var/www/html --allow-root
```

#### 3. Nginx Configuration Error
```bash
# Check Nginx logs
docker logs CONTAINER_NAME-nginx-1

# Verify configuration
docker exec -it CONTAINER_NAME-nginx-1 nginx -t
```

### Performance Issues

#### 1. Slow Loading
```bash
# Check Redis
docker exec -it CONTAINER_NAME-redis-1 redis-cli ping

# Monitor resources
docker stats
```

#### 2. Memory Issues
```bash
# Check memory usage
docker stats --no-stream

# Restart containers
docker-compose restart
```

## 📈 Scaling

### 1. Add More Sites

```bash
# Create additional sites
docker exec -it CONTAINER_NAME wp site create --slug=site2 --title="Site 2" --path=/var/www/html --allow-root
docker exec -it CONTAINER_NAME wp site create --slug=site3 --title="Site 3" --path=/var/www/html --allow-root
```

### 2. Resource Scaling

```bash
# Update compose file with resource limits
services:
  wordpress:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
```

### 3. Load Balancing

```bash
# Add multiple WordPress instances
# Update Nginx configuration for load balancing
# Use external database for scaling
```

## 🎯 Production Checklist

- ✅ **SSL Certificate** configured
- ✅ **Domain** pointing to server
- ✅ **Backup** strategy implemented
- ✅ **Monitoring** set up
- ✅ **Security** headers enabled
- ✅ **Performance** optimized
- ✅ **Multisite** conversion completed
- ✅ **Admin accounts** secured

## 🆘 Support

- **Documentation:** [README.md](README.md)
- **Multisite Setup:** [MULTISITE-SETUP.md](MULTISITE-SETUP.md)
- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions

---

**Your WordPress Multisite is now ready for production!** 🚀 