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
  
  if mysqlshow --host=${DB_HOST} --user=${DB_USER} --password=${DB_PASSWORD} youPHPTube; then
    echo "database exist!"
  else
    echo "CREATE DATABASE youPHPTube CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}" youPHPTube < /var/www/localhost/htdocs/install/database.sql
    echo "USE youPHPTube; INSERT INTO users (id, user, password, created, modified, isAdmin) VALUES (1, 'admin', md5('${ADMIN_PASSWORD}'), now(), now(), true);" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube; INSERT INTO categories (id, name, clean_name, created, modified) VALUES (1, 'Default', 'default', now(), now());" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube; INSERT INTO configurations (id, video_resolution, users_id, version, webSiteTitle, language, contactEmail,  created, modified, encoderURL) VALUES (1, '858:480', 1,'4.0', '${SITE_TITLE}', '${LANG}', '${ADMIN_EMAIL}', now(), now(), 'https://${DOMAIN}/encoder');" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
  fi

  if mysqlshow --host=${DB_HOST} --user=${DB_USER} --password=${DB_PASSWORD} youPHPTube-Encoder; then
    echo "database exist!"
  else
    echo "CREATE DATABASE youPHPTube-Encoder CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}" youPHPTube-Encoder < /var/www/localhost/htdocs/encoder/install/database.sql
    echo "USE youPHPTube-Encoder; INSERT INTO streamers (id, siteURL, user, pass, priority, isAdmin, created, modified) VALUES (1, 'https://${DOMAIN}', 'admin', '${ADMIN_PASSWORD}', 1, 1, now(), now());" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
    echo "USE youPHPTube-Encoder; INSERT INTO configurations (id, allowedStreamerURL, defaultPriority, created, modified, version) VALUES (1, 'https://${DOMAIN}', 1, now(), now(), '1.0');" | mysql --host="${DB_HOST}" --user="${DB_USER}" --password="${DB_PASSWORD}"
  fi
fi

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
