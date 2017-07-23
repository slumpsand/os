#include <kernel/print.h>

#include <driver/ports.h>

void main() {
  short cursor = 0;

  // get the cursor position (high byte)
  port_byte_out(0x3D4, 14);
  cursor = port_byte_in(0x3D5) << 8;

  // get the cursor position (low byte)
  port_byte_out(0x3D4, 15);
  cursor |= port_byte_in(0x3D5);

  // each character is described by two bytes
  int offset = cursor * 2;

  char* vga = (char*) 0xB8000;

  vga[offset] = 'X';
  vga[offset+1] = WHITE_ON_BLACK;
}
