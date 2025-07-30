<?php
/**
 * Plugin Name: Fix Admin MIME Types
 * Description: Fixes MIME type issues for WordPress admin CSS and JS files
 * Version: 1.0
 */

// Fix MIME types for load-styles.php and load-scripts.php
add_action('init', function() {
    if (is_admin() || (isset($_SERVER['REQUEST_URI']) && 
        (strpos($_SERVER['REQUEST_URI'], 'load-styles.php') !== false || 
         strpos($_SERVER['REQUEST_URI'], 'load-scripts.php') !== false))) {
        
        if (strpos($_SERVER['REQUEST_URI'], 'load-styles.php') !== false) {
            header('Content-Type: text/css; charset=UTF-8');
        } elseif (strpos($_SERVER['REQUEST_URI'], 'load-scripts.php') !== false) {
            header('Content-Type: application/javascript; charset=UTF-8');
        }
    }
}, 1);

// Alternative approach - hook into WordPress script/style loading
add_action('wp_loaded', function() {
    if (isset($_GET['load']) && is_admin()) {
        if (basename($_SERVER['SCRIPT_NAME']) === 'load-styles.php') {
            header('Content-Type: text/css; charset=UTF-8');
        } elseif (basename($_SERVER['SCRIPT_NAME']) === 'load-scripts.php') {
            header('Content-Type: application/javascript; charset=UTF-8');
        }
    }
});