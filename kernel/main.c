#include <drivers/vga.h>

void main() {
  vga_text_init();

  vga_text_print("Hello, World!");
}
