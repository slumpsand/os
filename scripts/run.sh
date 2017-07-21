#!/bin/bash
set -e

QEMU="${QEMU:-qemu-system-x86_64}"
NASM="${NASM:-nasm}"

FILE="${1:-main}"

A=`tput setaf 3 && tput bold`
B=`tput sgr0`

INFILE="asm/$FILE.asm"
OUTFILE="out/$FILE.bin"

echo "$A(01) building '$INFILE' ('$OUTFILE') ...$B"
$NASM -f bin "$INFILE" -Iasm/ -o "$OUTFILE"

echo "$A(02) running '$OUTFILE' ...$B"
$QEMU -drive "format=raw,file=$OUTFILE"
