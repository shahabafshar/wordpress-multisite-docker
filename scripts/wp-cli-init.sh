#!/bin/bash
set -e

# Ensure we run from the WordPress root
cd /var/www/html || exit 1

echo '⏳ Waiting for database and WordPress to be ready...'
sleep 15

echo '🔧 Setting up upload directory permissions...'
# Create main site upload directories with secure permissions
mkdir -p /var/www/html/wp-content/uploads/2025/08 || echo '⚠️  Main upload directory creation failed, continuing...'
# Create multisite upload base directory for future subsites
mkdir -p /var/www/html/wp-content/uploads/sites || echo '⚠️  Multisite upload directory creation failed, continuing...'

# Set proper permissions hierarchy for WordPress to create subdirectories
# wp-content directory: 755 (www-data can write to it)
chmod 755 /var/www/html/wp-content || echo '⚠️  wp-content permissions failed, continuing...'
# uploads directory: 755 (www-data can write to it and create subdirectories)
chmod 755 /var/www/html/wp-content/uploads || echo '⚠️  uploads permissions failed, continuing...'
# Set proper ownership to www-data (web server user)
chown -R www-data:www-data /var/www/html/wp-content/uploads || echo '⚠️  Upload directory ownership failed, continuing...'

# Create .htaccess to prevent direct access to uploads (security)
echo 'Options -Indexes' > /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess creation failed, continuing...'
echo 'Order deny,allow' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 1 failed, continuing...'
echo 'Deny from all' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 2 failed, continuing...'
# Allow only image and document files (prevent PHP execution)
echo '<FilesMatch "\.(jpg|jpeg|png|gif|webp|pdf|doc|docx|xls|xlsx|ppt|pptx|txt|zip|rar)$">' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 3 failed, continuing...'
echo '    Allow from all' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 4 failed, continuing...'
echo '</FilesMatch>' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 5 failed, continuing...'
# Prevent execution of any uploaded files (security)
echo '<FilesMatch "\.(php|php3|php4|php5|phtml|pl|py|jsp|asp|sh|cgi)$">' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 6 failed, continuing...'
echo '    Deny from all' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 7 failed, continuing...'
echo '</FilesMatch>' >> /var/www/html/wp-content/uploads/.htaccess || echo '⚠️  Upload .htaccess rule 8 failed, continuing...'

echo '🔍 Checking if WordPress is already installed...'
if wp core is-installed --allow-root 2>/dev/null; then
  echo '✅ WordPress is already installed!'
else
  echo '📝 Installing WordPress...'
  wp core install --url="https://${DOMAIN_CURRENT_SITE}" --title="${WORDPRESS_TITLE}" --admin_user="${WORDPRESS_ADMIN_USER}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --skip-email --allow-root
  
  echo '🔧 Configuring WordPress...'
  wp option update home "https://${DOMAIN_CURRENT_SITE}" --allow-root
  wp option update siteurl "https://${DOMAIN_CURRENT_SITE}" --allow-root
  wp option update timezone_string UTC --allow-root
  wp option update date_format 'F j, Y' --allow-root
  wp option update time_format 'g:i a' --allow-root
  wp rewrite structure '/%postname%/' --allow-root
  wp rewrite flush --allow-root
  
  echo '✅ WordPress installed and configured successfully!'
  echo '🚀 Enabling multisite...'
  wp core multisite-install --title="${WORDPRESS_TITLE}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --allow-root
  
  echo '🔧 Adding multisite constants to wp-config.php...'
  wp config set WP_ALLOW_MULTISITE true --raw --allow-root
  wp config set MULTISITE true --raw --allow-root
  wp config set SUBDOMAIN_INSTALL "${SUBDOMAIN_INSTALL:-false}" --raw --allow-root
  wp config set DOMAIN_CURRENT_SITE "${DOMAIN_CURRENT_SITE}" --allow-root
  wp config set PATH_CURRENT_SITE "/" --allow-root
  wp config set SITE_ID_CURRENT_SITE 1 --raw --allow-root
  wp config set BLOG_ID_CURRENT_SITE 1 --raw --allow-root
  
  echo '🔧 Ensuring multisite database tables are properly set up...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_blogs (blog_id bigint(20) NOT NULL AUTO_INCREMENT, site_id bigint(20) NOT NULL DEFAULT '1', domain varchar(200) NOT NULL DEFAULT '', path varchar(100) NOT NULL DEFAULT '', registered datetime NOT NULL DEFAULT '0000-00-00 00:00:00', last_updated datetime NOT NULL DEFAULT '0000-00-00 00:00:00', public tinyint(2) NOT NULL DEFAULT '1', archived enum('0','1') NOT NULL DEFAULT '0', mature tinyint(2) NOT NULL DEFAULT '0', spam tinyint(2) NOT NULL DEFAULT '0', deleted tinyint(2) NOT NULL DEFAULT '0', lang_id int(11) NOT NULL DEFAULT '0', PRIMARY KEY (blog_id), KEY domain (domain(50),path(5)), KEY lang_id (lang_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_blogs table creation failed, continuing...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_blog_versions (blog_id bigint(20) NOT NULL DEFAULT '0', db_version varchar(20) NOT NULL DEFAULT '', last_updated datetime NOT NULL DEFAULT '0000-00-00 00:00:00', PRIMARY KEY (blog_id), KEY db_version (db_version)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_blog_versions table creation failed, continuing...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_registration_log (ID bigint(20) NOT NULL AUTO_INCREMENT, email varchar(255) NOT NULL DEFAULT '', IP varchar(30) NOT NULL DEFAULT '', blog_id bigint(20) NOT NULL DEFAULT '0', date_registered datetime NOT NULL DEFAULT '0000-00-00 00:00:00', PRIMARY KEY (ID), KEY IP (IP)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_registration_log table creation failed, continuing...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_signups (signup_id bigint(20) NOT NULL AUTO_INCREMENT, domain varchar(200) NOT NULL DEFAULT '', path varchar(100) NOT NULL DEFAULT '', title longtext NOT NULL, user_login varchar(60) NOT NULL DEFAULT '', user_email varchar(100) NOT NULL DEFAULT '', registered datetime NOT NULL DEFAULT '0000-00-00 00:00:00', activated datetime NOT NULL DEFAULT '0000-00-00 00:00:00', active tinyint(1) NOT NULL DEFAULT '0', activation_key varchar(50) NOT NULL DEFAULT '', meta longtext, PRIMARY KEY (signup_id), KEY activation_key (activation_key), KEY user_email (user_email), KEY user_login_email (user_login,user_email), KEY domain_path (domain,path)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_signups table creation failed, continuing...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_site (id bigint(20) NOT NULL AUTO_INCREMENT, domain varchar(200) NOT NULL DEFAULT '', path varchar(100) NOT NULL DEFAULT '', PRIMARY KEY (id), KEY domain (domain(140),path(51)), KEY path (path(51))) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_site table creation failed, continuing...'
  wp db query "CREATE TABLE IF NOT EXISTS wp_sitemeta (meta_id bigint(20) NOT NULL AUTO_INCREMENT, site_id bigint(20) NOT NULL DEFAULT '0', meta_key varchar(255) DEFAULT NULL, meta_value longtext, PRIMARY KEY (meta_id), KEY meta_key (meta_key(191)), KEY site_id (site_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" --allow-root || echo '⚠️  wp_sitemeta table creation failed, continuing...'
  wp db query "INSERT IGNORE INTO wp_blogs (blog_id, site_id, domain, path, registered, last_updated, public, archived, mature, spam, deleted, lang_id) VALUES (1, 1, '${DOMAIN_CURRENT_SITE}', '/', NOW(), NOW(), 1, 0, 0, 0, 0, 0)" --allow-root || echo '⚠️  wp_blogs insert failed, continuing...'
  wp db query "INSERT IGNORE INTO wp_site (id, domain, path) VALUES (1, '${DOMAIN_CURRENT_SITE}', '/')" --allow-root || echo '⚠️  wp_site insert failed, continuing...'
  
  echo '📄 Creating .htaccess for multisite...'
  if [ "${SUBDOMAIN_INSTALL:-false}" = "false" ]; then
    echo 'RewriteEngine On' > /var/www/html/.htaccess || echo '⚠️  .htaccess creation failed, continuing...'
    echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 1 failed, continuing...'
    echo 'RewriteBase /' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 2 failed, continuing...'
    echo 'RewriteRule ^index\.php$ - [L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 3 failed, continuing...'
    echo '' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 4 failed, continuing...'
    echo '# add a trailing slash to /wp-admin' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 5 failed, continuing...'
    echo 'RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ $1wp-admin/ [R=301,L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 6 failed, continuing...'
    echo '' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 7 failed, continuing...'
    echo 'RewriteCond %{REQUEST_FILENAME} -f [OR]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 8 failed, continuing...'
    echo 'RewriteCond %{REQUEST_FILENAME} -d' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 9 failed, continuing...'
    echo 'RewriteRule ^ - [L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 10 failed, continuing...'
    echo 'RewriteRule ^([_0-9a-zA-Z-]+/)?(wp-(content|admin|includes).*) $2 [L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 11 failed, continuing...'
    echo 'RewriteRule ^([_0-9a-zA-Z-]+/)?(.*\.php)$ $2 [L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 12 failed, continuing...'
    echo 'RewriteRule . index.php [L]' >> /var/www/html/.htaccess || echo '⚠️  .htaccess rule 13 failed, continuing...'
  fi
  
  echo '🔧 Verifying multisite setup...'
  wp core is-installed --network --allow-root
  
  echo '📦 Installing essential plugins...'
  if [ "${INSTALL_WORDFENCE:-true}" = "true" ]; then 
    if ! wp plugin is-installed wordfence --allow-root; then 
      wp plugin install wordfence --activate-network --allow-root || echo '⚠️  Wordfence installation failed, continuing...'
    else 
      echo '✅ Wordfence already installed'
    fi
  fi
  
  if [ "${INSTALL_YOAST_SEO:-true}" = "true" ]; then 
    if ! wp plugin is-installed wordpress-seo --allow-root; then 
      wp plugin install wordpress-seo --activate-network --allow-root || echo '⚠️  Yoast SEO installation failed, continuing...'
    else 
      echo '✅ Yoast SEO already installed'
    fi
  fi
  
  if [ "${INSTALL_CONTACT_FORM_7:-true}" = "true" ]; then 
    if ! wp plugin is-installed contact-form-7 --allow-root; then 
      wp plugin install contact-form-7 --activate-network --allow-root || echo '⚠️  Contact Form 7 installation failed, continuing...'
    else 
      echo '✅ Contact Form 7 already installed'
    fi
  fi
  
  if [ "${INSTALL_GOOGLE_SITE_KIT:-true}" = "true" ]; then 
    if ! wp plugin is-installed google-site-kit --allow-root; then 
      wp plugin install google-site-kit --activate-network --allow-root || echo '⚠️  Google Site Kit installation failed, continuing...'
    else 
      echo '✅ Google Site Kit already installed'
    fi
  fi
  
  if [ "${INSTALL_UPDRAFTPLUS:-true}" = "true" ]; then 
    if ! wp plugin is-installed updraftplus --allow-root; then 
      wp plugin install updraftplus --activate-network --allow-root || echo '⚠️  UpdraftPlus installation failed, continuing...'
    else 
      echo '✅ UpdraftPlus already installed'
    fi
  fi
  
  if [ "${INSTALL_NS_CLONER:-true}" = "true" ]; then 
    if ! wp plugin is-installed ns-cloner-site-copier --allow-root; then 
      wp plugin install ns-cloner-site-copier --activate-network --allow-root || echo '⚠️  NS Cloner installation failed, continuing...'
    else 
      echo '✅ NS Cloner already installed'
    fi
  fi
  
  if ! wp plugin is-installed wp-super-cache --allow-root; then 
    wp plugin install wp-super-cache --activate-network --allow-root || echo '⚠️  WP Super Cache installation failed, continuing...'
  else 
    echo '✅ WP Super Cache already installed'
  fi
  
  if [ "${INSTALL_ELEMENTOR:-true}" = "true" ]; then 
    if ! wp plugin is-installed elementor --allow-root; then 
      wp plugin install elementor --activate-network --allow-root || echo '⚠️  Elementor installation failed, continuing...'
    else 
      echo '✅ Elementor already installed'
    fi
  fi
  
  if [ "${INSTALL_WOOCOMMERCE:-true}" = "true" ]; then 
    if ! wp plugin is-installed woocommerce --allow-root; then 
      wp plugin install woocommerce --activate-network --allow-root || echo '⚠️  WooCommerce installation failed, continuing...'
    else 
      echo '✅ WooCommerce already installed'
    fi
  fi
  
  echo '🎨 Installing essential themes...'
  if ! wp theme is-installed twentytwentyfour --allow-root; then 
    wp theme install twentytwentyfour --allow-root || echo '⚠️  Twenty Twenty-Four theme installation failed, continuing...'
  else 
    echo '✅ Twenty Twenty-Four theme already installed'
  fi
  
  if ! wp theme is-installed twentytwentyfive --allow-root; then 
    wp theme install twentytwentyfive --allow-root || echo '⚠️  Twenty Twenty-Five theme installation failed, continuing...'
  else 
    echo '✅ Twenty Twenty-Five theme already installed'
  fi
  
  if ! wp theme is-installed hello-elementor --allow-root; then 
    wp theme install hello-elementor --activate --allow-root || echo '⚠️  Hello Elementor theme installation failed, continuing...'
  else 
    echo '✅ Hello Elementor theme already installed'
  fi
  
  echo '🔧 Configuring essential plugins...'
  wp option update blogname "${WORDPRESS_TITLE}" --allow-root || echo '⚠️  Blog name update failed, continuing...'
  wp option update blogdescription "Professional WordPress Multisite Network" --allow-root || echo '⚠️  Blog description update failed, continuing...'
  wp option update users_can_register 1 --allow-root || echo '⚠️  User registration setting failed, continuing...'
  wp option update default_role subscriber --allow-root || echo '⚠️  Default role setting failed, continuing...'
  
  echo '🔧 Configuring upload limits...'
  # Increase maximum upload size to 64MB (for high-resolution images)
  wp option update upload_size_limit "${UPLOAD_MAX_FILESIZE:-67108864}" --allow-root || echo '⚠️  Upload size limit update failed, continuing...'
  # Set maximum post size to 64MB
  wp option update post_max_size "${POST_MAX_SIZE:-67108864}" --allow-root || echo '⚠️  Post max size update failed, continuing...'
  # Set memory limit to 256MB for image processing
  wp option update memory_limit "${MEMORY_LIMIT:-268435456}" --allow-root || echo '⚠️  Memory limit update failed, continuing...'
  
  echo '🔧 Setting up basic multisite configuration...'
  wp site option update 1 blogname "${WORDPRESS_TITLE}" --allow-root || echo '⚠️  Site blog name update failed, continuing...'
  wp site option update 1 blogdescription 'Professional-WordPress-Multisite-Network' --allow-root || echo '⚠️  Site blog description update failed, continuing...'
  
  echo '✅ WordPress Multisite enabled successfully with essential plugins!'
  echo '📋 Installation Summary:'
  echo '   - WordPress Multisite: ✅ Installed'
  echo '   - Database Tables: ✅ Created'
  echo '   - .htaccess: ✅ Configured'
  echo '   - Themes: ✅ Installed'
  echo '   - Plugins: ✅ Installed (with error handling)'
  echo '   - Configuration: ✅ Applied'
  echo '🎉 Setup completed! Check logs for any warnings.'
fi


