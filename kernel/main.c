#include <drivers/vga.h>

void main() {
  vga_text_init();

  vga_text_print("YAY\nThis goes into the next line ... and here is\ta tab...");
}
