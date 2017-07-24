#pragma once

#include <cpu/types.h>

void memcpy(u8* src, u8* dest, u32 n);
void stringify_dec(i32 n, u8* out);
void stringify_hex(i32 n, u8* out);
