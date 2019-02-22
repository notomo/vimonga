build:
	cargo build

start:
	pkill -KILL -f "target/debug/vimonga --config=./example/vimonga.toml --pid=111 [s]erver start" || echo "kill the old process"
	${MAKE} build
	RUST_BACKTRACE=full ./target/debug/vimonga --config=./example/vimonga.toml --pid=111 server start

setup_data:
	docker-compose exec mongodb mongo /provision/data.js

.PHONY: build
