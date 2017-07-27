#include <cpu/types.h>

#include <kernel/util.h>

void memcpy(const u8* src, u8* dest, u32 n) {
  for (u32 i=0; i<n; i++)
    dest[i] = src[i];
}

void stringify_dec(i32 n, char* out) {
  const bool sign = n < 0;
  if (sign) n = -n;

  u8 i = 0;
  do {
    out[i++] = n % 10 + '0';
  } while((n /= 10) > 0);

  if (sign) out[i++] = '-';
  out[i++] = 0;

  // TODO: reverse the string
}

void stringify_hex(i32 n, char* out) {
  const bool sign = n < 0;
  if (sign) n = -n;

  u8 i = 0;
  do {
    u8 c = n % 16 + '0';
    out[i++] = (c > 0x39)? c + 7 : c;
  } while((n /= 16) > 0);

  if (sign) out[i++] = '-';
  out[i++] = 0;

  // TODO: reverse the string
}
