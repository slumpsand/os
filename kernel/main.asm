%include "drivers/vga_h.asm"

global main
main:
	call vga_text_init

	push HELLO_WORLD
	call vga_text_print

	ret

HELLO_WORLD db "Hello, World!", 0
