FROM php:8.3-fpm-alpine

# Install build dependencies and PHP extensions
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libzip-dev \
        zlib-dev \
    && apk add --no-cache \
        bash \
        git \
        unzip \
        icu-libs \
        libzip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j"$(nproc)" \
        intl \
        pdo_mysql \
        zip \
    && apk del .build-deps

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory BEFORE entrypoint runs
WORKDIR /var/www/html

# Entrypoint
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["php-fpm"]
