AFILES := $(wildcard *.asm)

AFLAGS :=

build: ../out/boot.bin

../out/boot.bin: $(AFILES)
	@echo "$(A)assembling 'out/boot.bin'$(B)"
	$(NASM) $(AFLAGS) boot.asm -o $@
