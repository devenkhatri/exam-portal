# ==============================================================================
# Stage 1: Build frontend assets using Node.js & Vite
# ==============================================================================
FROM node:22-alpine AS frontend
WORKDIR /app

COPY package*.json ./
RUN npm ci --no-audit

COPY resources ./resources
COPY vite.config.js tailwind.config.js postcss.config.js ./
COPY public ./public

RUN npm run build

# ==============================================================================
# Stage 2: PHP Application Runtime
# ==============================================================================
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    bash \
    curl \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    mariadb-client \
    netcat-openbsd

# Configure and install PHP extensions needed for Laravel and DomPDF
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl \
        bcmath \
        gd \
        intl \
        opcache

# Copy Composer binary from official composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy PHP configuration and entrypoint
COPY docker/php/local.ini /usr/local/etc/php/conf.d/local.ini
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy application source code
COPY . .

# Copy compiled frontend assets from frontend build stage
COPY --from=frontend /app/public/build ./public/build

# Ensure storage directories and permissions
RUN mkdir -p storage/framework/cache/data \
             storage/framework/sessions \
             storage/framework/views \
             storage/logs \
             bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
