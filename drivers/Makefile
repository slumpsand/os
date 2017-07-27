CFILES := $(wildcard *.c)
HFILES := $(wildcard ../**/*.h)

OFILES := $(patsubst %.c,%.o,$(CFILES))

CFLAGS +=
AFLAGS +=

build: ../out/drivers.a

%.o: %.c $(HFILES)
	@echo "$(A)building '$<' (drivers)$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	@echo "$(A)assembling '$<' (drivers)$(B)"
	$(NASM) $(AFLAGS) $< -o $@

../out/drivers.a: $(OFILES) Makefile
	@echo "$(A)creating library: '$@'$(B)"
	$(AR) rs $@ $(OFILES)
