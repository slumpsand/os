../out/boot.bin: entry.asm $(wildcard *.asm)
	@echo "$(A)> assembling boot/entry.asm ...$(B)"
	$(NASM) -o $@ $<
