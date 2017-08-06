#!/bin/bash
set -e

# INFO: this script shold be executed at the root directroy level

# settings
QEMU=qemu-system-i386

A=`tput setaf 6 && tput bold`
B=`tput sgr0`

./scripts/build.sh

echo "$A(08) running the emulator (RUN) ...$B"
"$QEMU" -drive "format=raw,file=out/os.bin"
