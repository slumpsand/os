add-symbol-file out/boot_sector.elf 0x7C00

target remote | qemu -S -gdb stdio -drive "format=raw,file=out/boot_sector.bin"
