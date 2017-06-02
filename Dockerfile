FROM alpine

COPY httpd-foreground /usr/local/bin/
WORKDIR /var/www/localhost/htdocs
RUN apk update  \
    && apk add --no-cache git curl certbot acme-client openssl apache2 apache2-ssl php7-apache2 php7-mysqlnd php7-curl php7-gd php7-intl php7-exif php7-mbstring mysql-client ffmpeg exiftool perl-image-exiftool python \
    && rm -rf /var/cache/apk/* \
    && mkdir /run/apache2 \
    && sed -ri \
           -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
           -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
           -e 's!^#(LoadModule rewrite_module .*)$!\1!g' \
           "/etc/apache2/httpd.conf" \
       \
    && sed -ri \
           -e 's!^(max_execution_time = )(.*)$!\1 7200!g' \
           -e 's!^(post_max_size = )(.*)$!\1 10G!g' \
           -e 's!^(upload_max_filesize = )(.*)$!\1 10G!g' \
           -e 's!^(memory_limit = )(.*)$!\1 1G!g' \
           "/etc/php7/php.ini" \
       \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git \
    && mv YouPHPTube/* . \
    && rm -rf YouPHPTube \
    && curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod a+rx /usr/local/bin/youtube-dl \
    && chmod a+rx /usr/local/bin/httpd-foreground \
    && chown -R apache:apache /var/www \
    && mkdir videos \
    && chmod 777 videos

EXPOSE 80 443
CMD ["httpd-foreground"]
