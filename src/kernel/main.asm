extern vga_init
extern vga_print

main:
	call vga_init

	push HELLO_WORLD
	call vga_print

	ret

HELLO_WORLD db "Hello, World!", 0
