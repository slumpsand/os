#include "driver/ports.h"

char inb(short port) {
  char result;

  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

  return result;
}

void outb(short port, char data) {
  __asm__("out %%al, %%dx" : : "a" (data) , "d" (port));
}

short inw(short port) {
  short result;

  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

  return result;
}

void outw(short port, short data) {
  __asm__("out %%ax, %%dx" : : "a" (data), "b" (port));
}
