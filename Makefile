.PHONY: docker-up-local docker-up-live docker-migrate-local docker-migrate-live

docker-up-local:
	docker compose -f compose.local.yaml up -d --build

docker-up-live:
	docker compose -f compose.live.yaml up -d --build

docker-migrate-local:
	docker compose -f compose.local.yaml exec php php bin/console doctrine:migrations:migrate --no-interaction

docker-migrate-live:
	docker compose -f compose.live.yaml exec php php bin/console doctrine:migrations:migrate --no-interaction
