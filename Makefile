SHELL := /bin/bash

OFFSET := 0x200
TARGET := i386

NASM := nasm
MAKE := make
CC   := $(TARGET)-elf-gcc
LD   := $(TARGET)-elf-ld
GDB  := $(TARGET)-elf-gdb
OBJ  := $(TARGET)-elf-objcopy
QEMU := qemu-system-$(TARGET)

A := $(shell tput setaf 6 && tput bold)
B := $(shell tput sgr0)
HEADERS := $(wildcard **/*.h)

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "targets:"
	@echo "  build     build the source"
	@echo "  run       eventually build, and start the emulator"
	@echo "  debug     eventually build, and start the debugger"
	@echo ""
	@echo "  re-build  clean, then build"
	@echo "  re-run    clean, then run"
	@echo "  re-debug  clean, then debug"
	@echo ""
	@echo "  clean     remove all output files"
	@echo "  help      print this page"

build: | out/ out/os.bin
	@echo "$(A)build complete!$(B)"

run: build
	@echo "$(A)starting emulator (RUN) ...$(B)"

debug: build
	@echo "$(A)starting emulator (DEBUG) ...$(B)"

re-build: | clean build
re-run:   | clean run
re-debug: | clean debug

clean:
	@echo "$(A)cleaning everything up ...$(B)"
	rm -rf out/

out/:
	@echo "$(A)creating output directory ...$(B)"
	mkdir -p out/

out/%.list:
	$(eval NAME := $(patsubst out/%.list,%,$@))
	@echo "$(A)building $(NAME) directory ...$(B)"
	cd $(NAME) && $(MAKE) ../$@

out/kernel.elf: out/cpu.list out/drivers.list out/kernel.list
	@echo "$(A)linking kernel ...$(B)"
	$(LD) -e $(OFFSET) -Ttext $(OFFSET) -o $@ `cat $^`

out/kernel.bin: out/kernel.elf
	@echo "$(A)extracting raw binary ...$(B)"
	$(OBJ) -O binary $< $@

out/boot.bin:
	cd boot && $(MAKE) ../$@

out/fill.bin: out/boot.bin out/kernel.bin
	@echo "$(A)creating fillspace ...$(B)"
	dd if=/dev/zero of=$@ bs=$$((8193 - `cat $^ | wc -c`))

out/os.bin: out/boot.bin out/kernel.bin out/fill.bin
	@echo "$(A)concatenating binaries ...$(B)"
	cat $^ > $@

.PHONY: build clean out/boot.bin out/%.list
