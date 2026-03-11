PREFIX ?= $(HOME)/.local
XDG_CONFIG_HOME ?= $(HOME)/.config
PROJECT_DIR := $(shell pwd)

.PHONY: install uninstall

install:
	install -Dm755 bin/study $(PREFIX)/bin/study
	install -dm755 $(XDG_CONFIG_HOME)/deep-systems
	echo "DEEP_SYSTEMS_DIR=$(PROJECT_DIR)" > $(XDG_CONFIG_HOME)/deep-systems/config

uninstall:
	rm -f $(PREFIX)/bin/study
	rm -rf $(XDG_CONFIG_HOME)/deep-systems
