FROM php:7-apache

ENV DOMAIN your.domain
ENV DOMAIN_PROTOCOL http
ENV SITE_TITLE your_site_title
ENV ADMIN_PASSWORD password
ENV ADMIN_EMAIL webmaster@your.domain
ENV DB_HOST localhost
ENV DB_USER root
ENV DB_PASSWORD password
ENV SALT your.salt
ENV LANG en
ENV ENCODER https://encoder1.avideo.com/

ADD install.php /root/
ADD entrypoint.sh /usr/local/bin/
ADD gencerts.sh /usr/local/bin/
WORKDIR /var/www/html

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo 'UTC' > /etc/timezone \
    && apt-get update \
    && apt-get install apt-transport-https lsb-release logrotate git curl vim net-tools iputils-ping -y --no-install-recommends \
    && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include \
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar exif gd gettext iconv intl mbstring mysqli opcache pdo_mysql zip \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache \
    && a2enmod rewrite \
    && pip install -U youtube-dl \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && sed -ri \
           -e 's!^(max_execution_time = )(.*)$!\1 72000!g' \
           -e 's!^(post_max_size = )(.*)$!\1 10G!g' \
           -e 's!^(upload_max_filesize = )(.*)$!\1 10G!g' \
           -e 's!^(memory_limit = )(.*)$!\1 10G!g' \
           "$PHP_INI_DIR/php.ini" \
       \
    && git clone https://github.com/WWBN/AVideo.git \
    && mv AVideo/* . \
    && mv AVideo/.[!.]* . \
    && rm -rf AVideo \
    && chmod a+rx /usr/local/bin/entrypoint.sh \
    && chmod a+rx /usr/local/bin/gencerts.sh \
    && mkdir videos \
    && chmod 755 videos \
    && chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html/videos"]
CMD ["entrypoint.sh"]
