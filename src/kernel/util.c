#include <kernel/util.h>

void memcpy(char* src, char* dest, int n) {
  for (int i=0; i<n; i++)
    dest[i] = src[i];
}

void stringify_dec(int n, char* out) {
  const char sign = n < 0;
  if (sign) n = -n;

  char i = 0;
  do {
    out[i++] = n % 10 + '0';
  } while((n /= 10) > 0);

  if (sign) out[i++] = '-';
  out[i++] = 0;

  // TODO: reverse the string
}

void stringify_hex(int n, char* out) {
  const char sign = n < 0;
  if (sign) n = -n;

  char i = 0;
  do {
    char c = n % 16 + '0';
    out[i++] = (c > 0x39)? c + 7 : c;
  } while((n /= 16) > 0);

  if (sign) out[i++] = '-';
  out[i++] = 0;

  // TODO: reverse the string
}
