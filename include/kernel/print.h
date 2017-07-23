#define WHITE_ON_BLACK 0x0F

// change the cursor color
void set_color(char color);
// set the cursor position
void set_cursor(int row, int column);
// jump to the next line
void next_line();

// put a character on the screen
void putc(char ch);

// print a string to the screen
void print(char* str);
// print a string followed by a newline to the screen
void println(char* str);
// print a number to the screen
void print_num(long val, char is_decimal);

// clear the screen (and reset the cursor)
void clear();
