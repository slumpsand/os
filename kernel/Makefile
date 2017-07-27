CFILES := $(wildcard *.c)
HFILES := $(wildcard ../**/*.h)

OFILES := $(patsubst %.c,%.o,$(CFILES))

CFLAGS +=
AFLAGS +=

build: ../out/kernel.a

%.o: %.c $(HFILES)
	@echo "$(A)building '$<' (kernel)$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	@echo "$(A)assembling '$<' (kernel)$(B)"
	$(NASM) $(AFLAGS) $< -o $@

../out/kernel.a: $(OFILES) Makefile
	@echo "$(A)creating library: '$@'$(B)"
	$(AR) rs $@ $(OFILES)
