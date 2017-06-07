#!/bin/sh
set -euo pipefail

if [[ "${DOMAIN}" != "your.domain" && "${DB_HOST}" != "localhost" ]]; then
  if [ ! -f videos/configuration.php ]; then
    cp /home/configuration.php /var/www/localhost/htdocs/videos/configuration.php
    sed -ri \
        -e "s!DOMAIN!${DOMAIN}!g" \
        -e "s!DB_HOST!${DB_HOST}!g" \
        -e "s!DB_USER!${DB_USER}!g" \
        -e "s!DB_PASSWORD!${DB_PASSWORD}!g" \
        "/var/www/localhost/htdocs/videos/configuration.php"
  fi
  
  RESULT=`mysqlshow --host=${DB_HOST} --user=${DB_USER} --password=${DB_PASSWORD} | grep youPHPTube`
  if [ -z "$RESULT" ]; then
    echo "CREATE DATABASE youPHPTube;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}" youPHPTube < /var/www/localhost/htdocs/install/database.sql
    echo "USE youPHPTube; INSERT INTO users (id, user, password, created, modified, isAdmin) VALUES (1, 'admin', md5('${ADMIN_PASSWORD}'), now(), now(), true);" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube; INSERT INTO categories (id, name, clean_name, created, modified) VALUES (1, 'Default', 'default', now(), now());" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube; INSERT INTO configurations (id, video_resolution, users_id, version, webSiteTitle, language, contactEmail,  created, modified) VALUES (1, '858:480', 1,'2.8', '${SITE_TITLE}', 'tw', '${ADMIN_EMAIL}', now(), now());" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
  else
    echo "USE youPHPTube; UPDATE users set password=md5('${ADMIN_PASSWORD}') where id = 1;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube; UPDATE configurations set webSiteTitle='${SITE_TITLE}', contactEmail='${ADMIN_EMAIL}', modified=now() where id = 1;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
  fi
fi

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
