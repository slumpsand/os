[bits 32]

; drivers - vga
extern vga_init
extern vga_clear
extern vga_color
extern vga_cursor
extern vga_simple_print
extern vga_print
extern vga_putc
extern vga_putt
extern vga_putnl

; kernel - main
extern main

; kernel - util
extern memcpy
