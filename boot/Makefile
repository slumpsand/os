../out/boot/:
	mkdir -p $@

../out/boot.bin: entry.asm $(wildcard *.asm)
	@echo "$(A)> assembling boot/entry.asm ...$(B)"
	$(NASM) -o $@ $<

../out/boot.list: | ../out/boot/ ../out/boot/kernel_entry.o
	@echo "$(A)boot complete ...$(B)"
	echo -n "$(abspath ../out/boot/kernel_entry.o) " > $@

../out/boot/kernel_entry.o: kernel_entry.asm
	$(NASM) $(AFLAGS) $< -o $@
