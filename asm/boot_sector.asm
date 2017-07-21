[org 0x7C00]

    mov bp, 8000h ; move the stack
    mov sp, bp

    mov bx, 9000h
    mov dh, 2

    call disk_load

    mov dx, [9000h]
    call print_hex
    call print_nl

    mov dx, [9000h + 512]
    call print_hex

    jmp $ ; loop forever

%include "print.asm"
%include "disk.asm"

HELLO:
  db "Hello!", 0

    ; magic number
    times 510-($-$$) db 0
    dw 0xAA55

    ; sector two
    times 256 dw 0xDADA
    
    ; sector three
    times 256 dw 0xFACE
