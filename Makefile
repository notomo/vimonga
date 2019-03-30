build:
	cargo build

release_build:
	cargo build --release

setup_data:
	docker-compose exec mongodb mongo /provision/data.js

test:
	cargo test

.PHONY: build
.PHONY: release_build
.PHONY: setup_data
.PHONY: test
