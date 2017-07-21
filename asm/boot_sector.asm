[org 0x7C00]

    mov bx, mystring
    push bx

    call print_str

    jmp $ ; $ = current address

mystring:
    db "Hello, World!", 0

%include "print.asm"

    times 510-($-$$) db 0 ; write everything with zeroes except the last two bytes
    dw 0xAA55
