#!/bin/sh
set -e

#if [ ! -f videos/configuration.php ]; then
#fi

exec httpd -DFOREGROUND
