FROM php:8.4-fpm-alpine3.19

# Install packages
RUN set -ex \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
        git \
        openldap-dev \
        libldap \
        postgresql-dev \
        libpng-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libmcrypt-dev \
        rabbitmq-c-dev\
        libwebp-dev \
        libzip-dev \
        libssh2-dev \
        libxml2-dev \
        imap-dev \
        gmp-dev \
        ttf-dejavu \
        rsyslog \
        unzip \
        make \
        tzdata \
        pwgen \
        gettext \
        gettext-dev \
        linux-headers \
        icu-data-full \
        bash \
        libxrender

# Symlinks to php
RUN ln -s /usr/local/bin/php /usr/bin/php8.4 && \
    ln -s /usr/local/bin/php /bin/php8.4

# Tuning php.ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i -e '/memory_limit/s/128M/1024M/g' /usr/local/etc/php/php.ini && \
    sed -i -e '/mail.add_x_header/s/Off/On/g' /usr/local/etc/php/php.ini

# Tuning php-fpm.conf
RUN sed -i -e '/emergency_restart_threshold/s/;emergency_restart_threshold = 0/emergency_restart_threshold = 10'/ /usr/local/etc/php-fpm.conf && \
    sed -i -e '/emergency_restart_interval/s/;emergency_restart_interval = 0/emergency_restart_interval = 1m'/ /usr/local/etc/php-fpm.conf && \
    sed -i -e '/process_control_timeout/s/;process_control_timeout = 0/process_control_timeout = 10s'/ /usr/local/etc/php-fpm.conf

# Disable access.log
RUN sed -i -e '/access.log/s/access.log = \/proc\/self\/fd\/2/access.log = \/dev\/null'/ /usr/local/etc/php-fpm.d/docker.conf

# Configure PHP extensions
RUN pecl update-channels && pecl install amqp igbinary redis ssh2-1.3.1 \
    && docker-php-ext-enable amqp igbinary redis ssh2 \
    && docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install intl exif bcmath gd opcache pdo pdo_pgsql zip sockets ldap soap gmp gettext

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

CMD ["php-fpm"]
