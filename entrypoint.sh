#!/bin/sh
php /root/install.php
chown -R apache:apache /var/www/html
apache2-foreground
