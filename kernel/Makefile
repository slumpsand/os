NAME := kernel

CFLAGS +=
AFLAGS +=

OFILES := $(patsubst %.c,../out/$(NAME)/%.o,$(wildcard *.c)) \
          $(patsubst %.asm,../out/$(NAME)/%.o,$(wildcard *.asm))

../out/$(NAME).list: $(OFILES)
	@echo "$(A)$(NAME) complete ...$(B)"
	echo $(OFILES) > $@

../out/$(NAME)/%.o: %.c $(HEADERS)
	@echo "$(A)building '$<' ($(NAME)) ...$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

../out/$(NAME)/%.o: %.asm
	@echo "$(A)assembling '$<' ($(NAME)) ...$(B)"
	$(ASM) $(AFLAGS) $< -o $@
