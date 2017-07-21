#!/bin/bash
set -e

# aliases
alias qemu="${QEMU:-qemu-system-x86_64}"
alias gdb="${GDB:-gdb}"
alias nasm="${NASM:-nasm}"
alias objcopy="${OBJCOPY:-objcopy}"

# command line arguments
FILENAME="${1:-boot_sector}"
DEBUG="${2:-TRUE}"

# settings
QEMU_FLAGS="-S -s" # todo: second -s required?

# some helper variables
A=`tput setaf 3 && tput bold`
B=`tput sgr0`

# some computed variables
INFILE="asm/$FILENAME.asm"
ELFFILE="out/$FILENAME.elf"
BINFILE="out/$FILENAME.bin"

echo "$A(01) building '$INFILE' ('$ELFFILE') ...$B"
nasm -f elf -F dwarf "$INFILE" -I asm/ -o "$ELFFILE"

echo "$A(02) extracting binary '$BINFILE' ...$B"
objcopy -O binary "$ELFFILE" "$BINFILE"

echo "$A(03) running gdb / qemu ...$B"
gdb -x scripts/debug.gdb
