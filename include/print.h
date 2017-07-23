#include <types.h>

#define WHITE_ON_BLACK 0x0F

// change the cursor color
void set_color(uchar color);
// set the cursor position
void set_cursor(uint row, uint column);
// jump to the next line
void next_line();

// put a character on the screen
void putc(uchar ch);

// print a string to the screen
void print(uchar* str);
// print a string followed by a newline to the screen
void println(uchar* str);
// print a number to the screen
void print_num(ulong val, uchar is_decimal);

// clear the screen (and reset the cursor)
void clear();
