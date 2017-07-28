#include <cpu/types.h>

#include <kernel/print.h>

#include <drivers/vga.h>

void putc(const char ch) {
  const u16 offset = vga_text_get_offset();
  vga_text_buffer[offset] = vga_text_cursor_color | ch;

  vga_text_move_cursor();
}

void print(const char* str) {
  u8 ch;
  while ((ch = *str++)) {
    switch (ch) {
      case '\n':
        vga_text_next_line();
	       break;

      case '\t':
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

void println(const char* str) {
  print(str);
  if(vga_text_cursor_col != 0)
    vga_text_next_line();
}
