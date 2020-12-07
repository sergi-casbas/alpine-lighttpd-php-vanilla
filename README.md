# alpine-lighttpd-php-vanilla
Lighttpd + PHP server running on alpine linux with only essential packages.

It only installs lighttpd and php-fpm packages. If you need more packages is
recommended to use environment variables.

## Basic use.
docker run -it --name myserver alpine-lighttpd-php-vanilla:latest

## Environment variables.
LIGHTTPD_UID = Set UID to run web daemons.
LIGHTTPD_GID = Set GID to run web daemons.
APK_PACKAGES = Add additional packages at start.

## Discretional scripts.
You can put your personalizes scripts on /docker-entrypoint.d/ to run just
before the daemons and just after all installations.
