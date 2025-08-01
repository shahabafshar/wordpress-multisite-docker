# 🚀 WordPress Multisite Docker Stack

A production-ready WordPress Docker stack with **automatic WordPress Multisite installation**. Deploy with one click in Portainer and get a fully configured multisite network!

## ✨ Features

- ✅ **Fully Automated Multisite** - WordPress Multisite installs and configures automatically
- ✅ **Essential Plugins Included** - Wordfence, Yoast SEO, Contact Form 7, Google Site Kit, UpdraftPlus, NS Cloner, WP Super Cache, WooCommerce, Elementor
- ✅ **Zero Manual Steps** - No activation scripts or manual configuration needed
- ✅ **Error-Resilient Installation** - Plugin/theme failures won't stop the setup process
- ✅ **MariaDB 11.5** - Optimized database backend
- ✅ **Redis Caching** - Built-in performance optimization
- ✅ **WP-CLI Integration** - Automatic setup and configuration
- ✅ **Apache (Built-in)** - WordPress's native web server
- ✅ **HTTPS Ready** - Configured for secure connections
- ✅ **Editable Volumes** - Easy access to themes, plugins, and uploads
- ✅ **Portainer Ready** - Deploy with one click

## 🚀 Quick Start

### 1. Deploy the Stack

**Option A: Portainer (Recommended)**
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

### 2. Configure Environment

Edit `.env` file with your settings:

```env
# Database settings
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=your-strong-password

# Redis
REDIS_VERSION=alpine

# WordPress installation settings
WORDPRESS_TITLE=WordPress Multisite
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=securepassword123
WORDPRESS_ADMIN_EMAIL=admin@your-domain.com

# WordPress Multisite settings
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=your-domain.com
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1

# WordPress exposure
WORDPRESS_LOCAL_PORT=8080
MARIADB_VERSION=11.5
```

### 3. That's it! 🎉

**WordPress Multisite installs automatically during deployment with essential plugins!**

- **Main Site:** `https://your-domain.com`
- **Network Admin:** `https://your-domain.com/wp-admin/network/`
- **Create subsites** via Network Admin → Sites → Add New

**No manual steps required!** Just deploy and WordPress Multisite is ready to use.

## 📦 Included Plugins & Themes

### Essential Plugins (Network Activated)
- **🔒 Wordfence** - Security scanning and firewall
- **📊 Yoast SEO** - Search engine optimization
- **📧 Contact Form 7** - Contact forms
- **📊 Google Site Kit** - Google Analytics and Search Console
- **💾 UpdraftPlus** - Backup and restore
- **🔄 NS Cloner** - Site cloning for multisite
- **⚡ WP Super Cache** - Performance optimization
- **🎨 Elementor** - Page builder
- **🛒 WooCommerce** - E-commerce platform

### Essential Themes
- **🎨 Hello Elementor** - Default active theme (optimized for Elementor)
- **🎨 Twenty Twenty-Four** - Alternative theme
- **🎨 Twenty Twenty-Five** - Additional theme option

All plugins are **network-activated** and available to all subsites in the multisite network.

### Plugin Configuration
You can control which plugins are installed by setting environment variables in your `.env` file:
```env
# Set to false to skip specific plugins
INSTALL_WORDFENCE=true
INSTALL_YOAST_SEO=true
INSTALL_CONTACT_FORM_7=true
INSTALL_WOOCOMMERCE=true
INSTALL_ELEMENTOR=true
INSTALL_GOOGLE_SITE_KIT=true
INSTALL_UPDRAFTPLUS=true
INSTALL_NS_CLONER=true
# Note: WP Super Cache is always installed (replaces WP Rocket)
```

**Note:** Some plugins (like WP Super Cache and premium versions) may require licenses for full functionality. The stack installs the free versions by default.

### Error Handling
The installation process includes comprehensive error handling:
- **⚠️ Plugin failures** - If a plugin fails to install, the process continues with a warning
- **⚠️ Theme failures** - If a theme fails to install, the process continues with a warning
- **⚠️ Configuration failures** - If settings fail to apply, the process continues with a warning
- **📋 Installation summary** - Final summary shows what was successfully installed

Check the `wp-cli-init` container logs to see any warnings or failed installations.

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

## 🔧 Configuration

### Port Configuration
- **WordPress:** `8080:80` (change in `.env` if needed)
- **Database:** Internal only (no external access)
- **Redis:** Internal only (no external access)

### Automatic Setup Process

The stack automatically:
1. ✅ **Creates database** with proper credentials
2. ✅ **Installs WordPress** with multisite support
3. ✅ **Enables multisite** via WP-CLI
4. ✅ **Configures all constants** in wp-config.php
5. ✅ **Sets up .htaccess** with proper rewrite rules
6. ✅ **Installs essential plugins** (Wordfence, Yoast SEO, Google Site Kit, UpdraftPlus, NS Cloner, WP Super Cache, WooCommerce, etc.)
7. ✅ **Installs essential themes** (Hello Elementor, Twenty Twenty-Four, etc.)
8. ✅ **Configures Redis** for caching
9. ✅ **Error handling** - Continues installation even if individual plugins/themes fail

## 🛠️ Management Commands

### WP-CLI Commands
```bash
# Access WP-CLI in the container
docker exec -it CONTAINER_NAME wp --help

# List all sites
docker exec -it CONTAINER_NAME wp site list --allow-root

# Create new site
docker exec -it CONTAINER_NAME wp site create --slug=newsite --title="New Site" --allow-root

# Update WordPress
docker exec -it CONTAINER_NAME wp core update --allow-root
docker exec -it CONTAINER_NAME wp core update-db --allow-root
```

### Backup Database
```bash
docker exec -it CONTAINER_NAME mysqldump -u root -p wordpress > backup.sql
```

## 🔍 Troubleshooting

### Common Issues

**Database Connection Issues**
- Check `.env` file has correct database credentials
- Ensure MariaDB container is running
- Verify network connectivity between containers

**Multisite Setup Issues**
- Ensure `DOMAIN_CURRENT_SITE` in `.env` matches your actual domain
- Check that HTTPS is properly configured if using SSL
- Verify `.htaccess` file exists and has correct permissions

**Performance Issues**
- Check Redis container is running
- Monitor container resource usage
- Verify caching is working properly

## 📁 File Structure

```
wordpress-multisite-docker/
├── docker-compose.yml              # Main stack configuration
├── env.example                     # Environment template
├── README.md                       # This file
├── .gitignore                      # Git ignore rules
└── LICENSE                         # License file
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

---

**Ready to deploy?** Just click deploy in Portainer and you'll have a production-ready WordPress multisite running in minutes! 🚀 