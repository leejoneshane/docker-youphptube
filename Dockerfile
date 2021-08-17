FROM php:7-apache

ENV DOMAIN localhost
ENV DOMAIN_PROTOCOL http
ENV SITE_TITLE AVideo
ENV ADMIN_PASSWORD password
ENV ADMIN_EMAIL webmaster@your.domain
ENV DB_HOST localhost
ENV DB_USER root
ENV DB_PASSWORD password
ENV DB_NAME youPHPTube
ENV LANG en
ENV ENCODER https://encoder1.avideo.com/

ADD install.php /root/
ADD entrypoint.sh /usr/local/bin/
WORKDIR /var/www/html

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo 'UTC' > /etc/timezone \
    && apt-get update \
    && apt-get install apt-transport-https lsb-release logrotate git curl vim net-tools iputils-ping libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libbz2-dev libxml2-dev libonig-dev libcurl4-openssl-dev -y --no-install-recommends \
    && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include \
    && docker-php-ext-install -j$(nproc) bcmath xml mbstring curl mysqli gd zip \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /root/.cache \
    && a2enmod rewrite \
    && echo "post_max_size = 10G\nupload_max_filesize = 10G" > $PHP_INI_DIR/conf.d/upload.ini \
    && echo "memory_limit = -1" > $PHP_INI_DIR/conf.d/memory.ini \
    && echo "max_execution_time = 72000" > $PHP_INI_DIR/conf.d/execution_time.ini \
    && git clone https://github.com/WWBN/AVideo.git \
    && mv AVideo/* . \
    && mv AVideo/.[!.]* . \
    && rm -rf AVideo \
    && chmod a+rx /usr/local/bin/entrypoint.sh \
    && mkdir videos \
    && chmod 755 videos \
    && chown -R www-data:www-data /var/www/html

COPY tw.php /var/www/html/locale/tw.php
VOLUME ["/var/www/html/videos"]
CMD ["entrypoint.sh"]
