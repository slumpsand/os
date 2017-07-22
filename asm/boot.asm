[org 0x7C00]                              ; bootloader offset

KERNEL_OFFSET equ 0x1000                  ; the kernel offset (what I specify when
                                          ; linking)

    mov [BOOT_DRIVE], dl                  ; dl will point at the boot drive, save it

    mov bp, 0x9000                        ; move the stack somewhere else
    mov sp, bp

    mov bx, KERNEL_OFFSET                 ; load the kernel into memory
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load

    jmp switch_pm                         ; will never return

%include "print.asm"
%include "enter.asm"
%include "disk.asm"

[bits 32]                                 ; will be executed in 32bit,
ENTER:                                    ; protected mode

    call KERNEL_OFFSET                    ; start the kernel   
 
    jmp $

times 510 - ($-$$) db 0                   ; fill the boot sector 
dw 0xAA55
