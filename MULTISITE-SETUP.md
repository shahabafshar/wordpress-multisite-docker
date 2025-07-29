# WordPress Multisite Setup Guide

## 🚨 Current Issue
The error `Table 'wordpress.wp_blogs' doesn't exist` occurs because WordPress needs to be converted to multisite after installation. This is a normal part of the multisite setup process.

## 🔧 Solution Options

### Option 1: Manual Setup (Recommended)

1. **First, install WordPress normally:**
   ```bash
   # Access your site at http://your-domain:8080
   # Complete the WordPress installation
   ```

2. **Convert to multisite using WP-CLI:**
   ```bash
   # Execute this command inside the WordPress container
   docker exec -it your-stack-name-wordpress-1 wp core multisite-convert --path=/var/www/html --allow-root
   ```

3. **Create the .htaccess file:**
   ```bash
   # Create .htaccess file for multisite
   docker exec -it your-stack-name-wordpress-1 bash -c 'cat > /var/www/html/.htaccess << "EOF"
   # BEGIN WordPress
   # The directives (lines) between "BEGIN WordPress" and "END WordPress" are
   # dynamically generated, and should only be modified via WordPress filters.
   # Any changes to the directives between these markers will be overwritten.
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

### Option 2: Automated Setup Script

1. **Make the script executable:**
   ```bash
   chmod +x setup-multisite.sh
   ```

2. **Run the setup script:**
   ```bash
   # After WordPress is installed, run:
   docker exec -it your-stack-name-wordpress-1 /bin/bash -c "cd /var/www/html && wp core multisite-convert --allow-root"
   ```

## 📋 Step-by-Step Process

### Step 1: Deploy the Stack
```bash
# Copy environment file
cp env.example .env

# Deploy the stack
docker-compose up -d
```

### Step 2: Install WordPress
1. Access `http://your-domain:8080`
2. Complete the WordPress installation
3. Create admin account

### Step 3: Convert to Multisite
```bash
# Get your container name
docker ps | grep wordpress

# Convert to multisite (replace CONTAINER_NAME with actual name)
docker exec -it CONTAINER_NAME wp core multisite-convert --path=/var/www/html --allow-root
```

### Step 4: Create .htaccess
```bash
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

### Step 5: Verify Setup
1. Access your WordPress site
2. You should see "My Sites" in the admin bar
3. Go to "My Sites > Network Admin" to manage multisite

## 🔍 Troubleshooting

### If you still get the wp_blogs error:
1. **Check if multisite conversion worked:**
   ```bash
   docker exec -it CONTAINER_NAME wp core is-installed --network --path=/var/www/html --allow-root
   ```

2. **Manually create multisite tables:**
   ```bash
   docker exec -it CONTAINER_NAME wp core multisite-install --path=/var/www/html --allow-root --title="My Network" --admin_user=admin --admin_password=your_password --admin_email=admin@example.com
   ```

### If .htaccess doesn't work:
1. **Check file permissions:**
   ```bash
   docker exec -it CONTAINER_NAME chmod 644 /var/www/html/.htaccess
   ```

2. **Verify .htaccess content:**
   ```bash
   docker exec -it CONTAINER_NAME cat /var/www/html/.htaccess
   ```

## 🎯 Expected Result

After successful setup:
- ✅ WordPress loads without errors
- ✅ "My Sites" appears in admin bar
- ✅ Network Admin is accessible
- ✅ You can create additional sites

## 📝 Environment Variables

Make sure your `.env` file has these multisite settings:
```bash
# Multisite settings
SUBDOMAIN_INSTALL=false
DOMAIN_CURRENT_SITE=dashplan.io
PATH_CURRENT_SITE=/
SITE_ID_CURRENT_SITE=1
BLOG_ID_CURRENT_SITE=1
```

## 🚀 Creating Additional Sites

After multisite is set up, you can create new sites:
```bash
# Create a new site
docker exec -it CONTAINER_NAME wp site create --slug=newsite --title="New Site" --path=/var/www/html --allow-root

# List all sites
docker exec -it CONTAINER_NAME wp site list --path=/var/www/html --allow-root
``` 