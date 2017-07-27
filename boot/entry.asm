[org 0x7C00]                            ; boot-loader offset
[bits 16]

        mov [BOOT_DRIVE], dl            ; the BIOS will put the drive number
                                        ; into dl

        mov bx, 0x9000                  ; move the stack to 0x9000,
        mov sp, bp

        call load_text                  ; load the code/data into RAM
        call load_data

        call clear_stack                ; make sure, that the stack is zeroed out

        jmp enter_protected             ; enter 32-bit protected mode

clear_stack:
        pusha
        mov si, STCK_SEC_SIZE * 512

.clr:
        mov ax, si
        add ax, BOOT_SEC_SIZE * 512
        mov [ax], 0

        loop .clr

        popa
        ret

%include "disk.asm"
%include "enter.asm"

BOOT_SEC_SIZE equ 0x08                  ; 4 KiB
STCK_SEC_SIZE equ 0x28                  ; 20 KiB
DATA_SEC_SIZE equ 0x28                  ; 20 KiB
CODE_SEC_SIZE equ 0x28                  ; 20 KiB

STCK_SEC_OFFSET equ BOOT_SEC_SIZE
DATA_SEC_OFFSET equ STCK_SEC_OFFSET + STCK_SEC_SIZE
CODE_SEC_OFFSET equ DATA_SEC_OFFSET + DATA_SEC_SIZE

        times 510 - ($ - $$) db 0       ; fill the remaining boot-sector with zeros
        dw 0xAA55                       ; and leave the 'magic' boot-number for the BIOS
