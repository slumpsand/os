[org 0x7C00]

    mov bx, HELLO
    call print
    call print_nl

    mov bx, GOODBYE
    call print
    call print_nl

    mov dx, 0x12FE
    call print_hex
    call print_nl

    jmp $ ; $ = current address

HELLO:
    db "Hello, World!", 0

GOODBYE:
    db "And bye ...", 0

%include "print.asm"

    times 510-($-$$) db 0
    dw 0xAA55
