# docker-youphptube

This is a docker image to run YouPHPTube in LXC.

# YouPHPTube
YouPHPTube! is an video-sharing website, It is an open source solution that is freely available to everyone. With YouPHPTube you can create your own video sharing site, YouPHPTube will help you import and encode videos from other sites like Youtube, Vimeo, etc. and you can share directly on your website. In addition, you can use Facebook or Google login to register users on your site. The service was created in march 2017. [more detail...](https://github.com/DanielnetoDotCom/YouPHPTube)

<div align="center">
<img src="http://www.youphptube.com/img/prints/prints7.png">
<a href="http://demo.youphptube.com/" target="_blank">View Demo</a>
</div>

# YouPHPTube - Encoder
Go get it <a href="https://github.com/DanielnetoDotCom/YouPHPTube-Encoder" target="_blank">here</a>

<div align="center">
<img src="https://youphptube.com/img/prints/encoder.png">
<a href="https://encoder.youphptube.com/" target="_blank">View Public Encoder</a>
</div>

# How to use
You need MySQL server to store database for YouPHPTube. Run command like below:

docker run --name mysql -e MYSQL_ROOT_PASSWORD=your_db_passwd -d mysql/mysql

After that, You can run the YouPHPTube container and link to MySQL. Docker command like below:

docker run --name utube -e DOMAIN=the_server_url -e ADMIN_EMAIL=your_email -p 443:443 -d leejoneshane/youphptube

You can setup your own SSL certificates **OR** genarate [Let's Encrypt](https://letsencrypt.org/) free SSL by shell script like below:

docker exec utube bash↵

utube#>gencerts.sh↵

Then, You should open browser conenect to https://the_server_url and setup your YouPHPTube Streamer Server. By the way, The YouPHPTube Encoder Server was installed in https://the_server_url/encoder, don't forget to setup the configurations too.
