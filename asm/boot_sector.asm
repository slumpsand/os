[org 0x7C00]

    mov ah, 0x0E ; enter tty mode

    mov bx, mystring
    call print_str
    call print_nl

    jmp $ ; $ = current address

mystring:
    db "Hello, World!", 0

%include "print.asm"

    times 510-($-$$) db 0 ; write everything with zeroes except the last two bytes
    dw 0xAA55
