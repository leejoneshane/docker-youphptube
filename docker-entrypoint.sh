#!/bin/sh
set -e

#if [ ! -f videos/configuration.php ]; then
#fi
    
if [! -e /run/mysqld ]; then
    /usr/bin/mysql_install_db --user=mysql 
fi

/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
