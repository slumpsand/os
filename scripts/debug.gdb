add-symbol-file out/boot_sector.elf 0x7C00

target remote | qemu-system-x86_64 -S -gdb stdio -drive "format=raw,file=out/boot_sector.bin"
