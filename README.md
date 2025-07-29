# 🚀 WordPress Multisite Docker Stack

A production-ready WordPress multisite Docker stack optimized for performance, security, and popular plugins. **Multisite-only configuration - deploy with one click in Portainer!**

## ✨ Features

- ✅ **WordPress Multisite** - Ready out-of-the-box (multisite-only)
- ✅ **MariaDB 11.5** - Optimized database
- ✅ **Redis** - Object caching for performance
- ✅ **Nginx** - Optimized for WordPress and plugins
- ✅ **PHP 8.4-FPM** - Latest PHP with FPM
- ✅ **Plugin Optimized** - Wordfence, Yoast SEO, WooCommerce ready
- ✅ **Security Hardened** - Rate limiting, security headers
- ✅ **Performance Optimized** - Gzip, caching, compression
- ✅ **Portainer Ready** - Deploy with one click

## 🎯 Quick Start (Portainer)

### Option 1: One-Click Deploy
1. **Copy the repository URL:** `https://github.com/yourusername/wordpress-multisite-docker`
2. **In Portainer:** Stacks → Add Stack → Repository
3. **Paste the URL** and select `docker-compose.yml`
4. **Click Deploy** - That's it! 🎉

### Option 2: Manual Deploy
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/wordpress-multisite-docker
   cd wordpress-multisite-docker
   ```

2. **Copy environment file:**
   ```bash
   cp env.example .env
   ```

3. **Deploy in Portainer:**
   - Go to Stacks → Add Stack
   - Upload `docker-compose.yml`
   - Upload `.env` file
   - Click Deploy

## 🔧 Configuration

### Environment Variables
Edit `.env` file to customize your setup:

```bash
# Database settings
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=your-secure-password

# Redis
REDIS_VERSION=alpine

# WordPress Multisite settings
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=yourdomain.com
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1

# NGINX exposure
NGINX_LOCAL_PORT=8080
MARIADB_VERSION=11.5
```

### Port Configuration
- **Nginx:** `8080:80` (change in `.env` if needed)
- **Database:** Internal only (no external access)
- **Redis:** Internal only (no external access)

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx (8080)  │    │  WordPress      │    │   MariaDB       │
│   - Reverse     │◄──►│  PHP 8.4-FPM    │◄──►│   - Database    │
│   - Static      │    │  - Multisite    │    │   - Internal    │
│   - Security    │    │  - Plugins      │    │   - Optimized   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   Redis         │
                       │   - Caching     │
                       │   - Sessions    │
                       │   - Internal    │
                       └─────────────────┘
```

## 🚀 Automatic Setup

The stack automatically:
1. ✅ **Creates database** with proper credentials
2. ✅ **Installs WordPress** with multisite enabled
3. ✅ **Builds custom Nginx image** with optimized configuration
4. ✅ **Sets up Redis** for caching
5. ✅ **Applies security** headers and rate limiting
6. ✅ **Optimizes for plugins** (Wordfence, Yoast, WooCommerce)

## 📋 Post-Deployment

### 1. Access WordPress
- **URL:** `http://your-server:8080`
- **Complete WordPress installation**
- **Create admin account**

### 2. Verify Multisite
- **Check admin bar** for "My Sites"
- **Access Network Admin** at `/wp-admin/network/`
- **Create additional sites** as needed

### 3. Plugin Installation
The stack is optimized for:
- ✅ **Wordfence** - Security scanning
- ✅ **Yoast SEO** - XML sitemaps, caching
- ✅ **WooCommerce** - E-commerce
- ✅ **Contact Form 7** - AJAX support
- ✅ **Caching plugins** - Performance

## 🔒 Security Features

- **Rate limiting** on wp-login.php and wp-admin
- **Security headers** (HSTS, CSP, XSS Protection)
- **File access restrictions** (wp-config.php, .htaccess)
- **PHP execution blocked** in uploads
- **Sensitive file blocking** (readme, license files)

## ⚡ Performance Features

- **Gzip compression** for all text files
- **Static file caching** (1 year expiry)
- **Font optimization** (woff, woff2)
- **XML sitemap caching** (1 day)
- **JSON API caching** (1 hour)
- **Redis object caching**

## 🛠️ Management Commands

### Create New Site
```bash
docker exec -it CONTAINER_NAME wp site create --slug=newsite --title="New Site" --path=/var/www/html --allow-root
```

### List All Sites
```bash
docker exec -it CONTAINER_NAME wp site list --path=/var/www/html --allow-root
```

### Update WordPress
```bash
docker exec -it CONTAINER_NAME wp core update --path=/var/www/html --allow-root
docker exec -it CONTAINER_NAME wp core update-db --path=/var/www/html --allow-root
```

### Backup Database
```bash
docker exec -it CONTAINER_NAME mysqldump -u root -p wordpress > backup.sql
```

## 🔍 Troubleshooting

### Database Connection Issues
- Check `.env` file has correct database credentials
- Ensure MariaDB container is running
- Verify network connectivity between containers

### Multisite Setup Issues
- Follow the [MULTISITE-SETUP.md](MULTISITE-SETUP.md) guide
- Run multisite conversion manually if needed
- Check `.htaccess` file exists and has correct permissions

### Performance Issues
- Check Redis container is running
- Verify Nginx configuration is loaded
- Monitor container resource usage

## 📁 File Structure

```
wordpress-multisite-docker/
├── docker-compose.yml              # WordPress multisite configuration
├── env.example                     # Environment template
├── nginx/
│   ├── Dockerfile                  # Custom Nginx image
│   ├── default.conf                # Nginx configuration
│   └── .dockerignore               # Build optimization
├── setup-multisite.sh              # Multisite setup script
├── MULTISITE-SETUP.md              # Detailed setup guide
├── README.md                       # This file
└── .gitignore                      # Git ignore rules
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/wordpress-multisite-docker/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/wordpress-multisite-docker/discussions)
- **Documentation:** [MULTISITE-SETUP.md](MULTISITE-SETUP.md)

---

**Ready to deploy?** Just click deploy in Portainer and you'll have a production-ready WordPress multisite running in minutes! 🚀 