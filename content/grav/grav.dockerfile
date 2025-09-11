# Copyright 2025 ResRipper.
# SPDX-License-Identifier: MIT

ARG ALPINE_VER=3.22.1

FROM alpine:${ALPINE_VER} AS configurator

# Download and install Grav
WORKDIR /var/www
ARG GRAV_VER=1.7.49.4
ADD https://getgrav.org/download/core/grav-admin/${GRAV_VER} grav-admin.zip
RUN unzip grav-admin.zip && mv grav-admin html

# Remove unneeded files
WORKDIR /var/www/html
RUN rm -rf webserver-configs/ ./*.md

RUN mkdir ../user_resources && mv user/* ../user_resources

# Create user www-data
RUN adduser -u 82 -s /bin/sh -S www-data -G www-data

# Create cron job for Grav maintenance scripts
RUN (crontab -l; echo "* * * * * cd /var/www/html;php bin/grav scheduler 1>> /dev/null 2>&1") \
    | crontab -u www-data - && chown www-data:www-data /etc/crontabs/www-data

FROM alpine:${ALPINE_VER} AS builder

# Upgrade system
RUN apk update && apk upgrade
# Install web server & cron
RUN apk add --no-cache --clean-protected caddy supercronic

# Install PHP and modules
# https://learn.getgrav.org/17/basics/requirements#php-requirements
RUN apk add --no-cache --clean-protected \
    php php-ctype php-curl php-dom php-fpm php-gd php-intl php-mbstring \
    php-opcache php-openssl php-pecl-apcu php-pecl-yaml php-session php-simplexml \
    php-xml php-zip

# Link PHP config folder and PHP-FPM
RUN VERSION=$(echo $(php -v) | cut -d' ' -f2) && \
    ln -s "/etc/php$(echo $VERSION | cut -d'.' -f1)$(echo $VERSION | cut -d'.' -f2)" /etc/php && \
    ln -s "/usr/sbin/php-fpm$(echo $VERSION | cut -d'.' -f1)$(echo $VERSION | cut -d'.' -f2)" /usr/sbin/php-fpm

# Install PHP configurations
COPY ./php_conf/php-config.ini /etc/php/conf.d/php-config.ini
# Install PHP-FPM configurations
WORKDIR /etc/php/php-fpm.d
RUN mv www.conf www.conf.default
COPY php_conf/www.conf /etc/php/php-fpm.d/www.conf
COPY php_conf/docker.conf /etc/php/php-fpm.d/docker.conf

# Create user www-data
RUN adduser -u 82 -s /bin/sh -S www-data -G www-data

# Clean-up
RUN rm -rf \
    /var/cache/apk/* \
    /tmp/* \
    /usr/src/* \
    /etc/caddy/*


# Release image
FROM scratch AS release

ARG GRAV_VER=1.7.49.4

LABEL org.opencontainers.image.version=${GRAV_VER}
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="ResRipper"
LABEL org.opencontainers.image.url="https://github.com/ResRipper/dockerfile-lib/content/grav"
LABEL org.opencontainers.image.description="Grav CMS with Caddy web server"

COPY --from=builder / /

COPY --from=configurator --chown=www-data:www-data /etc/crontabs/www-data /etc/crontabs/www-data
COPY --from=configurator --chown=www-data:www-data /var/www/html /var/www/html
COPY --from=configurator --chown=www-data:www-data /var/www/user_resources /var/www/user_resources

COPY Caddyfile /etc/caddy/Caddyfile
COPY --chown=www-data:www-data run.sh /run.sh

# Change home directory's ownership
RUN chown -R www-data:www-data /home/www-data

EXPOSE 80

# Persisted folders
# https://learn.getgrav.org/17/basics/installation#install-with-docker
VOLUME /var/www/html/user /var/www/html/backup /var/www/html/logs

ENTRYPOINT [ "/run.sh" ]