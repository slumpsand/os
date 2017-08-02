CHECK := $(wildcard *.asm)

../out/boot.bin: entry.asm $(CHECK)
	@echo "$(A)> assembling boot/entry.asm ...$(B)"
	$(NASM) -o $@ $<
