#!/bin/bash

# Starts ssh

/usr/sbin/sshd

# Starts php process in backgroud

mkdir -p /run/php-fpm && /usr/sbin/php-fpm -c /etc/php/fpm

# Start nginx daemon

nginx -g `daemon off;`