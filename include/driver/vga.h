#pragma once

#define VGA_TEXT_MAX_ROW 25
#define VGA_TEXT_MAX_COL 80
#define VGA_TEXT_TAB_SIZE 4

#define VGA_TEXT_WHITE_ON_BLACK 0x0F00
#define VGA_TEXT_RED_ON_BLACK   0x0400

extern short* vga_text_buffer;

extern char vga_text_cursor_row;
extern char vga_text_cursor_col;
extern short vga_text_cursor_color;

// update the cursor position on the screen
void vga_text_update();

// clear the screen and reset the cursor to (0, 0)
void vga_text_clear();

// get the offset in the vga_text_buffer
short vga_text_get_offset();

// move the cursor and break a line if necessary
void vga_text_move_cursor();

// move the cursor into the next line
void vga_text_next_line();

// set default values and clear the screen
void vga_text_init();
