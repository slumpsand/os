#include <kernel/print.h>

#include <driver/vga.h>

void main() {
  vga_text_init();

  println("Hello, World!");
  vga_text_cursor_color = VGA_TEXT_RED_ON_BLACK;
  println("This is Red!");
}
