#!/bin/sh
set -e

#if [ ! -f videos/configuration.php ]; then
#fi
    
if [! -d /run/mysqld ]; then
    /usr/bin/mysql_install_db --user=mysql 
fi

rm -f /run/apache2/httpd.pid

/usr/bin/mysqld_safe --datadir='/var/lib/mysql' && exec httpd -DFOREGROUND
