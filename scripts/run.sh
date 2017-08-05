#!/bin/bash
set -e

# INFO: this script shold be executed at the root directroy level

# settings
QEMU=qemu-system-i386

# prepare some variables
A=`tput setaf 6 && tput bold`
B=`tput sgr0`

# build the source
./scripts/build.sh

# run the emulator
"$QEMU" -drive "format=raw,file=out/os.bin"
