<?php
/**
 * Plugin Name: Suppress Signup Emails
 * Plugin URI: https://github.com/koldpress/wordpress-multisite-docker
 * Description: Suppresses new user signup notification emails in WordPress Multisite installations.
 * Version: 1.0.0
 * Author: KoldPress
 * License: GPL v2 or later
 * Network: true
 * 
 * This plugin prevents WordPress Multisite from sending signup notification emails
 * to new users when they register on subsites. This is useful for development
 * environments or when you want to handle user notifications differently.
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Suppress WordPress Multisite signup notification emails
 * 
 * This filter tells Multisite to bypass the new-user signup email.
 * When this filter returns false, WordPress will not send the signup
 * notification email to new users.
 * 
 * @return bool Always returns false to suppress signup emails
 */
add_filter('wpmu_signup_user_notification', '__return_false');

/**
 * Optional: Also suppress blog signup notification emails
 * 
 * Uncomment the line below if you also want to suppress emails
 * sent when new sites are created in the multisite network.
 */
// add_filter('wpmu_signup_blog_notification', '__return_false');

/**
 * Optional: Suppress welcome emails for new users
 * 
 * Uncomment the line below if you want to suppress welcome emails
 * sent to users after they activate their account.
 */
// add_filter('wpmu_welcome_user_notification', '__return_false');
