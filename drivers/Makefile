NAME := drivers

CFLAGS +=
AFLAGS +=

OFILES := $(patsubst %.c,../out/$(NAME)/%.o,$(wildcard *.c)) \
          $(patsubst %.asm,../out/$(NAME)/%.o,$(wildcard *.asm))

../out/$(NAME).list: $(OFILES)
	@echo -n "$(A)$(NAME) complete ...$(B)"
	echo $(abspath $(OFILES)) > $@

../out/$(NAME)/:
	mkdir -p $@

../out/$(NAME)/%.o: %.c $(HEADERS) ../out/$(NAME)/
	@echo "$(A)> building '$<' ($(NAME)) ...$(B)"
	$(CC) $(CFLAGS) -c $< -o $@

../out/$(NAME)/%.o: %.asm ../out/$(NAME)/
	@echo "$(A)> assembling '$<' ($(NAME)) ...$(B)"
	$(NASM) $(AFLAGS) $< -o $@
