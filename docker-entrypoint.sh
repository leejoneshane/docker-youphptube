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
  fi
fi

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
