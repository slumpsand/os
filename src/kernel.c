#include <print.h>

void main() {
  set_color(WHITE_ON_BLACK);
  clear();

  print_num(0x1234, 0);
  next_line();

  println("Hello World");
}
