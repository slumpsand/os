#include <cpu/types.h>

#include <kernel/print.h>

#include <drivers/vga.h>

extern u16 vga_text_test_once();

void main() {
  vga_text_init();

  char* arr[40] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",
                    "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27",
                    "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39" };

  for(int i=0; i<40; i++)
    println(arr[i]);
}
