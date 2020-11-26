#!/bin/sh
set -euo pipefail

php /root/install.php

chown -R apache:apache /var/www/avideo

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
