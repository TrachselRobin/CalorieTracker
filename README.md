# Symfony/PHP Docker Setup

## Docker Compose

Es gibt zwei Compose-Dateien:

- `compose.local.yaml`: lokale Test-/Entwicklungsumgebung mit gemountetem Projektverzeichnis.
- `compose.live.yaml`: Live-Hosting auf dem Server.

Das Setup ist nicht an einen fixen Projektnamen gebunden. Docker Compose verwendet automatisch den Namen des Ordners, in dem die Compose-Datei liegt bzw. aus dem der Befehl ausgeführt wird. Die Volumes und Netzwerke werden dadurch pro Projektordner getrennt angelegt.

Lokal starten:

```bash
make docker-up-local
```

Live starten:

```bash
make docker-up-live
```

Die lokale Umgebung mountet das ganze Projekt nach `/var/www/html`. Änderungen am Symfony-Code sind dadurch direkt im Browser sichtbar, ohne dass das Image neu gebaut werden muss.

## Environment-Datei

Die zentrale Datei ist `.env`. Sie wird von Symfony für Applikationsvariablen und von Docker Compose für Ports und Datenbank-Zugangsdaten gelesen.

Wichtige Docker-Variablen:

```dotenv
LOCAL_APP_PORT=8080
LOCAL_MYSQL_PORT=3306
LOCAL_PHPMYADMIN_PORT=8081

LIVE_APP_PORT=80
LIVE_PHPMYADMIN_PORT=8081

MYSQL_DATABASE=app
MYSQL_USER=app
MYSQL_PASSWORD=app
MYSQL_ROOT_PASSWORD=root
```

Symfony kann zusätzlich `.env.local`, `.env.dev` oder `.env.prod` laden. Diese Dateien sind optional. Für ein einfaches Setup reicht `.env`; echte Live-Secrets sollten später nicht ins Git, sondern in `.env.local`, Server-Umgebungsvariablen oder Symfony Secrets.

## Projektstruktur

Das Setup erwartet eine normale Symfony/PHP-Projektstruktur:

```text
bin/console
composer.json
config/
public/
src/
templates/
migrations/
```

Symfony übernimmt dabei die eigentliche Applikationsstruktur:

- Controller liegen typischerweise unter `src/.../Controller`.
- Twig-Templates liegen unter `templates/`.
- Doctrine-Entities liegen unter `src/.../Entity`.
- Repositories liegen unter `src/.../Repository`.
- Doctrine-Migrationen liegen unter `migrations/`.

Die konkreten Namespaces, Entity-Pfade und Doctrine-Mappings werden nicht im Docker-Setup fest verdrahtet, sondern kommen aus den Symfony-Konfigurationen in `config/`.

## Public-Verzeichnis und Routing

nginx liefert nur den Ordner `public/` aus:

```nginx
root /var/www/html/public;
```

Damit sind `src/`, `config/`, `.env`, `vendor/` und andere Projektdateien nicht direkt öffentlich erreichbar. Requests werden zuerst gegen echte Dateien in `public/` geprüft. Wenn keine Datei gefunden wird, leitet nginx an `public/index.php` weiter:

```nginx
try_files $uri /index.php$is_args$args;
```

Ab diesem Punkt übernimmt Symfony das Routing über die definierten Routen, Controller und Attribute/YAML/PHP-Konfigurationen.

## Dienste

Local:

- App: `http://localhost:8080`
- phpMyAdmin: `http://localhost:8081`
- MySQL: `localhost:3306`

Live:

- App: Port `80`
- phpMyAdmin: Port `${PHPMYADMIN_PORT:-8081}`

phpMyAdmin ist damit auch live verfügbar. Auf einem echten Server sollte dieser Port zusätzlich per Firewall, Reverse Proxy Auth oder VPN abgesichert werden.

Für live können die Datenbank-Zugangsdaten über Umgebungsvariablen gesetzt werden:

```bash
MYSQL_DATABASE=app
MYSQL_USER=app
MYSQL_PASSWORD=change-me
MYSQL_ROOT_PASSWORD=change-root
LIVE_PHPMYADMIN_PORT=8081
```

## Initiales SQL

Das initiale SQL liegt in:

```text
docker/mysql/init/001_initial_schema.sql
```

Dieses Verzeichnis wird in MySQL unter `/docker-entrypoint-initdb.d` gemountet. MySQL führt diese Dateien nur beim ersten Start mit einem leeren Volume aus. Wenn das Volume bereits existiert, werden Änderungen an dieser Datei nicht automatisch erneut angewendet.

## Doctrine Migrationen

Migrationen werden in `migrations/` abgelegt. Der Ablauf ist für local/test und live gleich; nur das Compose-File unterscheidet sich.

Local ausführen:

```bash
make docker-migrate-local
```

Live ausführen:

```bash
make docker-migrate-live
```

Direkt mit Docker Compose:

```bash
docker compose -f compose.local.yaml exec php php bin/console doctrine:migrations:migrate --no-interaction
docker compose -f compose.live.yaml exec php php bin/console doctrine:migrations:migrate --no-interaction
```

Neue Migration anhand der Symfony/Doctrine-Konfiguration erzeugen:

```bash
docker compose -f compose.local.yaml exec php php bin/console doctrine:migrations:diff
```

Falls später `symfony/maker-bundle` installiert wird, kann alternativ `php bin/console make:migration` verwendet werden.
