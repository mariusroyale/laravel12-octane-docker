FROM php:8.4-alpine

# Install dependencies and PHP extensions
RUN apk add --no-cache \
    bash \
    git \
    curl \
    libpq \
    postgresql-dev \
    libzip-dev \
    zlib-dev \
    oniguruma-dev \
    autoconf \
    make \
    g++ \
    brotli-dev \
    linux-headers \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install swoole \
    && docker-php-ext-enable swoole \
    && docker-php-ext-install pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

CMD ["tail", "-f", "/dev/null"]