#include <driver/ports.h>

#define WHITE_ON_BLACK  0x0F00

void main() {
  short cursor = 0;

  // get the cursor position (high byte)
  port_byte_out(0x3D4, 14);
  cursor = port_byte_in(0x3D5) << 8;

  // get the cursor position (low byte)
  port_byte_out(0x3D4, 15);
  cursor |= port_byte_in(0x3D5);

  short* vga = (short*) 0xB8000;

  vga[cursor] = WHITE_ON_BLACK | 'P';
}
