[org 0x7C00]                              ; bootloader offset

    mov bp, 9000h                         ; set the stack
    mov sp, bp

    jmp switch_pm                        ; will never return
                                          ; todo: make this a jump

%include "print.asm"
%include "gdt.asm"
%include "switch.asm"

[bits 32]                                 ; will be executed in 32bit,
ENTER:                                    ; protected mode
    mov ebx, MSG_PROT_MODE
    call print
    jmp $

MSG_PROT_MODE:
    db "YAY! 32-bit protected mode!", 0

times 510 - ($-$$) db 0                   ; fill the boot sector 
dw 0xAA55
