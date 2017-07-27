#include <cpu/types.h>

#include <kernel/print.h>

#include <drivers/vga.h>

extern u16 vga_text_test_once();

void main() {
  vga_text_init();

  println("Hello, World!");
}
