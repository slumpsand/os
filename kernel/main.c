#include <drivers/vga.h>

void main() {
  vga_text_init();

  println("1234567\t8");
  println("next\tand yay");
}
