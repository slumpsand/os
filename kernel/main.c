#include <drivers/vga2.h>

void main() {
  vga_text_init2();
  vga_text_putc2('X');
}
