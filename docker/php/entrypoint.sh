#!/bin/sh
set -e

if [ ! -d "vendor" ]; then
  echo "vendor/ missing -> running composer install"
  composer install --no-interaction --prefer-dist
fi

exec php-fpm
