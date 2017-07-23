#include <print.h>
#include <types.h>

#define VIDEO_MEMORY 0xB8000

#define MAX_COL 160
#define MAX_ROW 25
#define TAB_SIZE 4

static uint cursor_row, cursor_col;
static ushort cursor_color;

static ushort* get_pos() {
  return (ushort*) (VIDEO_MEMORY + (2 * cursor_col + cursor_row * MAX_COL));
}

static void move_cursor(uint n) {
  cursor_col += n;
  if(cursor_col >= MAX_COL) {
     cursor_col = 0;
     cursor_row++;
  }

  if(cursor_row >= MAX_ROW) {
    // TODO: move buffer up
  }
}

void set_color(uchar color) {
  cursor_color = (ushort)color << 8;
}

void set_cursor(uint row, uint column) {
  cursor_row = row;
  cursor_col = column;
}

void next_line() {
  cursor_row++;
  cursor_col = 0;
}

void putc(uchar ch) {
  ushort* pos = get_pos();

  *pos = cursor_color | ch;

   move_cursor(1);
}

void print(uchar* str) {
  uchar ch;
  while(ch = *str++) {
    switch(ch) {
      case '\n':
        next_line();
	break;
      case '\t':
        move_cursor(TAB_SIZE);
	break;

      default:
        putc(ch);
    }
  }
}

void println(uchar* str) {
  print(str);
  if(cursor_col != 0) next_line();
}

void print_num(ulong val, uchar is_decimal) {
  const uchar factor = (is_decimal) ? 10 : 16;
  char str[8];
  schar index = 0;

  while(val > 0) {
    uchar v = val % factor + 0x30;
    str[index++] = (v > 0x39) ? v + 7 : v;

    val /= factor;
  }

  if(!is_decimal)
    print("0x");

  while(index >= 0) {
    const uchar ch = str[index--];
    if (ch != 0) putc(ch);
  }
}

void clear() {
  cursor_row = cursor_col = 0;

  // yes, integers i just clear two shorts at the same time ...
  int* pos = (int*) VIDEO_MEMORY;
  int max_pos = (MAX_COL * MAX_ROW) / 2;

  while(max_pos-- > 0)
    *pos++ = 0;
}
