# docker-youphptube

This is a docker image to run YouPHPTube in LXC.

# YouPHPTube
YouPHPTube! is an video-sharing website, It is an open source solution that is freely available to everyone. With YouPHPTube you can create your own video sharing site, YouPHPTube will help you import and encode videos from other sites like Youtube, Vimeo, etc. and you can share directly on your website. In addition, you can use Facebook or Google login to register users on your site. The service was created in march 2017. [more detail...](https://github.com/DanielnetoDotCom/YouPHPTube)

<div align="center">
<img src="http://www.youphptube.com/img/prints/prints7.png">
<a href="http://demo.youphptube.com/" target="_blank">View Demo</a>
</div>

# How to use
The simple way, you run the command below:
```
docker-compose up &
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
-p 80:80
-p 443:443
-d leejoneshane/youphptube-encoder
```
