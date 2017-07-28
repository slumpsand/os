#pragma once

#include <cpu/types.h>

void memcpy(const u8* src, u8* dest, u32 n);
void memcpy2(u8* dest, const u8* src, u32 n); // this is more helpfull in assembly
void stringify_dec(i32 n, char* out);
void stringify_hex(i32 n, char* out);
