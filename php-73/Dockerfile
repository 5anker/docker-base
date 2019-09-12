FROM php:7.3-fpm
LABEL maintainer="j.imping@5-anker.com"

# Installing dependencies
RUN apt-get update && apt-get install -y \
	build-essential \
	libzip-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
    locales unzip zip git curl wget \
    jpegoptim optipng pngquant gifsicle \
    poppler-utils

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl

RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install zip

RUN pecl install redis apcu
RUN docker-php-ext-enable redis apcu

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Set Composer Env to allow for root user installs
ENV COMPOSER_ALLOW_SUPERUSER=1

# Setting locales
RUN echo de_DE.UTF-8 UTF-8 > /etc/locale.gen && locale-gen

#
# Install Node (with NPM), and Yarn (via package manager for Debian)
#
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update \
 && apt-get install -y \
 nodejs
RUN npm install -g yarn

WORKDIR /application
