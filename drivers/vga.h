#pragma once

#include <cpu/types.h>

// read all the information from the VGA
void vga_text_init();

// clear the screen and move the cursor to (0, 0)
void vga_text_clear();

// create a newline
void vga_text_next_line();

// put a character on the screen
void vga_text_putc(char ch);

// move the cursor to a specific position
void vga_text_set_cursor(u8 x, u8 y);

// set the color / background / ... byte
void vga_text_set_color(u8 color);

// print a simple string (without escapes) on the screen
void vga_text_print_simple(const char* str);

// print a string (with escapes) on the screen
void vga_text_print(const char* str);
