FROM ubuntu

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
ADD gencerts.sh /usr/local/bin/
WORKDIR /var/www/avideo

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo 'UTC' > /etc/timezone \
    && apt-get update \
    && apt-get install apt-transport-https lsb-release logrotate git curl vim net-tools iputils-ping apache2 php7.4 php7.4-common php7.4-cli php7.4-json php7.4-mbstring php7.4-curl php7.4-mysql php7.4-bcmath php7.4-xml php7.4-gd php7.4-zip -y --no-install-recommends \
    && rm /etc/apache2/sites-enabled/000-default.conf \
    && sed -ri \
           -e 's!^(max_execution_time = )(.*)$!\1 72000!g' \
           -e 's!^(post_max_size = )(.*)$!\1 10G!g' \
           -e 's!^(upload_max_filesize = )(.*)$!\1 10G!g' \
           -e 's!^(memory_limit = )(.*)$!\1 10G!g' \
           "/etc/php7/php.ini" \
       \
    && git clone https://github.com/WWBN/AVideo.git \
    && mv AVideo/* . \
    && mv AVideo/.[!.]* . \
    && rm -rf AVideo \
    && chmod a+rx /usr/local/bin/entrypoint.sh \
    && chmod a+rx /usr/local/bin/gencerts.sh \
    && mkdir videos \
    && chmod 755 videos \
    && chown -R www-data:www-data /var/www

ADD avideo.conf /etc/apache2/sites-enabled/

VOLUME ["/var/www/avideo/videos"]
EXPOSE 80 443
CMD ["entrypoint.sh"]
