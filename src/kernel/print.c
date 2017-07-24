#include <cpu/types.h>

#include <kernel/print.h>

#include <driver/vga.h>

void putc(const u8 ch) {
  // put the character on the screen
  const u16 offset = vga_text_get_offset();
  vga_text_buffer[offset] = vga_text_cursor_color | ch;

  // move the cursor
  vga_text_move_cursor();
}

void print(const u8* str) {
  u8 ch;
  while (ch = *str++) {
    switch (ch) {
      case '\n':
        vga_text_next_line();
	break;

      case '\t':
	// move the cursor and reset the column if it wraped
	// because tabs shouldn't go around newlines
        for (u8 i = 0; i < VGA_TEXT_TAB_SIZE; i++) putc(' ');
	if (vga_text_cursor_col < VGA_TEXT_TAB_SIZE) {
          vga_text_cursor_col = 0;
	  vga_text_update();
	}
	break;

      default:
        putc(ch);
    }
  }
}

void println(const u8* str) {
  print(str);
  if(vga_text_cursor_col != 0)
    vga_text_next_line();
}
