#include <cpu/types.h>

#include <drivers/vga.h>
#include <drivers/ports.h>

#include <kernel/util.h>

u16* vga_text_buffer;

u8 vga_text_cursor_row;
u8 vga_text_cursor_col;
u16 vga_text_cursor_color;

static u16 _vga_text_get_offset(u8 row, u8 col) {
  return row * VGA_TEXT_MAX_COL + col;
}

u16 vga_text_get_offset() {
  return _vga_text_get_offset(vga_text_cursor_row, vga_text_cursor_col);
}

void vga_text_update() {
  const u16 offset = vga_text_get_offset();

  // write the high byte
  outb(REG_SCREEN_CTRL, VGA_CURSOR_HIGH);
  outb(REG_SCREEN_DATA, offset >> 8);

  // write the low byte
  outb(REG_SCREEN_CTRL, VGA_CURSOR_LOW);
  outb(REG_SCREEN_DATA, offset & 0xFF);
}

void vga_text_clear() {
  // reset the buffer
  for (u8 r = 0; r < VGA_TEXT_MAX_ROW; r++)
    for (u8 c = 0; c < VGA_TEXT_MAX_COL; c++)
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

  // scroll if necessary
  if(++vga_text_cursor_row >= VGA_TEXT_MAX_ROW) {
    // move all the lines up (except the first one)
    for (u8 i=1; i<VGA_TEXT_MAX_ROW; i++)
      memcpy((u8*) (vga_text_buffer + _vga_text_get_offset(i, 0)),
             (u8*) (vga_text_buffer + _vga_text_get_offset(i-1, 0)),
	     VGA_TEXT_MAX_COL*2);

    // clear the last line
    for (u8 i=0; i<VGA_TEXT_MAX_COL; i++)
      vga_text_buffer[_vga_text_get_offset(VGA_TEXT_MAX_ROW-1, i)] = 0;

    vga_text_cursor_row--;
  }

  vga_text_update();
}

void vga_text_init() {
  vga_text_buffer = (u16*) 0xB8000;
  vga_text_cursor_color = VGA_TEXT_WHITE_ON_BLACK;
  vga_text_clear();
}
