# Docker Usage

This project now ships with a Docker workflow that mirrors the existing XAMPP (Apache + PHP + MySQL) environment.

## Prerequisites

- Docker Desktop 4.0+ (or Docker Engine + Docker Compose v2)
- At least 2 GB of free RAM and 2 GB disk space for the MySQL volume

## Quick Start

1. **Copy the environment template** (if you need custom values):
   ```bash
   cp .env.example .env
   ```
   The current `.env` already uses the requested `root:root` credentials and points the PHP app to the `db` service.

2. **Build and launch the stack** from the repository root:
   ```bash
   docker compose up --build
   ```
   - `app` (php-apache) will be available at http://localhost:8080
   - `db` (mysql:8.0) is exposed only inside the Docker network
   - `phpmyadmin` gives you a browser-based MySQL GUI at http://localhost:8081

3. **Stop containers**:
   ```bash
   docker compose down
   ```
   Add `-v` if you also want to remove the MySQL volume (`db_data`).

## Services

| Service | Description | Ports |
|---------|-------------|-------|
| `app`   | PHP 8.2 + Apache web server. Mounts the `customer_support` directory for live editing. | 8080 → 80 |
| `db`    | MySQL 8.0 with schema auto-loaded from `customer_support/database/css_db.sql`. Data persists in the `db_data` volume. | — |
| `phpmyadmin` | phpMyAdmin 5 GUI wired to the `db` service for convenient SQL browsing/import/export. | 8081 → 80 |

## Volumes & Mounts

- `./customer_support:/var/www/html` keeps your local code/editing workflow intact while the container runs Apache/PHP.
- `db_data` stores MySQL data so database contents persist across restarts.
- Existing uploads remain inside `customer_support/uploads`, so they are accessible both locally and inside Docker.

## Common Tasks

- **View logs**: `docker compose logs -f app` (or `db`).
- **Run database CLI**: `docker compose exec db mysql -u root -p$DB_ROOT_PASSWORD css_db`.
- **Use phpMyAdmin**: browse to http://localhost:8081 and log in with the credentials from `.env` (default `root` / `root`).
- **Install new PHP dependencies**: update files locally, then rebuild with `docker compose up --build`.

## Notes

- All sensitive config now comes from environment variables. Update `.env` (or Compose overrides) when deploying to another environment.
- If you already have MySQL data you want to reuse, place the dump in `customer_support/database/` or import it manually into the `db` service.
- Windows users may need to enable file sharing for the repository folder in Docker Desktop so the bind mount works.
