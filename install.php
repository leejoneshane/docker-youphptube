#!/usr/bin/php -q
<?php
$installationVersion = '9.7';
$p = getenv('DOMAIN_PROTOCOL') ?: 'http';
$d = getenv('DOMAIN') ?: 'localhost';
$s = getenv('SALT') ?: uniqid();
$dbh = getenv('DB_HOST') ?: 'mysql';
$dbu = getenv('DB_USER') ?: 'root';
$dbp = getenv('DB_PASSWORD') ?: 'dbpasswd';
$am = getenv('ADMIN_EMAIL');
$ap = getenv('ADMIN_PASSWORD');
$t = getenv('SITE_TITLE') ?: 'AVideo';
$l = getenv('LANG') ?: 'en';
$en = getenv('ENCODER') ?: 'https://encoder1.avideo.com/';

function encryptPassword($password)
{
    return md5(hash('whirlpool', sha1($password.$s)));
}

$conn = @new mysqli($dbh, $dbu, $dbp, 'youPHPTube');
if ($conn->connect_error) {
    $conn = new mysqli($dbh, $dbu, $dbp);
    $sql = 'CREATE DATABASE IF NOT EXISTS youPHPTube CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;';
    $conn->query($sql);
    $conn->select_db('youPHPTube');
    $lines = file('/var/www/html/install/database.sql');
    $templine = '';
    foreach ($lines as $line) {
        if (substr($line, 0, 2) == '--' || $line == '') {
            continue;
        }
        $templine .= $line;
        if (substr(trim($line), -1, 1) == ';') {
            $conn->query($templine);
            $templine = '';
        }
    }
    $conn->query('DELETE FROM users WHERE id = 1');
    $sql = "INSERT INTO users (id, user, email, password, created, modified, isAdmin) VALUES (1, 'admin', '$am', '".md5($ap)."', now(), now(), true)";
    $conn->query($sql);
    $conn->query('DELETE FROM categories WHERE id = 1');
    $sql = "INSERT INTO categories (id, name, clean_name, description, created, modified) VALUES (1, 'Default', 'default','', now(), now())";
    $conn->query($sql);
    $conn->query('DELETE FROM configurations WHERE id = 1');
    $sql = "INSERT INTO configurations (id, video_resolution, users_id, version, webSiteTitle, language, contactEmail, encoderURL,  created, modified) VALUES (1, '858:480', 1,'$installationVersion', '$t', '$l', '$am', '$en', now(), now())";
    $conn->query($sql);
    $sql = "INSERT INTO `plugins` VALUES (NULL, 'a06505bf-3570-4b1f-977a-fd0e5cab205d', 'active', now(), now(), '', 'Gallery', 'Gallery', '1.0');";
    $conn->query($sql);
}
$conn->close();

$file = '/var/www/html/videos/configuration.php';
if (!file_exists($file)) {
    $content = "<?php
\$global['configurationVersion'] = 3.1;
\$global['disableAdvancedConfigurations'] = 0;
\$global['videoStorageLimitMinutes'] = 0;
\$global['disableTimeFix'] = 0;
\$global['logfile'] = '/var/www/html/videos/avideo.log';
\$global['webSiteRootURL'] = '$p://$d/';
\$global['systemRootPath'] = '/var/www/html/';
\$global['salt'] = '$s';
\$global['disableTimeFix'] = 0;
\$global['enableDDOSprotection'] = 1;
\$global['ddosMaxConnections'] = 40;
\$global['ddosSecondTimeout'] = 5;
\$global['strictDDOSprotection'] = 0;
\$global['noDebug'] = 0;
\$global['webSiteRootPath'] = '$d';
\$mysqlHost = '$dbh';
\$mysqlPort = '3306';
\$mysqlUser = '$dbu';
\$mysqlPass = '$dbp';
\$mysqlDatabase = 'youPHPTube';
/**
 * Do NOT change from here
 */
require_once \$global['systemRootPath'].'objects/include_config.php';
";
    $fp = fopen($file, 'wb');
    fwrite($fp, $content);
    fclose($fp);
}
