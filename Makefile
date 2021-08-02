BIN_DIR ?= /usr/local/bin

deps:
	nimble -n install clapfn
	nimble -n install colorize

build: csoundstyle.nim cstags.nim echocolors.nim deps
	nim c -d:release csoundstyle.nim

install: csoundstyle
	cp csoundstyle "$(BIN_DIR)/csoundstyle"
