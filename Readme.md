# Laravel 12 + Octane + PHP Swoole on Docker Environment – API-Only

This repository contains a Laravel 12 API-only application running on Docker using:

- **PHP 8.4** (Alpine) with **Swoole**
- **Laravel 12 Octane**
- **PostgreSQL** (latest)
- **Valkey** (latest) for in-memory caching
- **Docker Compose** for orchestration

---

## Quick Start

### 1. 🧱 Install Laravel App using ./setup.sh ![Laravel](https://img.shields.io/badge/Laravel-12-red?logo=laravel&logoColor=white) 

- Creates Docker Builds && Containers
- Installs the PHP 8.4 application + [Swoole](https://www.php.net/manual/en/book.swoole.php)
- Creates Laravel Project + Installs [Laravel 12](https://laravel.com/docs/12.x) + [Octane](https://laravel.com/docs/12.x/octane)
- Installs [Laravel Sanctum](https://laravel.com/docs/12.x/sanctum)
- Generates Laravel App key
- Creates .env (with the correct credentials for DB / [Valkey](https://valkey.io/) / Session)
- Configures Laravel for API-Only
- Runs db migrations
- Installs nodejs dependecies


```bash
./setup.sh
```
or (if you need to rebuild and re-create containers)
```bash
./rebuild-docker.sh
```

---

### 2. ⚡ Start Laravel Octane

```bash
docker-compose exec app php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000
```

### 3. 🌐 Access the application

Open your browser at [http://localhost:8000/api](http://localhost:8000/api)

---

## Notes

- No Nginx or Blade: This stack is designed for API-only use — minimal surface area, fast boot, clean architecture.
- No Node/Vite: Frontend asset tooling not included. Ideal for headless API services or external frontends.

---

## Troubleshooting

- If Laravel fails to connect to Postgres, confirm Postgres is running (docker-compose ps) and accepting connections.
- If Octane throws a Signals are not supported error, ensure the pcntl extension is installed and not disabled in php.ini.
- If you're running into file permission issues, try chmod -R 777 storage bootstrap/cache.

---

## License

MIT License

---

Feel free to contribute or ask for help!

## GitHub Profile

Check out more of my projects on GitHub:  
[https://github.com/mariusroyale](https://github.com/mariusroyale)