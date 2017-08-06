#!/bin/bash
set -e

# settings
QEMU=qemu-system-i386

"$QEMU" -drive "format=raw,file=out/os.bin"
