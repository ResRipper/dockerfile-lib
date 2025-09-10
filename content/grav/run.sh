#!/bin/sh
# Copyright 2025 resripper.
# SPDX-License-Identifier: MIT

# Schedule maintenance tasks
supercronic -quiet /etc/crontabs/www-data &

# Start Grav service
php-fpm -D && caddy run -c /etc/caddy/Caddyfile