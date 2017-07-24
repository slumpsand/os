#pragma once

#include <cpu/types.h>

#define REG_SCREEN_CTRL 0x03D4
#define REG_SCREEN_DATA 0x03D5

#define VGA_CURSOR_HIGH 0x0E
#define VGA_CURSOR_LOW  0x0F

u8 inb(u16 port);
void outb(u16 port, u8 data);

u16 inw(u16 port);
void outw(u16 port, u16 data);
