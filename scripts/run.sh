#!/bin/bash
set -e

QEMU="${QEMU:-qemu-system-x86_64}"
NASM="${NASM:-nasm}"

FILENAME="${1:-boot_sector}"

A=`tput setaf 3 && tput bold`
B=`tput sgr0`

INFILE="asm/$FILENAME.asm"
OUTFILE="out/$FILENAME.bin"

echo "$A(01) building '$INFILE' ('$OUTFILE') ...$B"
"$NASM" -f bin "$INFILE" -Iasm/ -o "$OUTFILE"

echo "$A(02) running '$OUTFILE' ...$B"
"$QEMU" -drive "format=raw,file=$OUTFILE"
