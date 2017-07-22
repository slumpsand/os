#define VIDEO_MEMORY 0xb8000

void main() {
   char* pos = (char*) VIDEO_MEMORY;
   *pos = 'X';
}
