SHELL := /bin/bash

CC   := i386-elf-gcc
LD   := i386-elf-ld
GDB  := i386-elf-gdb
OBJ  := i386-elf-objcopy
NASM := nasm
QEMU := qemu-system-x86_64
MAKE := make

A := $(shell tput setaf 3 && tput bold)
B := $(shell tput sgr0)

HFILES := include/print.h
OFILES := out/kernel.o out/print.o
AFILES := asm/boot.asm asm/disk.asm asm/enter.asm asm/print.asm

KERNEL_OFFSET := 0x1000

CFLAGS += -g -ffreestanding -funsigned-char -Iinclude/
AFLAGS += -Iasm/
LFLAGS += 

build: | create_dir out/os.bin
	@echo "$(A)build complete ...$(B)"

run: build
	@echo "$(A)running emulator ...$(B)"
	$(QEMU) -drive "format=raw,file=out/os.bin"

debug: build out/kernel.elf
	@echo "$(A)running emulator (DEBUG) ...$(B)"
	$(QEMU) -s -S -drive "format=raw,file=out/os.bin" & echo $$! > out/kernel.pid
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file out/kernel.elf"
	kill -SIGTERM "`cat out/kernel.pid`"

create_dir:
	test -d out || mkdir out

build_cross:
	$(eval BUILD_FOLDER := $(shell mktemp -d -t build.XXXXXXXXXX))
	cp cross.mk $(BUILD_FOLDER)/
	cd $(BUILD_FOLDER) && make -f cross.mk
	@echo "($A)successfully build cross-compiler into '/opt/cross' ...$(B)"

out/%.o: src/%.c $(HFILES)
	@echo "$(A)compiling the file '$<' ...$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

out/kernel_entry.o: asm/kernel.asm
	@echo "$(A)assembling the kernel '$<' ...$(B)"
	$(NASM) $(AFLAGS) $< -f elf -o $@

out/kernel.bin: out/kernel.elf
	@echo "$(A)extracting the binary ...$(B)"
	$(OBJ) -O binary $< $@

out/kernel.elf: out/kernel_entry.o $(OFILES)
	@echo "$(A)linking the kernel ...$(B)"
	$(LD) $(LFLAGS) -o $@ -Ttext $(KERNEL_OFFSET) $^

out/boot.bin: $(AFILES)
	@echo "$(A)assembling the bootloader ...$(B)"
	$(NASM) $(AFLAGS) asm/boot.asm -o out/boot.bin

out/os.bin: out/boot.bin out/kernel.bin
	@echo "$(A)putting both binaries together ...$(B)"
	cat $^ > $@

.PHONY: build create_dir build_cross
