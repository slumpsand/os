SHELL := /bin/bash

CC   ?= i386-elf-gcc
LD   ?= i386-elf-ld
NASM ?= nasm

A := $(shell tput setaf 3 && tput bold)
B := $(shell tput sgr0)

HFILES := 
OFILES := out/kernel.o
AFILES := asm/boot.asm asm/disk.asm asm/enter.asm asm/print.asm

KERNEL_OFFSET := 0x1000

CFLAGS += -ffreestanding

out/%.o: src/%.c $(HFILES)
	@echo "$(A)(01) compiling the  ...$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

out/kernel_entry.o: asm/kernel.asm
	$(NASM) $< -f elf -o $@

out/kernel.bin: out/kernel_entry.o $(OFILES)
	$(LD) -o $@ -Ttext $(KERNEL_OFFSET) $^ --oformat binary

out/boot.bin: $(AFILES)
	$(NASM) asm/boot.asm -o out/boot.bin

out/os.bin: out/boot.bin out/kernel.bin
	cat $^ > $@

.PHONY: build
