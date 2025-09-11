#!/bin/sh
# Copyright 2025 resripper.
# SPDX-License-Identifier: MIT

# Change folders' owner
if [ "${CHOWN:=true}" = true ]; then
    echo "Adjusting data folders' ownership..."
    chown -R www-data:www-data /var/www/html/user /var/www/html/backup /var/www/html/logs
fi

# Schedule maintenance tasks
su -s /bin/sh www-data -c "supercronic -quiet /etc/crontabs/www-data &"

# Transfer user files if mountpoint is empty
su -s /bin/sh www-data -c "$(cat << EOF
    if [ -z "$( ls -A '/var/www/html/user/' )" ]; then
        echo 'User data empty, copying files...'
        cp -r /var/www/user_resources/* /var/www/html/user/
    else
        echo 'Files detected, skip copying.'
    fi
EOF
)"

# Start Grav service
su -s /bin/sh www-data -c "php-fpm -D && caddy run -c /etc/caddy/Caddyfile"