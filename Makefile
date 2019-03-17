build:
	cargo build

release_build:
	cargo build --release

setup_data:
	docker-compose exec mongodb mongo /provision/data.js

.PHONY: build
.PHONY: release_build
.PHONY: setup_data
