#!/bin/bash
set -e

# settings
QEMU=qemu-system-i386
GDB=i386-elf-gdb
GDB_PORT=6001

"$QEMU" -gdb "tcp::$GDB_PORT" -S -drive "format=raw,file=out/os.bin" > out/qemu.log 2>&1 &
QEMU_PID="$!"

"$GDB" -q \
	-ex "symbol-file out/all.elf" \
	-ex "dir src/" \
	-ex "target remote localhost:$GDB_PORT" \
	-ex "shell clear"

kill -SIGTERM "$QEMU_PID" 2> /dev/null ||:
