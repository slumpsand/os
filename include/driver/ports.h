#pragma once

#define REG_SCREEN_CTRL 0x03D4
#define REG_SCREEN_DATA 0x03D5

#define VGA_CURSOR_HIGH 0x0E
#define VGA_CURSOR_LOW  0x0F

char inb(short port);
void outb(short port, char data);

short inw(short port);
void outw(short port, short data);
