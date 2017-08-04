export SHELL := /bin/bash

OFFSET   := 0x200
TARGET   := i386
GDB_PORT := 6001   # has to be updated in debugging.gdb

export NASM := nasm
export MAKE := make
export LD   := $(TARGET)-elf-ld
export GDB  := $(TARGET)-elf-gdb
export OBJ  := $(TARGET)-elf-objcopy
export QEMU := qemu-system-$(TARGET)

export A := $(shell tput setaf 6 && tput bold)
export B := $(shell tput sgr0)

export AFLAGS := -f elf -gdwarf
export LFLAGS := -e $(OFFSET) -Ttext $(OFFSET)

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
	$(QEMU) -drive "format=raw,file=out/os.bin"

debug: build
	@echo "$(A)starting emulator (DEBUG) ...$(B)"
	$(QEMU) -gdb tcp::$(GDB_PORT) -S -drive "format=raw,file=out/os.bin" & echo "$$!" > out/qemu.pid
	$(GDB) -q -x debugging.gdb
	kill -SIGTERM "`cat out/qemu.pid`"

re-build: | clean build
re-run:   | clean run
re-debug: | clean debug

clean:
	@echo "$(A)cleaning everything up ...$(B)"
	rm -rf out/

out/:
	@echo "$(A)creating output directory ...$(B)"
	mkdir -p out/

out/boot.list:
	@echo "$(A)building boot directory ...$(B)"
	cd boot && $(MAKE) ../$@

out/%.list:
	$(eval NAME := $(patsubst out/%.list,%,$@))
	@echo "$(A)building $(NAME) directory ...$(B)"
	cd $(NAME) && $(MAKE) -f ../subdir.mk NAME=$(NAME) ../$@

out/kernel.elf: out/boot.list out/cpu.list out/drivers.list out/kernel.list
	@echo "$(A)linking kernel ...$(B)"
	$(LD) $(LFLAGS) -o $@ `cat $^`

out/kernel.bin: out/kernel.elf
	@echo "$(A)extracting raw binary ...$(B)"
	$(OBJ) -O binary $< $@

out/boot.bin:
	@echo "$(A)building boot directory ...$(B)"
	cd boot && $(MAKE) ../$@

out/fill.bin: out/boot.bin out/kernel.bin
	@echo "$(A)creating fillspace ...$(B)"
	dd if=/dev/zero of=$@ bs=$$((8193 - `cat $^ | wc -c`)) count=1

out/os.bin: out/boot.bin out/kernel.bin out/fill.bin
	@echo "$(A)concatenating binaries ...$(B)"
	cat $^ > $@

.PHONY: clean run debug out/boot.bin out/%.list
