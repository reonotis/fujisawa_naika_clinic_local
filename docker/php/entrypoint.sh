#!/bin/sh
set -e

if [ -d storage ] && [ -d bootstrap/cache ]; then
    chown -R www-data:www-data storage bootstrap/cache
    chmod -R 775 storage bootstrap/cache
fi

exec "$@"
