# 🚀 WordPress Multisite Docker Stack

A production-ready WordPress Docker stack with **automatic WordPress Multisite installation**. Deploy with one click in Portainer and get a fully configured multisite network!

## ✨ Features

- ✅ **Fully Automated Multisite** - WordPress Multisite installs and configures automatically
- ✅ **Essential Plugins Included** - Wordfence, Yoast SEO, Contact Form 7, Google Site Kit, UpdraftPlus, NS Cloner, WP Super Cache, WooCommerce, Elementor
- ✅ **Zero Manual Steps** - No activation scripts or manual configuration needed
- ✅ **Automatic Upload Permissions** - Upload directories configured with proper permissions at deploy time
- ✅ **Error-Resilient Installation** - Plugin/theme failures won't stop the setup process
- ✅ **MariaDB 11.5** - Optimized database backend
- ✅ **Redis Caching** - Built-in performance optimization
- ✅ **WP-CLI Integration** - Automatic setup and configuration
- ✅ **Apache (Built-in)** - WordPress's native web server
- ✅ **HTTPS Ready** - Configured for secure connections
- ✅ **Editable Volumes** - Easy access to themes, plugins, and uploads
- ✅ **Portainer Ready** - Deploy with one click

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/wordpress-multisite-docker.git
   cd wordpress-multisite-docker
   ```

2. **Configure environment**
   ```bash
   cp env.example .env
   # Edit .env with your domain and settings
   ```

3. **Deploy with Portainer**
   - Go to Portainer → Stacks → Add Stack
   - Choose "Repository" method
   - Enter your Git repository URL
   - Click "Deploy the stack"

4. **Access your site**
   - **Frontend**: `http://your-server:8080`
   - **Admin**: `http://your-server:8080/wp-admin`
   - **Network Admin**: `http://your-server:8080/wp-admin/network`

**✅ That's it!** WordPress Multisite will be automatically installed with all essential plugins and themes.

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
- **🔧 Upload directory setup** - Automatically creates and sets permissions for upload directories
- **✅ Smart installation** - Skips already installed plugins/themes to avoid warnings

Check the `wp-init` container logs to see any warnings or failed installations.

### 🔧 Upload Directory Setup
The installation process automatically creates and secures upload directories:
- **Main Site**: `/wp-content/uploads/2025/08/`
- **Multisite Structure**: `/wp-content/uploads/sites/` (for future subsites)
- **Secure Permissions**: 755 (rwxr-xr-x) - owner can read/write/execute, others can read/execute
- **Proper Ownership**: `www-data:www-data` (web server user)
- **Security .htaccess**: Prevents directory browsing and file execution

### 🔒 Security Features
The stack includes multiple security layers:
- **File Upload Security**: Only allows specific file types (images, documents)
- **PHP Execution Prevention**: Blocks execution of uploaded PHP files
- **Directory Browsing**: Disabled to prevent information disclosure
- **Proper Permissions**: Minimal required permissions for web server operation
- **Network Isolation**: Services only communicate internally
- **WordPress Security**: Includes Wordfence plugin for additional protection

### 🔧 Automatic Upload Directory Setup

The stack includes an automatic upload permission system that runs before WordPress starts:

- **Pre-creates all necessary directories** - No more "directory doesn't exist" errors
- **Sets correct permissions** - `www-data:www-data` ownership with group-writable permissions
- **Year/month structure** - Pre-creates WordPress date-based upload paths for 2 years
- **Plugin directories** - Elementor, Unlimited Elements, and other common plugin upload paths
- **Security .htaccess** - Prevents PHP execution in upload directories
- **Multisite support** - Creates `wp-content/uploads/sites/` for subsite uploads

This eliminates the common WordPress multisite upload errors like:
- `mkdir(): Permission denied`
- `mkdir(): No such file or directory` 
- Plugin upload failures

### 📁 Upload Limits Configuration
The stack is configured to handle large image files by default:
- **Default Upload Size**: 64MB (configurable via environment variables)
- **Memory Limit**: 256MB for image processing
- **Execution Time**: 300 seconds for large file processing
- **Input Variables**: 3000 for complex forms

**To customize upload limits**, add these to your `.env` file:
```bash
UPLOAD_MAX_FILESIZE=128M      # Increase to 128MB
POST_MAX_SIZE=128M            # Increase to 128MB  
MEMORY_LIMIT=512M             # Increase to 512MB
MAX_EXECUTION_TIME=600        # Increase to 10 minutes
```

## 🔍 Troubleshooting

### Common Issues

**Upload Directory Issues**
- **"Unable to create directory" errors**: The security setup automatically creates required directories
- **Permission denied**: Proper ownership and permissions are set automatically
- **Multisite uploads fail**: Base multisite structure is created during installation

**Upload Size Issues**
- **"File exceeds maximum upload size"**: Default limit is 64MB, configurable via environment variables
- **Large image uploads fail**: Memory and execution time limits are increased automatically
- **High-resolution images not uploading**: Check UPLOAD_MAX_FILESIZE in your .env file

**Security Benefits**
- **File Upload Attacks**: Blocked by .htaccess rules preventing PHP execution
- **Directory Traversal**: Prevented by proper permissions and .htaccess
- **Information Disclosure**: Directory browsing is disabled
- **Malicious File Uploads**: Only safe file types are allowed

**Database Connection Issues**
- Check `.env` file has correct database credentials
- Ensure MariaDB container is running
- Verify network connectivity between containers

## 🏗️ Architecture

The stack uses a **script-based initialization approach** for maximum reliability:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   MariaDB       │    │   WordPress     │    │   Redis         │
│   - Database    │    │   - CMS         │    │   - Caching     │
│   - Internal    │    │   - Apache      │    │   - Sessions    │
│   - Internal    │    │   - Port 8080   │    │   - Internal    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   WP-CLI Init   │
                    │   - Auto Setup  │
                    │   - Script File │
                    │   - Internal    │
                    └─────────────────┘
```

### 🔧 Script-Based Initialization

**Why Script Files?**
- **✅ Reliable Parsing**: No Docker Compose YAML parsing issues
- **✅ Easy Maintenance**: Simple bash script, easy to edit and debug
- **✅ Version Control**: Script can be tracked separately from compose file
- **✅ Portainer Compatible**: Works reliably in all deployment scenarios
- **✅ Error Handling**: Comprehensive error handling and logging