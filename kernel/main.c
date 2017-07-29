#include <cpu/types.h>

#include <kernel/print.h>

#include <drivers/vga.h>

void main() {
  vga_text_clear();

  println("Hello, World!");
}
