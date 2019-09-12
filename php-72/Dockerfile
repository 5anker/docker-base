FROM php:7.2-fpm
LABEL maintainer="j.imping@5-anker.com"

# Installing dependencies
RUN apt-get update && apt-get install -y \
    build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
    mysql-client \
    locales zip \
    jpegoptim optipng pngquant gifsicle \
    poppler-utils

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Installing Sentry CLI
RUN curl -sL https://sentry.io/get-cli/ | bash

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Set Composer Env to allow for root user installs
ENV COMPOSER_ALLOW_SUPERUSER=1

# Setting locales
RUN echo de_DE.UTF-8 UTF-8 > /etc/locale.gen && locale-gen

WORKDIR /application
