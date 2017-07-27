CFILES := $(wildcard *.c)
HFILES := $(wildcard ../**/*.h)
AFILES := $(wildcard *.asm)

OFILES := $(patsubst %.c,%.o,$(CFILES)) $(patsubst %.asm,%.o,$(AFILES))

CFLAGS +=
AFLAGS +=

build: ../out/cpu.a

%.o: %.c $(HFILES)
	@echo "$(A)building '$<' (cpu)$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	@echo "$(A)assembling '$<' (cpu)$(B)"
	$(NASM) $(AFLAGS) $< -o $@

../out/cpu.a: $(OFILES) Makefile
	@echo "$(A)creating library: '$@'$(B)"
	$(AR) rs $@ $(OFILES)
