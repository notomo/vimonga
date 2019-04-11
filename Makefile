build:
	cargo build

release_build:
	cargo build --release

setup_data:
	docker-compose exec mongodb mongo /provision/data.js

test:
	docker-compose exec mongodb2 mongo /provision/test.js
	THEMIS_ARGS="-e -s --headless" themis
	RUST_BACKTRACE=1 cargo test

.PHONY: build
.PHONY: release_build
.PHONY: setup_data
.PHONY: test
