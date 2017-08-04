AFLAGS += -I../

OFILES := $(patsubst %.asm,../out/$(NAME)/%.o,$(filter-out $(wildcard *_h.asm),$(wildcard *.asm)))

../out/$(NAME).list: $(OFILES)
	@echo "$(A)$(NAME) complete ...$(B)"
	echo -n "$(abspath $(OFILES)) " > $@

../out/$(NAME)/:
	mkdir -p $@

../out/$(NAME)/%.o: %.asm ../out/$(NAME)/
	@echo "$(A)> assembling '$<' ($(NAME)) ...$(B)"
	$(NASM) $(AFLAGS) $< -o $@
