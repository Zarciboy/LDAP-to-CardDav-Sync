# LDAP-to-CardDav-Sync

Turns Contacts form a LDAP-Server into VCards and uploads them to a Baikal CardDav-Server.
  1. Install Baikal
  2. Install and configure MySQL
  3. Go to "YOUR_BAIKAL_SERVER.com/ and setup Baikal with the Installation Wizard
  4. In the Baikal Web Admin under Database settings connect your MySQL with your credentials
  5. Create the upload_contacts.sh, delete_contacts.sh, sync_contacts.sh and LDAP-to-VCard.py scripts and adjust the paths
  6. Connect to the Server with your set credentials

## Baikal Installation on Ubuntu Server 24.04 LTS

System Update
```bash
  sudo apt update && sudo apt upgrade -y
```
Dependencies
```bash
  sudo apt install apache2 php php-mysql libapache2-mod-php unzip wget curl
```
Baikal Download https://github.com/sabre-io/Baikal/releases
```bash
  wget https://github.com/sabre-io/Baikal/releases/download/0.10.1/baikal-0.10.1.zip
```
```bash
  unzip Baikal.zip -d /var/www/baikal
```
```bash
  sudo chown -R www-data:www-data /var/www/baikal
  sudo chmod -R 755 /var/www/baikal
```
Edit apache2 Configuration
```bash
  sudo nano /etc/apache2/sites-available/baikal.conf
```
```bash
  <VirtualHost *:80>
    DocumentRoot /var/www/baikal/baikal/html
    ServerName YOUR_BAIKAL_SERVER.com

    RewriteEngine on
    RewriteRule /.well-known/carddav /dav.php [R=308,L]
    RewriteRule /.well-known/caldav /dav.php [R=308,L]

    <Directory "/var/www/baikal/baikal/html">
        Options None
        AllowOverride None
        Require all granted
    </Directory>

    <IfModule mod_expires.c>
        ExpiresActive Off
    </IfModule>
  </VirtualHost>
```
Starting Baikal
```bash
  sudo a2ensite baikal.conf
  sudo a2enmod rewrite
  sudo systemctl restart apache2

  sudo chmod -R 700 /var/www/baikal/baikal/Specific
  sudo chmod -R 700 /var/www/baikal/baikal/config
```
## MySQL Installation
Dependencies
```bash
  sudo apt update
  sudo apt install mysql-server
```
```bash
  sudo mysql_secure_installation
```
Start MySQL
```bash
  sudo systemctl start mysql
  sudo systemctl enable mysql
```
Configure MySQL
```bash
  sudo mysql -u root -p
```
```bash
  CREATE DATABASE baikal_db;

  CREATE USER 'baikal_user'@'localhost' IDENTIFIED BY 'your_password';
  
  GRANT ALL PRIVILEGES ON baikal_db.* TO 'baikal_user'@'localhost';

  FLUSH PRIVILEGES;
  EXIT;
```
## Automatic Contact Sync
Create the scripts, adjust the paths and make them executable: 

```bash
  sudo LDAP-to_VCard.py
  sudo nano upload_contacts.sh
  sudo nano delete_contacts.sh
  sudo nano sync_contacts.sh
```
```bash
  chmod +x SCRIPT_NAME.sh
```
Running the Sync once a day with:
```bash
  crontab -e

  0 0 * * * path/to/sync_contacts.sh
```
