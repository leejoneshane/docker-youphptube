#!/bin/sh
set -e

if [ ! -f videos/configuration.php ]; then
  if [[ "${DOMAIN}" != "your.domain" && "${DB_HOST}" != "localhost" ]]; then
    cp /home/configuration.php /var/www/localhost/htdocs/videos/configuration.php
    sed -ri \
        -e "s!DOMAIN!${DOMAIN}!g" \
        -e "s!DB_HOST!${DB_HOST}!g" \
        -e "s!DB_USER!${DB_USER}!g" \
        -e "s!DB_PASSWORD!${DB_PASSWORD}!g" \
        "/var/www/localhost/htdocs/videos/configuration.php"
    RESULT=`mysqlshow --host=172.17.0.2 --user=root --password=12345678 | grep YouPHPTube`
    if [ -z "${RESULT}" ]; then
      echo "create database if not exists YouPHPTube;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
      mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}" YouPHPTube < /var/www/localhost/htdocs/install/database.sql
    fi
  fi
fi

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
