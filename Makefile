SHELL := /bin/bash

# --- SETTINGS
KERNEL_OFFSET := 0x1000

# --- PROGRAMS
CC   := i386-elf-gcc
LD   := i386-elf-ld
GDB  := i386-elf-gdb
OBJ  := i386-elf-objcopy
NASM := nasm
QEMU := qemu-system-i386
MAKE := make

# --- NASM FILES
BOOT_AFILES   := boot disk enter print
KERNEL_AFILES :=
DRIVER_AFILES := 

# --- HEADER FILES
KERNEL_HFILES := print util
DRIVER_HFILES := ports vga

# --- C FILES
KERNEL_CFILES := main print util
DRIVER_CFILES := ports vga

A := $(shell tput setaf 3 && tput bold)
B := $(shell tput sgr0)

HFILES := $(patsubst %,include/kernel/%.h,$(KERNEL_HFILES)) \
	  $(patsubst %,include/driver/%.h,$(DRIVER_HFILES))

OFILES := $(patsubst %,out/kernel/%.o,$(KERNEL_CFILES)) \
	  $(patsubst %,out/driver/%.o,$(DRIVER_CFILES))

AFILES := $(patsubst %,asm/boot/%.asm,$(BOOT_AFILES)) \
	  $(patsubst %,asm/kernel/%.asm,$(KERNEL_AFILES)) \
	  $(patsubst %,asm/driver/%.asm,$(DRIVER_AFILES))


CFLAGS += -g -ffreestanding -funsigned-char -Iinclude/
AFLAGS += -Iasm/
LFLAGS +=

build: | create_dir out/os.bin
	@echo "$(A)build complete ...$(B)"

run: build
	@echo "$(A)running emulator ...$(B)"
	$(QEMU) -drive "format=raw,file=out/os.bin"

debug: build
	@echo "$(A)running emulator (DEBUG) ...$(B)"
	$(QEMU) -s -S -drive "format=raw,file=out/os.bin" & echo $$! > out/kernel.pid
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file out/kernel.elf"
	kill -SIGTERM "`cat out/kernel.pid`"

create_dir:
	mkdir -p out/{kernel,driver} 2> /dev/null ||:

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
	$(NASM) $(AFLAGS) asm/boot/boot.asm -o out/boot.bin

out/os.bin: out/boot.bin out/kernel.bin
	@echo "$(A)putting both binaries together ...$(B)"
	cat $^ > $@

.PHONY: build create_dir build_cross
