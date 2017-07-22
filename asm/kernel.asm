[bits 32]                      ; This file doesn't contain the kernel, but
                               ; calls the main function that the linker
[extern main]                  ; will tell NASM about later.

call main                      ; call the main function
jmp $
