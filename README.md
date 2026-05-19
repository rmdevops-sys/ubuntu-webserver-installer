# Ubuntu Webserver Installer

Automated Ubuntu web server setup and DevOps toolkit by RMDevOps-SYS.

Repository:
https://github.com/rmdevops-sys/ubuntu-webserver-installer

---

# Features

✔ Apache2 Installation  
✔ MySQL Server Installation  
✔ PHP 8.x + Extensions  
✔ phpMyAdmin Setup  
✔ Composer Installation  
✔ Node.js & NPM Installation  
✔ Redis Server Installation  
✔ UFW Firewall Configuration  
✔ Fail2Ban Security Setup  
✔ SSL Ready with Certbot  
✔ Swap Memory Setup  
✔ Apache Optimization  
✔ Laravel Ready Environment  
✔ PHP Optimization  
✔ Firewall Security Rules  
✔ Developer Utilities Installation  

---

# Installed Components

## Web Server
- Apache2

## Database
- MySQL Server

## PHP Extensions
- php
- php-cli
- php-common
- php-mysql
- php-curl
- php-gd
- php-mbstring
- php-xml
- php-bcmath
- php-zip
- php-intl
- php-soap
- php-imagick

## Developer Tools
- Composer
- Node.js
- NPM
- Git
- Curl
- Wget
- Nano
- Vim
- Htop
- Net Tools
- ZIP / Unzip

## Security Tools
- UFW Firewall
- Fail2Ban
- Certbot SSL

## Additional Services
- Redis Server
- Supervisor
- FFmpeg
- ImageMagick

---

# Supported Operating Systems

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

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

Run installer:

```bash
sudo bash setup.sh
```

---

# Firewall Rules

The installer automatically opens:

| Service | Port |
|---|---|
| SSH | 22 |
| HTTP | 80 |
| HTTPS | 443 |

---

# Web Root

```text
/var/www/html
```

---

# PHP Test URL

```text
http://YOUR_SERVER_IP/info.php
```

---

# phpMyAdmin URL

```text
http://YOUR_SERVER_IP/phpmyadmin
```

---

# SSL Setup

Run after domain setup:

```bash
sudo certbot --apache
```

---

# MySQL Security

After installation run:

```bash
sudo mysql_secure_installation
```

---

# Useful Commands

## Apache

```bash
systemctl status apache2
systemctl restart apache2
```

## MySQL

```bash
systemctl status mysql
systemctl restart mysql
```

## Redis

```bash
systemctl status redis-server
systemctl restart redis-server
```

## Firewall

```bash
ufw status
```

## Fail2Ban

```bash
systemctl status fail2ban
```

## Node.js

```bash
node -v
npm -v
```

## Composer

```bash
composer --version
```

---

# Security Features

✔ UFW Firewall Enabled  
✔ SSH Protection  
✔ Fail2Ban Brute-force Protection  
✔ SSL Ready Environment  
✔ Apache Security Modules Enabled  

---

# Laravel Ready

This installer is optimized for:

- Laravel
- WordPress
- PHP Applications
- VPS Hosting
- Production Servers
- Development Environments

---

# Future Plans

- Docker Installation
- Nginx Support
- Multi PHP Version Support
- Automatic SSL Configuration
- CyberPanel Integration
- Backup Automation
- Monitoring Tools

---

# Author

RMDevOps-SYS

GitHub:
https://github.com/rmdevops-sys

---

# License

MIT License
