#include <print.h>

#define VIDEO_MEMORY 0xB8000

#define MAX_COL 160
#define MAX_ROW 25
#define TAB_SIZE 4

static int cursor_row, cursor_col;
static short cursor_color;

static short* get_pos() {
  return (short*) (VIDEO_MEMORY + (2 * cursor_col + cursor_row * MAX_COL));
}

static void move_cursor(int n) {
  cursor_col += n;
  if(cursor_col >= MAX_COL) {
     cursor_col = 0;
     cursor_row++;
  }

  if(cursor_row >= MAX_ROW) {
    // TODO: move buffer up
  }
}

void set_color(char color) {
  cursor_color = (short)color << 8;
}

void set_cursor(int row, int column) {
  cursor_row = row;
  cursor_col = column;
}

void next_line() {
  cursor_row++;
  cursor_col = 0;
}

void putc(char ch) {
  short* pos = get_pos();

  *pos = cursor_color | ch;

   move_cursor(1);
}

void print(char* str) {
  char ch;
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

void println(char* str) {
  print(str);
  if(cursor_col != 0) next_line();
}

void clear() {
  cursor_row = cursor_col = 0;

  // yes, integers i just clear two shorts at the same time ...
  int* pos = (int*) VIDEO_MEMORY;
  int max_pos = (MAX_COL * MAX_ROW) / 2;

  while(max_pos-- > 0)
    *pos++ = 0;
}
