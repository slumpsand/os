#!/bin/bash

nasm -f bin boot_sector.asm -o boot_sector.bin
qemu-system-x86_64 -drive format=raw,file=boot_sector.bin
