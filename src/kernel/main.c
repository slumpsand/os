#include <kernel/print.h>

#include <driver/vga.h>

void main() {
  // TODO: either put that into default,
  // or create a vga_text_init function
  vga_text_buffer = (short*) 0xB8000;
  vga_text_cursor_color = VGA_TEXT_WHITE_ON_BLACK;
  vga_text_clear();

  println("Hello, World!");
}
