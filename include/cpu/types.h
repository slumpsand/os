#pragma once

typedef unsigned char u8;
typedef signed   char i8;

typedef unsigned short u16;
typedef signed   short i16;

typedef unsigned int u32;
typedef signed   int i32;

typedef unsigned char bool;

#define low_16(addr)   ((u16) (addr & 0xFFFF))
#define high_16(addr)  ((u16) (addr >> 16))
