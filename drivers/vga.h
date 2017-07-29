#pragma once

#include <cpu/types.h>

#define VGA_TEXT_MAX_ROW 25
#define VGA_TEXT_MAX_COL 80
#define VGA_TEXT_TAB_SIZE 4

#define VGA_TEXT_WHITE_ON_BLACK 0x0F00
#define VGA_TEXT_RED_ON_BLACK   0x0400

extern u16* vga_text_buffer;

extern u16 vga_text_cursor_row;
extern u16 vga_text_cursor_col;
extern u16 vga_text_cursor_color;

// update the cursor position on the screen
void vga_text_update();

// get the offset in the vga_text_buffer
u16 vga_text_get_offset();

// move the cursor and break a line if necessary
void vga_text_move_cursor();

// move the cursor into the next line
void vga_text_next_line();

// clear the screen
void vga_text_clear();

void vga_text_set_cursor(u16 x, u16 y);
