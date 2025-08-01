# 🚀 WordPress Multisite Docker Stack

A production-ready WordPress Docker stack that installs as single-site and easily converts to multisite. Uses WordPress's built-in Apache server for simplicity and reliability. **Deploy with one click in Portainer!**

## ✨ Features

- ✅ **Fully Automated WordPress Multisite** - Installs and enables multisite automatically during deployment
- ✅ **MariaDB 11.5** - Optimized database
- ✅ **Redis** - Object caching for performance
- ✅ **WP-CLI** - Command-line WordPress management
- ✅ **Apache (Built-in)** - WordPress's native web server
- ✅ **PHP Latest** - Latest PHP with Apache
- ✅ **Plugin Optimized** - Wordfence, Yoast SEO, WooCommerce ready
- ✅ **Security Hardened** - WordPress security best practices
- ✅ **Performance Optimized** - Redis caching, optimized database
- ✅ **Portainer Ready** - Deploy with one click

## 🚀 Quick Start

### 1. Deploy the Stack

**Option A: Portainer Repository**
1. **In Portainer:** Stacks → Add Stack → Repository  
2. **Repository URL:** `https://github.com/yourusername/wordpress-multisite-docker`
3. **Compose file:** `docker-compose.yml`
4. **Environment file:** Upload `.env` (copy from `env.example`)
5. **Click Deploy**

**Option B: Local Docker**
```bash
git clone https://github.com/yourusername/wordpress-multisite-docker
cd wordpress-multisite-docker
cp env.example .env
# Edit .env with your settings
docker-compose up -d
```

### 2. That's it! 🎉

**WordPress Multisite installs automatically during deployment!**
- **Site URL:** `http://localhost:8080` (or your domain)
- **Admin URL:** `http://localhost:8080/wp-admin/`
- **Network Admin:** `http://localhost:8080/wp-admin/network/`
- **Username:** Use credentials from your `.env` file
- **Password:** Use credentials from your `.env` file

**No manual steps required!** Just deploy and WordPress Multisite is ready to use.

### 3. Multisite is Already Enabled! 🎉

**WordPress Multisite is automatically enabled during deployment!**
- **Network Admin:** `http://localhost:8080/wp-admin/network/`
- **Create New Sites:** Use Network Admin to add sites
- **Manage Network:** Install network-wide plugins and themes

**No additional steps needed!** Your multisite network is ready to use.

### 📝 Multisite Configuration

The multisite constants are automatically configured in `wp-config.php`:

```php
# These are automatically set during deployment:
define('MULTISITE', true);
define('SUBDOMAIN_INSTALL', false);
define('DOMAIN_CURRENT_SITE', 'yourdomain.com');
define('PATH_CURRENT_SITE', '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);
```

**Note:** All multisite configuration is handled automatically - no manual editing required!

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

# WordPress installation settings
WORDPRESS_TITLE=WordPress Multisite
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=securepassword123
WORDPRESS_ADMIN_EMAIL=admin@yourdomain.com

# WordPress Multisite settings (for activation script)
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=yourdomain.com
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1

# WordPress exposure
WORDPRESS_LOCAL_PORT=8080
MARIADB_VERSION=11.5
```

### Port Configuration
- **WordPress:** `8080:80` (change in `.env` if needed)
- **Database:** Internal only (no external access)
- **Redis:** Internal only (no external access)
- **WP-CLI:** Internal only (no external access)

### WP-CLI Usage
```bash
# Using helper script (recommended)
./scripts/wp-cli.sh --help
./scripts/wp-cli.sh plugin list
./scripts/wp-cli.sh core version
./scripts/wp-cli.sh user list

# Or directly with docker-compose
docker-compose exec wp-cli-init wp --help
docker-compose exec wp-cli-init wp plugin install wordfence --activate
docker-compose exec wp-cli-init wp core update
```

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   WordPress     │    │   MariaDB       │
│   - Apache      │◄──►│   - Database    │
│   - PHP Latest  │    │   - Internal    │
│   - Multisite   │    │   - Optimized   │
│   - Port 8080   │    │                 │
└─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│   Redis         │    │   WP-CLI Init   │
│   - Caching     │    │   - Auto Setup  │
│   - Sessions    │    │   - One-time    │
│   - Internal    │    │   - Internal    │
└─────────────────┘    └─────────────────┘
```

## 🚀 Automatic Setup

The stack automatically:
1. ✅ **Creates database** with proper credentials
2. ✅ **Installs WordPress** with multisite support ready
3. ✅ **Builds custom Nginx image** with optimized configuration
4. ✅ **Sets up Redis** for caching
5. ✅ **Applies security** headers and rate limiting
6. ✅ **Optimizes for plugins** (Wordfence, Yoast, WooCommerce)

## 📋 Post-Deployment

### 1. Access WordPress
- **URL:** `http://your-server:8080`
- **Complete WordPress installation**
- **Create admin account**

### 2. Activate Multisite (Optional)
- **Complete WordPress installation** first
- **Run activation script:** `./activate-multisite.sh`
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
├── activate-multisite.sh           # Manual multisite activation script
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