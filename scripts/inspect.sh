#!/bin/bash
set -e 

NASM="${NASM:=nasm}"
XXD="${XXD:=xxd}"

FILENAME="${1:=boot_sector}"

A=`tput setaf 3 && tput bold`
B=`tput sgr0`

INFILE="asm/$FILENAME.asm"
OUTFILE="out/$FILENAME.bin"

echo "$A(01) building '$INFILE' ('$OUTFILE') ...$B"
"$NASM" -f bin "$INFILE" -o "$OUTFILE"

echo "$A(02) inspecting '$OUTFILE' ...$B"
"$XXD" "$OUTFILE"
