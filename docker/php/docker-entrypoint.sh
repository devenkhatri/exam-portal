#!/usr/bin/env sh
set -e

cd /var/www/html

# Copy .env.docker.example to .env if .env does not exist
if [ ! -f ".env" ]; then
  if [ -f ".env.docker.example" ]; then
    echo "Creating .env from .env.docker.example..."
    cp .env.docker.example .env
  elif [ -f ".env.example" ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
  fi
fi

# Wait for MySQL database if DB_HOST is set
if [ -n "$DB_HOST" ]; then
  echo "Waiting for database connection at $DB_HOST:${DB_PORT:-3306}..."
  while ! nc -z "$DB_HOST" "${DB_PORT:-3306}"; do
    sleep 1
  done
  echo "Database connection established."
fi

# Install Composer dependencies if vendor/autoload.php is missing
if [ ! -f "vendor/autoload.php" ]; then
  echo "Installing Composer dependencies..."
  composer install --prefer-dist --no-interaction --optimize-autoloader
fi

# Ensure storage directories exist and have proper permissions
mkdir -p storage/framework/cache/data \
         storage/framework/sessions \
         storage/framework/views \
         storage/logs \
         bootstrap/cache

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Generate application key if not set
if [ -f ".env" ]; then
  if ! grep -q "^APP_KEY=base64:" .env; then
    echo "Generating Laravel application key..."
    php artisan key:generate --force
  fi
  GENERATED_KEY="$(grep '^APP_KEY=' .env | head -n 1 | cut -d '=' -f 2-)"
  if [ -n "$GENERATED_KEY" ]; then
    export APP_KEY="$GENERATED_KEY"
  fi
fi

# Create storage symlink if not already linked
if [ ! -L "public/storage" ]; then
  echo "Creating storage symlink..."
  php artisan storage:link || true
fi

# Execute the primary container command (e.g., php-fpm)
exec "$@"
