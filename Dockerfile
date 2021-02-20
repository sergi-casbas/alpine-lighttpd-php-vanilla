FROM alpine:3.12

# Install minimal packages.
RUN apk -U --upgrade --no-cache add lighttpd php-fpm

# Clean packages cache
RUN rm -rf /var/cache/apk/*

# User-defined entrypoint files
RUN mkdir /docker-entrypoint.d

# lighttpd configuration extra folders.
RUN mkdir /etc/lighttpd/lighttpd.d/
RUN echo 'include_shell "cat /etc/lighttpd/lighttpd.d/*.conf"' >> /etc/lighttpd/lighttpd.conf
RUN ln -s /etc/lighttpd/mod_fastcgi_fpm.conf /etc/lighttpd/lighttpd.d/
RUN mkdir -p /run/lighttpd/

# php configuration extra folder and logs.
COPY z-php7.conf /etc/php7/php-fpm.d/

# Send daemons logs to docker console.
RUN touch /var/log/messages
RUN chown lighttpd. /var/log/messages
RUN ln -s /var/log/messages /var/log/lighttpd/access.log
RUN ln -s /var/log/messages /var/log/lighttpd/error.log
RUN ln -s /var/log/messages /var/log/php7/error.log

# Expose port and data/config locations.
EXPOSE 80
VOLUME /docker-entrypoint.d
VOLUME /etc/lighttpd/lighttpd.d/
VOLUME /etc/php7/php-fpm.d/
VOLUME /var/www/localhost

# Run cron, php fpm and lighttpd daemon.
COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD /docker-entrypoint.sh
