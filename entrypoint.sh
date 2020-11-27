#!/bin/sh
php /root/install.php
chown -R www-data:www-data /var/www/html
apache2-foreground
