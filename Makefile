export MAKE := make
export CC   := i386-elf-gcc
export LD   := i386-elf-ld
export GDB  := i386-elf-gdb
export OBJ  := i386-elf-objcopy
export AR   := i386-elf-ar
export QEMU := qemu-system-i386
export NASM := nasm

export A := $(shell tput setaf 6 && tput bold)
export B := $(shell tput sgr0)

export LFLAGS :=
export AFLAGS := -f elf
export CFLAGS := -g3 -ffreestanding -I.. -Wall -Og -funsigned-char

HFILES := $(wildcard **/*.h)

build: | out/ out/kernel.bin
	@echo "$(A)combining binaries ...$(B)"
	cat out/boot.bin out/kernel.bin > out/os.bin
	@echo "$(A)build completed successfully$(B)"

clean:
	@echo "$(A)cleaning up ...$(B)"
	rm -rf out/ cpu/*.o drivers/*.o kernel/*.o ||:

out/:
	mkdir -p out/

out/%.a: $(wildcard %/**/*.asm) $(wildcard %/**/*.c) $(HFILES) %/Makefile Makefile
	cd $(patsubst out/%.a,%,$@) && $(MAKE)

out/kernel_entry.o: kernel.asm
	@echo "$(A)assembling '$@' ...$(B)"
	$(NASM) $(AFLAGS) $< -o $@

out/kernel.elf: out/kernel_entry.o out/cpu.a out/drivers.a out/kernel.a
	@echo "$(A)linking kernel ...$(B)"
	$(LD) $(LFLAGS) -o $@ $^

out/kernel.bin: out/kernel.elf
	@echo "$(A)extracting kernel binary ...$(B)"
	$(OBJ) -O binary $< $@

out/boot.bin: $(wildcard boot/**/*.asm) boot/Makefile Makefile
	@echo "$(A)building bootloader ...$(B)"
	cd boot && $(MAKE)

.PHONY: build clean
