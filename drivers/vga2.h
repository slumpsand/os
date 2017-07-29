#pragma once

#include <cpu/types.h>

// read all the information from the VGA
void vga_text_init2();

// clear the screen and move the cursor to (0, 0)
void vga_text_clear2();

// create a newline
void vga_text_next_line2();

// put a character on the screen
void vga_text_putc2(char ch);

// move the cursor to a specific position
void vga_text_set_cursor2(u8 x, u8 y);

// set the color / background / ... byte
void vga_text_set_color2(u8 color);
