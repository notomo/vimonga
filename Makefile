build:
	cargo build

start:
	# pkill -KILL -f "target/debug/vimonga --pid=111 [s]erver" || echo "kill the old process"
	pkill -KILL -f "target/debug/vimonga --config=./example/vimonga.toml --pid=111 [s]erver" || echo "kill the old process"
	${MAKE} build
	RUST_BACKTRACE=full ./target/debug/vimonga --config=./example/vimonga.toml --pid=111 server

.PHONY: build
