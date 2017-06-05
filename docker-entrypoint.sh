#!/bin/sh
set -e

#if [ ! -f videos/configuration.php ]; then
#fi

rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND
