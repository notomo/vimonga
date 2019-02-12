build:
	cargo build

start:
	pkill -KILL -f "target/debug/vimonga [s]erver" || echo "kill the old process"
	${MAKE} build
	RUST_BACKTRACE=full ./target/debug/vimonga server

.PHONY: build
