# 🚀 Multi-Stack Deployment Guide

This guide explains how to deploy multiple instances of the WordPress multisite stack on the same Portainer server without conflicts.

## 🔍 **Why Multi-Stack Deployment?**

- **Multiple WordPress sites** on the same server
- **Different ports** for each deployment
- **Separate databases** and data
- **No resource conflicts**
- **Easy management** in Portainer

## 📋 **Required Environment Variables**

### **Core Stack Variables:**
```bash
# Stack Configuration (REQUIRED for multiple deployments)
STACK_NAME=wordpress-site1          # Unique name for each stack
EXTERNAL_PORT=8080                  # Unique port for each stack

# WordPress Configuration
WORDPRESS_TITLE=Site 1
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=securepassword123
WORDPRESS_ADMIN_EMAIL=admin@site1.com

# Database Configuration
WORDPRESS_DB_HOST=${STACK_NAME:-wordpress}-db
WORDPRESS_DB_NAME=wordpress
MYSQL_ROOT_PASSWORD=you-strong-complex-password
```

## 🎯 **Deployment Examples**

### **Stack 1: Main Site**
```bash
# .env file for Stack 1
STACK_NAME=wordpress-main
EXTERNAL_PORT=8080
WORDPRESS_TITLE="Main WordPress Site"
WORDPRESS_ADMIN_EMAIL=admin@main-site.com
MYSQL_ROOT_PASSWORD=main-site-password-123
```

**Result:**
- Services: `wordpress-main-wp-init`, `wordpress-main-wordpress`, `wordpress-main-db`, `wordpress-main-redis`
- Port: `8080`
- Volumes: `wordpress-main_wordpress_data`, `wordpress-main_db_data`, `wordpress-main_redis_data`
- Network: `wordpress-main_network`

### **Stack 2: Client Site**
```bash
# .env file for Stack 2
STACK_NAME=wordpress-client
EXTERNAL_PORT=8081
WORDPRESS_TITLE="Client WordPress Site"
WORDPRESS_ADMIN_EMAIL=admin@client-site.com
MYSQL_ROOT_PASSWORD=client-site-password-456
```

**Result:**
- Services: `wordpress-client-wp-init`, `wordpress-client-wordpress`, `wordpress-client-db`, `wordpress-client-redis`
- Port: `8081`
- Volumes: `wordpress-client_wordpress_data`, `wordpress-client_db_data`, `wordpress-client_redis_data`
- Network: `wordpress-client_network`

### **Stack 3: Development Site**
```bash
# .env file for Stack 3
STACK_NAME=wordpress-dev
EXTERNAL_PORT=8082
WORDPRESS_TITLE="Development WordPress Site"
WORDPRESS_ADMIN_EMAIL=admin@dev-site.com
MYSQL_ROOT_PASSWORD=dev-site-password-789
```

**Result:**
- Services: `wordpress-dev-wp-init`, `wordpress-dev-wordpress`, `wordpress-dev-db`, `wordpress-dev-redis`
- Port: `8082`
- Volumes: `wordpress-dev_wordpress_data`, `wordpress-dev_db_data`, `wordpress-dev_redis_data`
- Network: `wordpress-dev_network`

## 🔧 **Portainer Deployment Steps**

### **Step 1: Prepare Environment Files**
1. Create separate `.env` files for each stack
2. Ensure unique `STACK_NAME` and `EXTERNAL_PORT` values
3. Use different database passwords for security

### **Step 2: Deploy Stack 1**
1. In Portainer, go to **Stacks** → **Add Stack**
2. **Name**: `wordpress-main`
3. **Build method**: Upload
4. Upload `docker-compose.yml` and `.env` (Stack 1)
5. Click **Deploy the stack**

### **Step 3: Deploy Stack 2**
1. **Name**: `wordpress-client`
2. Upload `docker-compose.yml` and `.env` (Stack 2)
3. Click **Deploy the stack**

### **Step 4: Deploy Stack 3**
1. **Name**: `wordpress-dev`
2. Upload `docker-compose.yml` and `.env` (Stack 3)
3. Click **Deploy the stack**

## 🌐 **Access Your Sites**

### **Stack 1 (Main Site):**
- **URL**: `http://your-server:8080`
- **Admin**: `http://your-server:8080/wp-admin`
- **Network Admin**: `http://your-server:8080/wp-admin/network`

### **Stack 2 (Client Site):**
- **URL**: `http://your-server:8081`
- **Admin**: `http://your-server:8081/wp-admin`
- **Network Admin**: `http://your-server:8081/wp-admin/network`

### **Stack 3 (Development Site):**
- **URL**: `http://your-server:8082`
- **Admin**: `http://your-server:8082/wp-admin`
- **Network Admin**: `http://your-server:8082/wp-admin/network`

## 🔒 **Security Considerations**

### **Database Security:**
- Use **different passwords** for each stack
- Each stack has **isolated databases**
- No cross-stack data access

### **Network Security:**
- Each stack has **separate networks**
- Services cannot communicate between stacks
- **Port isolation** prevents conflicts

### **Volume Security:**
- Each stack has **separate volumes**
- No data sharing between stacks
- **Complete isolation** of WordPress data

## 📊 **Resource Management**

### **Port Usage:**
- Stack 1: Port 8080
- Stack 2: Port 8081
- Stack 3: Port 8082
- **No port conflicts**

### **Volume Management:**
- Each stack creates **unique volume names**
- Easy to identify in Portainer
- **Simple backup and restore**

### **Service Management:**
- **Clear naming convention**
- Easy to identify in Portainer
- **Independent scaling** possible

## 🚨 **Troubleshooting**

### **Port Already in Use:**
```bash
# Check what's using the port
netstat -tlnp | grep :8080

# Change EXTERNAL_PORT in .env file
EXTERNAL_PORT=8083
```

### **Service Name Conflicts:**
- Ensure `STACK_NAME` is unique
- Check Portainer for existing stacks
- Use descriptive names (e.g., `wordpress-main`, `wordpress-client`)

### **Volume Conflicts:**
- Each stack automatically creates unique volume names
- No manual volume management needed
- Volumes are automatically named: `stackname_servicename`

## ✅ **Benefits of Multi-Stack Deployment**

1. **Complete Isolation** - No resource sharing between stacks
2. **Easy Management** - Clear naming in Portainer
3. **Independent Scaling** - Scale each stack separately
4. **Simple Backup** - Each stack has its own volumes
5. **Port Flexibility** - Choose any available ports
6. **Security** - No cross-stack access possible

## 🎯 **Best Practices**

1. **Use descriptive stack names** (e.g., `wordpress-main`, `wordpress-client`)
2. **Document port assignments** for each stack
3. **Use different database passwords** for security
4. **Monitor resource usage** across all stacks
5. **Regular backups** of each stack's volumes
6. **Test deployments** in development first

---

**Your WordPress multisite stack is now ready for multiple deployments on the same Portainer server! 🎉**
