###############################################################################
# Node JS
###############################################################################

FROM node:10.17-alpine as nodejs
LABEL maintainer="j.imping@5-anker.com"

# Install lib support
RUN set -xe \
    && apk add --no-cache \
		curl \
		bash

RUN curl -sL https://sentry.io/get-cli/ | bash

WORKDIR /application

# any artisan file triggers laravel mixer (black) magic
RUN touch artisan

###############################################################################
# PHP
###############################################################################

FROM php:7.3-fpm-alpine as php
LABEL maintainer="j.imping@5-anker.com"

# Install lib support
RUN set -xe \
    && apk add --update \
        icu \
    && apk add --no-cache --virtual .php-deps \
        make \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
	&& apk add --no-cache \
        autoconf \
		cmake \
		file \
		g++ \
		gcc \
		libc-dev \
		pcre-dev \
		libzip-dev \
		libxml2-dev \
		make \
		git \
		shadow \
		pkgconf \
		re2c \
		zip \
		unzip \
		curl \
		# for GD and ImageMagic
		jpeg-dev \
		freetype-dev \
		libpng-dev  \
		libwebp-dev \
		libjpeg-turbo-dev \
		# for xslt
		libxslt-dev \
		# for intl extension
		icu-dev \
		openssl-dev \
		zlib-dev \
		icu-dev \
		# for image optimization
		jpegoptim \
		optipng \
		pngquant \
		gifsicle \
		# imagemagic
		imagemagick \
		imagemagick-libs \
		imagemagick-dev \
		# mysql
		mariadb-client \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl pdo_mysql mbstring exif pcntl zip soap calendar iconv \
    && docker-php-ext-enable intl \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

RUN curl -sSLO https://github.com/DataDog/dd-trace-php/releases/download/0.44.0/datadog-php-tracer_0.44.0_noarch.apk && \
    apk add datadog-php-tracer_0.44.0_noarch.apk --allow-untrusted && \
    rm datadog-php-tracer_0.44.0_noarch.apk

# Installing extensions
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-webp-dir=/usr/include/ \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install gd zip \
    && pecl install redis imagick apcu \
    && docker-php-ext-enable imagick redis apcu

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Set Composer Env to allow for root user installs
ENV COMPOSER_ALLOW_SUPERUSER=1

# Docker user permssio
RUN usermod -u 1000 www-data

# PHP config
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

WORKDIR /application
