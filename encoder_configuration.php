<?php
$global['webSiteRootURL'] = 'PROTOCOL://DOMAIN/';
$global['systemRootPath'] = '/var/www/localhost/htdocs/encoder/';
$global['disableConfigurations'] = false;
$global['disableBulkEncode'] = false;
$global['allowed'] = array('mp4', 'avi', 'mov', 'flv', 'mp3', 'wav', 'm4v', 'webm', 'wmv', 'mpg', 'mpeg', 'f4v', 'm4v', 'm4a', 'm2p', 'rm', 'vob', 'mkv', '3gp');

$mysqlHost = 'DB_HOST';
$mysqlPort = '3306';
$mysqlUser = 'DB_USER';
$mysqlPass = 'DB_PASSWORD';
$mysqlDatabase = 'youPHPTube-Encoder';

/**
 * Do NOT change from here
 */
require_once $global['systemRootPath'].'objects/include_config.php';
