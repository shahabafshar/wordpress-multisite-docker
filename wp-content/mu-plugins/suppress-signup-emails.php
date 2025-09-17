<?php
/**
 * Plugin Name: Suppress Signup Emails
 * Description: Suppresses new user signup emails in WordPress Multisite
 * Version: 1.0.0
 * Author: Custom
 * Network: true
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Suppress signup emails in WordPress Multisite
 * 
 * This filter tells Multisite to bypass the new-user signup email.
 * When set to false, WordPress will not send the signup notification email
 * to new users during the registration process.
 */
add_filter('wpmu_signup_user_notification', '__return_false');

/**
 * Optional: Also suppress blog signup emails if needed
 * Uncomment the line below if you also want to suppress emails
 * when new sites are created in the multisite network
 */
// add_filter('wpmu_signup_blog_notification', '__return_false');

/**
 * Optional: Suppress welcome emails for new users
 * Uncomment the line below if you want to suppress welcome emails
 * that are sent after user activation
 */
// add_filter('wpmu_welcome_user_notification', '__return_false');
