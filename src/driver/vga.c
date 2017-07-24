#include <driver/vga.h>

#include <driver/ports.h>

short* vga_text_buffer;

char vga_text_cursor_row;
char vga_text_cursor_col;
short vga_text_cursor_color;

short vga_text_get_offset() {
  return vga_text_cursor_row * VGA_TEXT_MAX_COL + vga_text_cursor_col;
}

void vga_text_update() {
  const short offset = vga_text_get_offset();

  // write the high byte
  outb(0x03D4, 0x0E);
  outb(0x03D5, offset >> 8);

  // write the low byte
  outb(0x03D4, 0x0E);
  outb(0x03D5, offset & 0xFF);
}

void vga_text_clear() {
  // reset the buffer
  for (int r = 0; r < VGA_TEXT_MAX_ROW; r++)
    for (int c = 0; c < VGA_TEXT_MAX_COL; c++)
      vga_text_buffer[r*VGA_TEXT_MAX_COL + c] = 0;

  // reset the cursor
  vga_text_cursor_row = 0;
  vga_text_cursor_col = 0;
  vga_text_update();
}

void vga_text_move_cursor() {
  // don't let the text go further than the screen size
  if(++vga_text_cursor_col >= VGA_TEXT_MAX_COL)
    vga_text_next_line();

  vga_text_update();
}

void vga_text_next_line() {
  vga_text_cursor_col = 0;
  vga_text_cursor_row++;

  // TODO: check that vga_text_cursor_row
  // doesn't exceed VGA_TEXT_MAX_ROW ...

  vga_text_update();
}
