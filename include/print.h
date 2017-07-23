#define VIDEO_MEMORY 0xB8000
#define MAX_COL 80

void set_color(char color);
void set_cursor(int row, int column);
void next_line();

void putc(char ch);

void print(char* str);
void println(char* str);

