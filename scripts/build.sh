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

A=$(tput setaf 6 && tput bold)
B=$(tput sgr0)

if [[ -d out/ ]]
then
	echo "$A(00) deleting old files ...$B"
	rm -rf out/
fi

echo "$A(01) setting up environment ...$B"
mkdir -p out/

echo "$A(02) building the bootloader ...$B"
"$NASM" $NASM_FLAGS src/boot.asm -o out/boot.o

echo "$A(03) building the kernel ...$B"
"$NASM" $NASM_FLAGS src/kernel.asm -o out/kernel.o

echo "$A(04) building the drivers ...$B"
"$NASM" $NASM_FLAGS src/drivers.asm -o out/drivers.o

echo "$A(05) linking all files ...$B"
"$LD" $LD_FLAGS out/boot.o out/kernel.o out/drivers.o -o out/all.elf

echo "$A(06) extracting the binary ...$B"
"$OBJ" $OBJ_FLAGS -O binary out/all.elf out/all.bin

echo "$A(07) adding padding ...$B"
dd if=/dev/zero of=out/padding.bin bs=$((512 * $KERNEL_SECTORS - `wc -c < out/all.bin` + 1)) count=1 2> /dev/null
cat out/all.bin out/padding.bin > out/os.bin
