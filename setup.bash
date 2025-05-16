#!/bin/bash
set -e  # Exit on error

echo "🚀 Building containers..."
docker-compose build

echo "📦 Starting containers (without Octane)..."
docker-compose up -d

if [ ! -f backend/artisan ]; then
  echo "🎼 Installing Laravel 12 via Composer..."
  docker-compose exec app composer create-project laravel/laravel . "^12.0"
else
  echo "✅ Laravel already installed — skipping create-project"
fi

# Copy .env if missing
if [ ! -f backend/.env ]; then
  echo "🧪 Copying .env file..."
  cp backend/.env.example backend/.env
fi

# Install Laravel Octane & Swoole if not present
if ! docker-compose exec app php artisan | grep -q octane; then
  echo "⚡ Installing Laravel Octane..."
  docker-compose exec app composer require laravel/octane
  docker-compose exec app php artisan octane:install --server=swoole
fi

# Install Laravel Sanctum if missing
if ! docker-compose exec app php artisan | grep -q sanctum; then
  echo "🔐 Installing Laravel Sanctum..."
  docker-compose exec app composer require laravel/sanctum
  docker-compose exec app php artisan vendor:publish --provider="Laravel\\Sanctum\\SanctumServiceProvider" --force
fi

echo "🔐 Generating Laravel app key..."
docker-compose exec app php artisan key:generate

echo "⏳ Waiting for Postgres to be ready..."
until docker-compose exec db pg_isready -U laravel; do
  sleep 2
done

# Update .env for Redis session and DB connection
docker-compose exec app sed -i 's/SESSION_DRIVER=file/SESSION_DRIVER=redis/' /var/www/.env
docker-compose exec app sed -i 's/SESSION_LIFETIME=.*/SESSION_LIFETIME=120/' /var/www/.env
docker-compose exec app sed -i 's/REDIS_CLIENT=.*/REDIS_CLIENT=phpredis/' /var/www/.env
docker-compose exec app sed -i 's/REDIS_HOST=.*/REDIS_HOST=valkey/' /var/www/.env
docker-compose exec app sed -i 's/REDIS_PASSWORD=.*/REDIS_PASSWORD=null/' /var/www/.env
docker-compose exec app sed -i 's/REDIS_PORT=.*/REDIS_PORT=6379/' /var/www/.env
docker-compose exec app sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' /var/www/.env
docker-compose exec app sed -i 's/^# *DB_HOST=.*/DB_HOST=db/' /var/www/.env
docker-compose exec app sed -i 's/^# *DB_PORT=.*/DB_PORT=5432/' /var/www/.env
docker-compose exec app sed -i 's/^# *DB_DATABASE=.*/DB_DATABASE=laravel/' /var/www/.env
docker-compose exec app sed -i 's/^# *DB_USERNAME=.*/DB_USERNAME=laravel/' /var/www/.env
docker-compose exec app sed -i 's/^# *DB_PASSWORD=.*/DB_PASSWORD=secret/' /var/www/.env

SRC_DIR="./laravel-src"
TARGET_DIR="./backend"

# Copy app.php
echo "🔁 Copying app.php..."
cp "$SRC_DIR/bootstrap/app.php" "$TARGET_DIR/bootstrap/app.php"

# Copy api.php
echo "🔁 Copying api.php..."
cp "$SRC_DIR/routes/api.php" "$TARGET_DIR/routes/api.php"

# Remove example Blade views and assets (optional, comment out if you want)
docker-compose exec app rm -rf /var/www/resources/views
docker-compose exec app rm -rf /var/www/public/css /var/www/public/js

echo "✅ Laravel core files updated."

echo "🎲 Running migrations..."
docker-compose exec app php artisan migrate

echo "📦 Installing Node.js dependencies..."
docker-compose exec node npm install

echo "✅ Setup complete!"
echo "🌐 Visit: http://localhost:8000/api"
echo "⚡ Start Octane with: docker-compose exec app php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000"
