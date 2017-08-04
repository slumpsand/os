%include "drivers/vga_h.asm"

global main
main:
	call vga_text_init

	push HELLO_WORLD
	call vga_text_print_simple

	ret

HELLO_WORLD db "Hello, World! (ASM)", 0
