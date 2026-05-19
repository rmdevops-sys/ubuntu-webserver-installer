# Ubuntu Webserver Installer

Automated Ubuntu web server setup script for developers, VPS hosting, and production environments.

This script installs and configures:

- Apache2
- MySQL Server
- PHP & Extensions
- phpMyAdmin
- Composer
- Node.js & NPM
- Apache Rewrite Module
- Firewall Rules
- Basic Server Utilities

---

# Features

✔ One-click Ubuntu server setup  
✔ Apache virtual host configuration  
✔ PHP development environment  
✔ MySQL database server installation  
✔ phpMyAdmin support  
✔ Composer installation  
✔ Node.js & NPM installation  
✔ Secure Apache configuration  
✔ Automatic permissions setup  
✔ Ubuntu 22.04 / 24.04 compatible  

---

# Requirements

- Ubuntu 22.04 or 24.04
- Root or sudo access
- Internet connection

---

# Installation

Clone repository:

```bash
git clone https://github.com/rmdevops-sys/ubuntu-webserver-installer.git
```

Go to project directory:

```bash
cd ubuntu-webserver-installer
```

Make script executable:

```bash
chmod +x setup.sh
```

Run script:

```bash
sudo bash setup.sh
```

---

# Installed Packages

## Web Server
- Apache2

## Database
- MySQL Server

## PHP Packages
- php
- php-mysql
- php-curl
- php-gd
- php-mbstring
- php-xml
- php-zip
- php-bcmath
- php-intl

## Developer Tools
- Composer
- Git
- Curl
- Wget
- Node.js
- NPM

---

# Apache Root Directory

```text
/var/www/html
```

---

# Apache Configuration

The script automatically:

- Enables mod_rewrite
- Enables headers module
- Configures AllowOverride All
- Restarts Apache

---

# Security

Firewall configuration:

```bash
ufw allow 'Apache Full'
```

---

# Future Plans

- SSL Auto Setup
- Laravel Optimization
- Redis Installation
- Docker Installation
- Fail2Ban Security
- Multi PHP Version Support
- Nginx Support
- CyberPanel Integration

---
# Author
https://github.com/rmdevops-sys
---

# License

MIT License
