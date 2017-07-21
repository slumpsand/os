[org 0x7C00]

    jmp $ ; loop forever

%include "print.asm"

    ; magic number
    times 510-($-$$) db 0
    dw 0xAA55
