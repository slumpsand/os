int _cursor_row = 0, _cursor_col = 0;
char _color = 0xF; // white on black

void set_color(char color) {
  _color = color;
}

void set_cursor(int row, int column) {
  _cursor_row = row;
  _cursor_col = column;
}

void next_line() {
  _cursor_row++;
  _cursor_col = 0;
}

void putc(char ch) {
  char* pos = VIDEO_MEMORY + 2 * (_cursor_row * MAX_COL + col);
  *pos = ch << 8 + _color;

  if (++_cursor_row >= MAX_COL) {
    _cursor_row = 0;
    _cursor_col++;
  }
}

void print(char* str) {
  while(char ch = *str++) { putc(ch); }
}

void println(char* str) {
  print(str);
  if(_corsor_col != 0) next_line();
}
