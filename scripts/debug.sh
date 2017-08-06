#!/bin/bash
set -e

# this script shold be executed at the root directroy level
# the qemu-output will be written in out/qemu.log

# settings
QEMU=qemu-system-i386
GDB=i386-elf-gdb
GDB_PORT=6001

A=`tput setaf 6 && tput bold`
B=`tput sgr0`

./scripts/build.sh

echo "$A(08) running emulator (DEBUG) ...$B"
"$QEMU" -gdb "tcp::$GDB_PORT" -S -drive "format=raw,file=out/os.bin" > out/qemu.log 2>&1 &
QEMU_PID="$!"

echo "$A(09) starting debugger ...$B"
"$GDB" -q \
	-ex "symbol-file out/all.elf" \
	-ex "dir src/" \
	-ex "target remote localhost:$GDB_PORT"

echo "$A(10) stopping the emulator ...$B"
kill -SIGTERM "$QEMU_PID" 2> /dev/null ||:
