#!/bin/sh

# Generate strong DH parameters, if they don't already exist.
if [ ! -f /etc/apache2/conf.d/dhparams.pem ]; then
   openssl dhparam -out /etc/apache2/conf.d/dhparams.pem 2048
fi

# Initial certificate request, but skip if cached
if [ ! -f /etc/letsencrypt/live/${DOMAIN}/fullchain.pem ]; then
  certbot certonly --webroot \
   --webroot-path=/var/www/localhost/htdocs/ \
   --domain ${DOMAIN} \
   --email "${ADMIN_EMAIL}" --agree-tos
fi

sed -ri \
    -e "s!^(ServerName )(.*)!\1 ${DOMAIN}!g" \
    -e "s!^(SSLCertificateFile )(.*)!\1 /etc/letsencrypt/live/${DOMAIN}/cert.pem!g" \
    -e "s!^(SSLCertificateKeyFile )(.*)!\1 /etc/letsencrypt/live/${DOMAIN}/privkey.pem!g" \
    -e "s!^#(SSLCertificateChainFile )(.*)!\1 /etc/letsencrypt/live/${DOMAIN}/chain.pem!g" \
    "/etc/apache2/conf.d/ssl.conf"
