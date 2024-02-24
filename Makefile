help:
	@make -qpRr | egrep -e '^[a-z].*:$$' | sed -e 's~:~~g' | sort

.PHONY: dev
dev:
	MIX_ENV=dev \
	SECRET_KEY_BASE="12345678901234567890121234567890123456789012345678903212345678901234567890123456789032123456789012345678901234567890323456789032" \
	DATABASE_URL="ecto://postgres:postgres@localhost:6462/postgres" \
	CHECK_QUEUE_INTERVAL=10000 \
	VAULT_ENC_KEY=your_new_32_length_secure_string \
	ERL_AFLAGS="-kernel shell_history enabled" \
	iex --name node1@127.0.0.1 --cookie cookie -S mix phx.server --no-halt

db_migrate:
	mix ecto.migrate --prefix _beamecho --log-migrator-sql

db_start:
	docker-compose -f ./docker-compose.db.yml up

db_stop:
	docker-compose -f ./docker-compose.db.yml down --remove-orphans

db_rebuild:
	make db_stop
	docker-compose -f ./docker-compose.db.yml build
	make db_start

clean:
	rm -rf _build && rm -rf deps

dev_release:
	mix deps.get && mix compile && mix release bec

dev_up:
	rm -rf _build/dev/lib/bec && \
	MIX_ENV=dev mix compile && \
	mix release bec

rm_static:
	rm -rf priv/static/dist

build_static:
	cd web_app && \
	npm run build && \
	rm -rf ../priv/static/dist && \
	mv ./dist ../priv/static/ && \
	cd ../

docker:
	docker build --no-cache -t beamecho .
