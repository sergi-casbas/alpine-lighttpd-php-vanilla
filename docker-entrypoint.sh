#!/bin/sh
echo -e "";

# Send logs to console if available.
ls /dev/console > /dev/null 2>&1
if [ $? == 0 ]; then
    rm /var/log/messages
    ln -s /dev/console /var/log/messages
    chown lighttpd. /dev/console
fi

# Prepare extra packages if UID/GID change is required.
if [ ! -z "$LIGHTTPD_UID" ] || [ ! -z "$LIGHTTPD_GID" ]; then
    APK_PACKAGES="$APK_PACKAGES shadow";
fi

# Install user-defined extra packages if exists.
if [ ! -z "$APK_PACKAGES" ]; then
    echo "Installing extra packages."; 
    apk add $APK_PACKAGES;
    rm -rf /var/cache/apk/* 
fi

# If a UID is specified use it.
if [ ! -z "$LIGHTTPD_UID" ]; then 
    echo "Changing UID $LIGHTTPD_UID.";
    usermod -u $LIGHTTPD_UID lighttpd;
fi

# If GID is specified use it.
if [ ! -z "$LIGHTTPD_GID" ]; then
    echo "Changing GID $LIGHTTPD_GID.";
    groupmod -g $LIGHTTPD_GID lighttpd;
fi

# Set apropiate permissions.
chown -R lighttpd. /run/lighttpd/
chown -R lighttpd. /var/log

# Special folder to put user defined scripts to run before deamons.
echo "Starting user-defined scripts folder."
run-parts /docker-entrypoint.d/

# Start daemons.
echo "Starting daemons."
crond -bS
php-fpm7 -D
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
