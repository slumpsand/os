#!/bin/bash
set -e

# settings
KERNEL_SECTORS=16

# programs
NASM="nasm"
LD="i386-elf-ld"
OBJ="i386-elf-objcopy"

# program flags
NASM_FLAGS="-f elf -gdwarf -Isrc/ -O0"
LD_FLAGS="-N -Ttext 0x7C00 -e 0x7C00"
OBJ_FLAGS=""

# prepare the environment
test -d out/ && rm -rf out/ ||:
mkdir -p out/

# build the bootloader
"$NASM" $NASM_FLAGS src/boot.asm -o out/boot.o

# build the kernel
"$NASM" $NASM_FLAGS src/kernel.asm -o out/kernel.o

# build the drivers
"$NASM" $NASM_FLAGS src/drivers.asm -o out/drivers.o

# link all files
"$LD" $LD_FLAGS out/boot.o out/kernel.o out/drivers.o -o out/all.elf

# extract the binary
"$OBJ" $OBJ_FLAGS -O binary out/all.elf out/all.bin

# add padding
dd if=/dev/zero of=out/padding.bin bs=$((512 * $KERNEL_SECTORS - `wc -c < out/all.bin` + 1)) count=1 2> /dev/null
cat out/all.bin out/padding.bin > out/os.bin
