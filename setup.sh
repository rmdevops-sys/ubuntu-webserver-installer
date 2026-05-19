#!/bin/bash

# =========================================================
# Ubuntu Webserver Installer
# =========================================================
#
# Author      : RMDevOps-SYS
# Repository  : https://github.com/rmdevops-sys/ubuntu-webserver-installer
#
# Features:
# ✔ Apache2
# ✔ MySQL Server
# ✔ PHP 8.x + Extensions
# ✔ phpMyAdmin
# ✔ Composer
# ✔ Node.js & NPM
# ✔ Redis Server
# ✔ UFW Firewall
# ✔ Fail2Ban Security
# ✔ SSL Ready
# ✔ Swap Memory Setup
# ✔ Apache Optimization
# ✔ Laravel Ready
#
# Compatible:
# Ubuntu 22.04 / 24.04
#
# =========================================================

set -e

export DEBIAN_FRONTEND=noninteractive

# =========================================================
# COLORS
# =========================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# =========================================================
# ROOT CHECK
# =========================================================

if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}ERROR:${NC} Please run as root."
    echo ""
    echo "Usage:"
    echo "sudo bash setup.sh"
    exit 1
fi

clear

echo -e "${BLUE}"
echo "======================================================"
echo "         Ubuntu Webserver Installer"
echo "              RMDevOps-SYS"
echo "======================================================"
echo -e "${NC}"

sleep 2

# =========================================================
# UPDATE SYSTEM
# =========================================================

echo -e "${YELLOW}Updating system packages...${NC}"

apt update -y
apt upgrade -y

# =========================================================
# INSTALL BASE UTILITIES
# =========================================================

echo -e "${YELLOW}Installing required utilities...${NC}"

apt install -y \
software-properties-common \
apt-transport-https \
ca-certificates \
lsb-release \
curl \
wget \
git \
zip \
unzip \
nano \
vim \
htop \
net-tools \
ufw \
fail2ban \
redis-server \
certbot \
python3-certbot-apache \
build-essential \
imagemagick \
ffmpeg \
supervisor \
cron

# =========================================================
# INSTALL APACHE
# =========================================================

echo -e "${YELLOW}Installing Apache2...${NC}"

apt install -y apache2

systemctl enable apache2
systemctl start apache2

# =========================================================
# INSTALL MYSQL
# =========================================================

echo -e "${YELLOW}Installing MySQL Server...${NC}"

apt install -y mysql-server

systemctl enable mysql
systemctl start mysql

# =========================================================
# INSTALL PHP
# =========================================================

echo -e "${YELLOW}Installing PHP & Extensions...${NC}"

apt install -y \
php \
libapache2-mod-php \
php-cli \
php-common \
php-mysql \
php-curl \
php-gd \
php-mbstring \
php-xml \
php-bcmath \
php-zip \
php-intl \
php-soap \
php-imagick \
php-readline

# =========================================================
# INSTALL PHPMYADMIN
# =========================================================

echo -e "${YELLOW}Installing phpMyAdmin...${NC}"

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections

apt install -y phpmyadmin

# =========================================================
# ENABLE APACHE MODULES
# =========================================================

echo -e "${YELLOW}Enabling Apache modules...${NC}"

a2enmod rewrite
a2enmod headers
a2enmod ssl

# =========================================================
# APACHE CONFIGURATION
# =========================================================

echo -e "${YELLOW}Configuring Apache virtual host...${NC}"

cp /etc/apache2/sites-available/000-default.conf \
/etc/apache2/sites-available/000-default.conf.backup

cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>

    ServerAdmin admin@localhost
    ServerName localhost

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
        Options FollowSymLinks
    </Directory>

    DirectoryIndex index.php index.html

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF

apache2ctl configtest

systemctl restart apache2

# =========================================================
# PHP OPTIMIZATION
# =========================================================

echo -e "${YELLOW}Optimizing PHP configuration...${NC}"

PHPINI=$(php --ini | grep "Loaded Configuration" | awk '{print $4}')

sed -i 's/upload_max_filesize = .*/upload_max_filesize = 128M/' $PHPINI
sed -i 's/post_max_size = .*/post_max_size = 128M/' $PHPINI
sed -i 's/max_execution_time = .*/max_execution_time = 300/' $PHPINI
sed -i 's/memory_limit = .*/memory_limit = 512M/' $PHPINI

systemctl restart apache2

# =========================================================
# FILE PERMISSIONS
# =========================================================

echo -e "${YELLOW}Setting file permissions...${NC}"

mkdir -p /var/www/html

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# =========================================================
# FIREWALL CONFIGURATION
# =========================================================

echo -e "${YELLOW}Configuring UFW Firewall...${NC}"

ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp

ufw --force enable

# =========================================================
# FAIL2BAN CONFIGURATION
# =========================================================

echo -e "${YELLOW}Configuring Fail2Ban...${NC}"

systemctl enable fail2ban
systemctl start fail2ban

cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOF

systemctl restart fail2ban

# =========================================================
# INSTALL COMPOSER
# =========================================================

echo -e "${YELLOW}Installing Composer...${NC}"

cd /tmp

curl -sS https://getcomposer.org/installer -o composer-setup.php

HASH=$(curl -sS https://composer.github.io/installer.sig)

php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Composer installer verified'; } else { echo 'Composer installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

php composer-setup.php

mv composer.phar /usr/local/bin/composer

# =========================================================
# INSTALL NODE.JS & NPM
# =========================================================

echo -e "${YELLOW}Installing Node.js & NPM...${NC}"

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt install -y nodejs

# =========================================================
# CREATE SWAP MEMORY
# =========================================================

echo -e "${YELLOW}Creating swap memory...${NC}"

if [ ! -f /swapfile ]; then

    fallocate -l 2G /swapfile

    chmod 600 /swapfile

    mkswap /swapfile

    swapon /swapfile

    echo '/swapfile none swap sw 0 0' >> /etc/fstab

fi

# =========================================================
# CONFIGURE REDIS
# =========================================================

echo -e "${YELLOW}Configuring Redis server...${NC}"

systemctl enable redis-server
systemctl start redis-server

# =========================================================
# CREATE PHP TEST FILE
# =========================================================

echo -e "${YELLOW}Creating PHP info test file...${NC}"

cat > /var/www/html/info.php <<EOF
<?php
phpinfo();
?>
EOF

# =========================================================
# CLEAN SYSTEM
# =========================================================

echo -e "${YELLOW}Cleaning unused packages...${NC}"

apt autoremove -y
apt autoclean -y

# =========================================================
# RESTART SERVICES
# =========================================================

echo -e "${YELLOW}Restarting services...${NC}"

systemctl restart apache2
systemctl restart mysql
systemctl restart redis-server

# =========================================================
# FINAL OUTPUT
# =========================================================

clear

echo -e "${GREEN}"
echo "======================================================"
echo "        INSTALLATION COMPLETED SUCCESSFULLY"
echo "======================================================"
echo -e "${NC}"

echo ""

echo "Installed Services:"
echo "--------------------------------------------------"
echo "✔ Apache2"
echo "✔ MySQL Server"
echo "✔ PHP"
echo "✔ PHP Extensions"
echo "✔ phpMyAdmin"
echo "✔ Composer"
echo "✔ Node.js & NPM"
echo "✔ Redis Server"
echo "✔ Fail2Ban"
echo "✔ UFW Firewall"
echo "✔ Certbot SSL"
echo "✔ Git"
echo "✔ Curl"
echo "✔ Wget"
echo "✔ ZIP / Unzip"
echo "✔ Nano"
echo "✔ Vim"
echo "✔ Htop"
echo "✔ Net Tools"
echo "✔ Supervisor"
echo "✔ FFmpeg"
echo "✔ ImageMagick"

echo ""

echo "Firewall Ports Open:"
echo "--------------------------------------------------"
echo "✔ SSH   : 22"
echo "✔ HTTP  : 80"
echo "✔ HTTPS : 443"

echo ""

echo "Useful Commands:"
echo "--------------------------------------------------"
echo "Apache Status     : systemctl status apache2"
echo "Restart Apache    : systemctl restart apache2"
echo ""
echo "MySQL Status      : systemctl status mysql"
echo "Restart MySQL     : systemctl restart mysql"
echo ""
echo "Redis Status      : systemctl status redis-server"
echo "Restart Redis     : systemctl restart redis-server"
echo ""
echo "Firewall Status   : ufw status"
echo "Fail2Ban Status   : systemctl status fail2ban"
echo ""
echo "Check Node.js     : node -v"
echo "Check NPM         : npm -v"
echo "Check Composer    : composer --version"

echo ""

echo "Web Root:"
echo "--------------------------------------------------"
echo "/var/www/html"

echo ""

echo "PHP Test URL:"
echo "--------------------------------------------------"
echo "http://YOUR_SERVER_IP/info.php"

echo ""

echo "phpMyAdmin URL:"
echo "--------------------------------------------------"
echo "http://YOUR_SERVER_IP/phpmyadmin"

echo ""

echo "SSL Setup Command:"
echo "--------------------------------------------------"
echo "sudo certbot --apache"

echo ""

echo "MySQL Security Command:"
echo "--------------------------------------------------"
echo "sudo mysql_secure_installation"

echo ""

echo "GitHub Repository:"
echo "--------------------------------------------------"
echo "https://github.com/rmdevops-sys/ubuntu-webserver-installer"

echo ""

echo -e "${GREEN}Ubuntu Webserver Installer Finished.${NC}"

exit 0
