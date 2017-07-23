#include "driver/ports.h"

char port_byte_in (short port) {
  char result;

  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

  return result;
}

void port_byte_out(short port, char data) {
  __asm__("out %%al, %%dx" : : "a" (data) , "d" (port));
}

short port_word_in (short port) {
  short result;

  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

  return result;
}

void  port_word_out(short port, short data) {
  __asm__("out %%ax, %%dx" : : "a" (data), "b" (port));
}
