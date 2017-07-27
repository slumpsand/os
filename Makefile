MAKE := make
CC   := i386-elf-gcc
LD   := i386-elf-ld
GDB  := i386-elf-gdb
OBJ  := i386-elf-objcopy
AR   := i386-elf-ar
QEMU := qemu-system-i386
NASM := nasm

KERNEL_OFFSET := 0x1000

A := $(shell tput setaf 6 && tput bold)
B := $(shell tput sgr0)

LFLAGS := -e $(KERNEL_OFFSET) -Ttext $(KERNEL_OFFSET)
AFLAGS := -f elf
CFLAGS := -g3 -ffreestanding -I. -Wall -funsigned-char

HFILES := $(wildcard **/*.h)
OFILES := boot/kernel_entry.o $(patsubst %.c,%.o,$(wildcard **/*.c)) \
					$(patsubst %.asm,%.o, $(wildcard cpu/**/*.asm)) \
					$(patsubst %.asm,%.o, $(wildcard drivers/**/*.asm)) \
					$(patsubst %.asm,%.o, $(wildcard kernel/**/*.asm))

build: | out/ out/kernel.bin out/boot.bin
	@echo "$(A)combining binaries ...$(B)"
	cat out/boot.bin out/kernel.bin > out/os.bin
	@echo "$(A)build completed successfully$(B)"

rebuild: | clean build

clean:
	@echo "$(A)cleaning up ...$(B)"
	rm -rf out/ boot/*.o cpu/*.o drivers/*.o kernel/*.o ||:

run: build
	@echo "$(A)running emulator ...$(B)"
	$(QEMU) -drive "format=raw,file=out/os.bin"

debug: build
	@echo "$(A)running emulator (DEBUG) ...$(B)"
	$(QEMU) -s -S -drive "format=raw,file=out/os.bin" & echo $$! > out/kernel.pid
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file out/kernel.elf"
	kill -SIGTERM "`cat out/kernel.pid`"

out/:
	mkdir -p out/

%.o: %.c $(HFILES) Makefile
	@echo "$(A)compiling '$<' ...$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm $(AFILES) Makefile
	@echo "$(A)assembling '$<' ...$(B)"
	$(NASM) $(AFLAGS) $< -o $@

out/kernel.elf: $(OFILES)
	@echo "$(A)linking kernel ...$(B)"
	$(LD) $(LFLAGS) -o $@ $^

out/kernel.bin: out/kernel.elf
	@echo "$(A)extracting kernel binary ...$(B)"
	$(OBJ) -O binary $< $@

out/boot.bin: $(wildcard boot/**/*.asm) Makefile
	@echo "$(A)building bootloader ...$(B)"
	$(NASM) -I boot/ -o $@ boot/entry.asm

.PHONY: build clean rebuild run debug
