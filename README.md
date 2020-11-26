# docker-youphptube

This is a docker image to run YouPHPTube v9.7 in LXC.

<img src="https://avideo.tube/website/assets/151/images/avideo_platform.png"/>

[![Minimum PHP Version](https://img.shields.io/badge/php-%3E%3D%205.6-8892BF.svg?style=flat-square)](https://php.net/)
[![GitHub release](https://img.shields.io/github/v/release/WWBN/AVideo)](https://github.com/WWBN/AVideo/releases)

## Audio Video Platform
AVideo is a term that means absolutely nothing, or anything video. Since it doesn't mean anything the brand simply is identifiable with audio video. AVideo Platform is an Audio and Video Platform or simply "A Video Platform".

* AVideo - Audio Video
* AVideo Platform - Audio Video Platform
* OAVP - Online Audio Video Platform
* OVP - Online Video Platform

AVideo Platform is distributed as SaaS at <a href="https://avideo.com">AVideo.com</a>, as an <a href="https://avideo.tube/AVideo_Enterprise">Enterprise Version</a>, and as an <a href="https://avideo.tube/AVideo_OpenSource">Open-Source Project</a>.

# How to use
The simple way, you edit docker-compose.yml then run the command below:
```
docker-compose up -d
```
This way will create all service containers, include: mysql, phpmyadmin and youphptube.

Or you can run then on your own, you need MySQL server to store database for YouPHPTube. Run command like below:
```
docker run --name mysql -e MYSQL_ROOT_PASSWORD=your_db_passwd -d mysql/mysql
```
Please use the following instructions to get mysql server's ip:
```
docker exec mysql ip addr↵
```
After that, you can run the YouPHPTube container and link to MySQL. Docker command like below:
```
docker run --name utube
-e SITE_TITLE="The name of your site"
-e DOMAIN=FQDN.your_site.com
-e DOMAIN_PROTOCOL=https
-e ADMIN_PASSWORD=your_password
-e ADMIN_EMAIL=your_account@gmail.com
-e DB_HOST=mysql_server
-e DB_USER=root
-e DB_PASSWORD=your_db_passwd
-e LANG=en
-p 80:80
-p 443:443
-d leejoneshane/youphptube
```
You may want to change the default language, use the parameters -e LANG=your_country.

When the contianer is running, you can setup your own SSL certificates **OR** genarate [Let's Encrypt](https://letsencrypt.org/) free SSL by shell script like below:
```
docker exec utube bash↵
utube#>gencerts.sh↵
```
After that don't forget to change the environment variable __DOMAIN_PROTOCOL__ to __https__, and restart your container.

If you want configure by yourself, please delete the file: /var/www/localhost/htdocs/videos/configurations.php, then browse the install web page: https://FQDN.your_site.com/install

If you want to run YouPHPTube-Encoder with YouPHPTube, you should pull the YouPHPTube-Encoder docker image like below:
```
docker run --name encoder
-e DOMAIN=FQDN.your_site.com
-e DOMAIN_PROTOCOL=https
-e ADMIN_EMAIL=your_account@gmail.com
-e DB_HOST=mysql_server
-e DB_USER=root
-e DB_PASSWORD=your_db_passwd
-e LANG=en
-p 8000:80
-p 8443:443
-d leejoneshane/youphptube-encoder
```
