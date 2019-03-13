build:
	cargo build

setup_data:
	docker-compose exec mongodb mongo /provision/data.js

.PHONY: build
.PHONY: setup_data
