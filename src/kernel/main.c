#include <driver/ports.h>

#define WHITE_ON_BLACK  0x0F00

static short cursor_color;
static short* vga;

short get_cursor_new() {
  port_byte_out(0x3D4, 0x0E);
  short cursor = port_byte_in(0x3D5) << 8;

  port_byte_out(0x3D4, 0x0F);
  return cursor | port_byte_in(0x3D5);
}

void set_cursor_new(const short cursor) {
  port_byte_out(0x3D4, 0x0E);
  port_byte_out(0x3D5, cursor >> 8);

  port_byte_out(0x3D4, 0x0F);
  port_byte_out(0x3D5, cursor & 0xFF);
}

void putc_new(const char ch) {
  // put the character on the screen
  const short offset = get_cursor_new();
  vga[offset] = cursor_color | ch;

  // increment the offset and write it back
  set_cursor_new(offset + 1);
}

void main() {
  cursor_color = WHITE_ON_BLACK;
  vga = (short*) 0xB8000;

  putc_new('O');
	
	/*  short cursor = 0;

  // get the cursor position (high byte)
  port_byte_out(0x3D4, 14);
  cursor = port_byte_in(0x3D5) << 8;

  // get the cursor position (low byte)
  port_byte_out(0x3D4, 15);
  cursor |= port_byte_in(0x3D5);
*/
/*
  short cursor = get_cursor();
  short* vga = (short*) 0xB8000;

  vga[cursor] = WHITE_ON_BLACK | 'P';
*/}
