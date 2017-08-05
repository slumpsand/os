#!/bin/bash
set -e

# this script shold be executed at the root directroy level
# the qemu-output will be written in out/qemu.log

# settings
QEMU=qemu-system-i386
GDB_PORT=6001

# prepare some variables
A=`tput setaf 6 && tput bold`
B=`tput sgr0`

# build the source
./scripts/build.sh

# start the emulator
echo "${A}running emulator ...${B}"
"$QEMU" -gdb "tcp::$GDB_PORT" -S -drive "format=raw,file=out/os.bin" > out/qemu.log 2>&1 &
echo "${A}qemu is running at pid $! ...${B}"
