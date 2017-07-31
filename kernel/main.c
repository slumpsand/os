#include <drivers/vga2.h>

void main() {
  vga_text_init2();

  const char* this_wont_appear = "This won't appear ...";
  while(*this_wont_appear) vga_text_putc2(*this_wont_appear++);

  vga_text_next_line2();
  vga_text_clear2();

  const char* this_will_appear = "This will appear ...";
  while(*this_will_appear) vga_text_putc2(*this_will_appear++);
}
