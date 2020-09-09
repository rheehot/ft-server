#!/bin/bash

ROOT_DIR="/var/www/localhost"

service mysql start

chown -R www-data /var/www/*
chmod -R 755 /var/www/*

echo "UPDATE mysql.user SET plugin = 'mysql_native_password'
		WHERE user='root';" | mysql -u root --skip-password
echo "CREATE DATABASE wordpress;" \
		| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* to 'root'@'localhost';" \
		| mysql -u root --skip-password
echo "FLUSH PRIVILEGES" \
		| mysql -u root --skip-password

tar -xvf phpMyAdmin-4.9.5-english.tar.gz
mv -f phpMyAdmin-4.9.5-english ${ROOT_DIR}/phpmyadmin
mv /var/config.inc.php ${ROOT_DIR}/phpmyadmin/

tar -xvf wordpress-5.5.1.tar.gz
mv -f wordpress ${ROOT_DIR}/wordpress
mv /var/wp-config.php ${ROOT_DIR}/wordpress/

service php7.3-fpm start
nginx -g "daemon off;"
