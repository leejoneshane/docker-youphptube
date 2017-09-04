FROM alpine

ENV DOMAIN your.domain
ENV SITE_TITLE your_site_title
ENV ADMIN_PASSWORD password
ENV ADMIN_EMAIL webmaster@your.domain
ENV DB_HOST localhost
ENV DB_USER root
ENV DB_PASSWORD password

ADD configuration.php /home/
ADD docker-entrypoint.sh /usr/local/bin/
ADD gencerts.sh /usr/local/bin/
WORKDIR /var/www/localhost/htdocs
RUN apk update  \
    && apk add --no-cache git curl certbot acme-client openssl mysql-client apache2 apache2-ssl php7 php7-apache2 php7-mysqlnd php7-mysqli php7-json php7-session php7-curl php7-gd php7-intl php7-exif php7-mbstring ffmpeg exiftool perl-image-exiftool python youtube-dl \
    && rm -rf /var/cache/apk/* \
    && mkdir /run/apache2 \
    && sed -ri \
           -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
           -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
           -e 's!^#(LoadModule rewrite_module .*)$!\1!g' \
           -e 's!^(\s*AllowOverride) None.*$!\1 All!g' \
           "/etc/apache2/httpd.conf" \
       \
    && sed -ri \
           -e 's!^(max_execution_time = )(.*)$!\1 7200!g' \
           -e 's!^(post_max_size = )(.*)$!\1 1G!g' \
           -e 's!^(upload_max_filesize = )(.*)$!\1 1G!g' \
           -e 's!^(memory_limit = )(.*)$!\1 1G!g' \
           "/etc/php7/php.ini" \
       \
    && rm -f index.html \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git \
    && mv YouPHPTube/* . \
    && mv YouPHPTube/.[!.]* . \
    && rm -rf YouPHPTube \
    && chmod a+rx /usr/local/bin/docker-entrypoint.sh \
    && chmod a+rx /usr/local/bin/gencerts.sh \
    && mkdir videos \
    && chmod 777 videos \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git \
    && chown -R apache:apache /var/www

ADD tw.php /var/www/localhost/htdocs/locale

VOLUME /var/www/localhost/htdocs/videos
EXPOSE 80 443
CMD ["docker-entrypoint.sh"]
