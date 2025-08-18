# 🚨 Container Troubleshooting Guide

This guide helps resolve common container startup issues with the WordPress multisite Docker stack.

## 🔍 **Common Issues & Solutions**

### **1. "No such container" Error**

**Error Message:**
```
Unable to retrieve container: No such container: [container-id]
```

**What It Means:**
- Container was created but failed to start
- Container crashed immediately after creation
- Health checks are failing

**Solutions:**

#### **A. Check Service Logs**
```bash
# In Portainer, go to the failed stack
# Click on each service and check the logs
# Look for error messages at the bottom
```

#### **B. Verify Health Check Status**
```bash
# Check if services are marked as "healthy" in Portainer
# Unhealthy services will prevent wp-init from starting
```

#### **C. Restart the Stack**
```bash
# Sometimes a simple restart fixes timing issues
# In Portainer: Stacks → [Your Stack] → Restart
```

### **2. Database Connection Failures**

**Error Message:**
```
Error establishing a database connection
```

**Solutions:**

#### **A. Check Database Health**
```bash
# In Portainer, check the 'db' service logs
# Look for MariaDB startup messages
# Ensure no permission or configuration errors
```

#### **B. Verify Environment Variables**
```bash
# Check your .env file has correct values:
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=your-password
```

#### **C. Database Startup Time**
```bash
# MariaDB can take 1-2 minutes to fully start
# The health check waits up to 60 seconds
# Be patient during first deployment
```

### **3. WordPress Service Failures**

**Error Message:**
```
WordPress health check failed
```

**Solutions:**

#### **A. Check WordPress Logs**
```bash
# Look for PHP errors or configuration issues
# Check if wp-config.php is properly generated
```

#### **B. Verify File Permissions**
```bash
# WordPress needs write access to wp-content
# Check if volumes are properly mounted
```

### **4. Redis Connection Issues**

**Error Message:**
```
Redis health check failed
```

**Solutions:**

#### **A. Check Redis Logs**
```bash
# Look for Redis startup messages
# Ensure no port conflicts
```

#### **B. Verify Redis Configuration**
```bash
# Redis should start on default port 6379
# Check for any custom configuration conflicts
```

## 🛠️ **Debugging Steps**

### **Step 1: Check Service Status**
1. Go to **Portainer → Stacks**
2. Click on your stack name
3. Check the status of each service:
   - **Green**: Service is running and healthy
   - **Yellow**: Service is starting or unhealthy
   - **Red**: Service has failed

### **Step 2: Examine Service Logs**
1. Click on any failed service
2. Go to **Logs** tab
3. Look for error messages at the bottom
4. Common error patterns:
   - **Permission denied**: File permission issues
   - **Connection refused**: Service not ready
   - **Port already in use**: Port conflicts

### **Step 3: Check Health Check Status**
1. In service details, look for **Health** status
2. **Healthy**: Service passed all health checks
3. **Unhealthy**: Service failed health checks
4. **Starting**: Health checks haven't completed yet

### **Step 4: Verify Environment Variables**
1. Check your `.env` file
2. Ensure all required variables are set
3. Verify no syntax errors (no spaces around `=`)

## 🔧 **Quick Fixes**

### **Fix 1: Restart the Stack**
```bash
# In Portainer: Stacks → [Stack Name] → Restart
# This often resolves timing issues
```

### **Fix 2: Remove and Redeploy**
```bash
# If restart doesn't work:
# 1. Remove the stack completely
# 2. Wait 30 seconds
# 3. Deploy again
```

### **Fix 3: Check Port Conflicts**
```bash
# Ensure no other services use the same ports
# Check your EXTERNAL_PORT setting
```

### **Fix 4: Verify Resource Availability**
```bash
# Ensure your server has enough:
# - Memory (at least 2GB free)
# - Disk space (at least 5GB free)
# - CPU resources available
```

## 📊 **Health Check Configuration**

### **Current Settings (More Lenient):**
```yaml
# Database
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
  timeout: 30s
  retries: 15
  start_period: 60s
  interval: 10s

# Redis
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
  timeout: 15s
  retries: 10
  start_period: 30s
  interval: 10s

# WordPress
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/wp-admin/install.php"]
  timeout: 20s
  retries: 10
  start_period: 60s
  interval: 15s
```

### **What These Mean:**
- **`start_period`**: Time to wait before starting health checks
- **`interval`**: How often to run health checks
- **`timeout`**: Maximum time for each health check
- **`retries`**: How many failures before marking unhealthy

## 🚀 **Prevention Tips**

### **1. Use Proper Environment Variables**
```bash
# Always set these in your .env file:
EXTERNAL_PORT=8080
WORDPRESS_DB_HOST=db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=strong-password
```

### **2. Wait for Full Startup**
```bash
# First deployment can take 3-5 minutes
# Don't interrupt the process
# Let all health checks complete
```

### **3. Monitor Resource Usage**
```bash
# Check server resources during deployment
# Ensure adequate memory and CPU available
```

### **4. Use Descriptive Stack Names**
```bash
# Avoid generic names like "test" or "stack"
# Use names like "wordpress-main" or "wordpress-client"
```

## 📞 **Getting Help**

### **If Problems Persist:**

1. **Collect Information:**
   - Stack name and deployment time
   - Service status and health check results
   - Error messages from logs
   - Environment variable values (without passwords)

2. **Check Common Issues:**
   - Port conflicts
   - Insufficient resources
   - Network connectivity
   - File permissions

3. **Try Standard Fixes:**
   - Restart the stack
   - Remove and redeploy
   - Check server resources
   - Verify environment configuration

---

**Remember: Most container startup issues are resolved by checking logs, verifying configuration, and allowing adequate startup time. The health checks and restart policies should handle most transient failures automatically.** 🎯
