FROM httpd:alpine

RUN apk update  \
    && apk add --no-cache git curl certbot acme-client openssl php7-cli php7-apache2 php7-mysqlnd php7-curl php7-gd php7-intl php7-exif m	php7-mbstring ysql-client ffmpeg perl-image-exiftool python \
    && rm -rf /var/cache/apk/*
    && cd /usr/local/apache2/htdocs \
    && git clone https://github.com/DanielnetoDotCom/YouPHPTube.git \
    && curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && sudo chmod a+rx /usr/local/bin/youtube-dl
    
EXPOSE 443
CMD ["httpd-foreground"]
