#include <drivers/vga2.h>

void main() {
  vga_text_init2();

  const char* str = "Hello, World!";

  while(*str)
    vga_text_putc2(*str++);
}
