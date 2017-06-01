FROM alpine

WORKDIR /var/www/localhost/htdocs

RUN apk update  \
    && apk add --no-cache git curl certbot acme-client openssl php7-apache2 php7-mysqlnd php7-curl php7-gd php7-intl php7-exif php7-mbstring mysql-client ffmpeg perl-image-exiftool python \
    && rm -rf /var/cache/apk/* \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git \
    && mv YouPHPTube/* . \
    && rm -rf YouPHPTube \
    && curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod a+rx /usr/local/bin/youtube-dl

COPY httpd-foreground /usr/local/bin/

EXPOSE 80 443
CMD ["httpd-foreground"]
