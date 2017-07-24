[org 0x7C00]                              ; bootloader offset

KERNEL_OFFSET equ 1000h

    mov [BOOT_DRIVE], dl                  ; dl will point at the boot drive, save it

    mov bp, 9000h                         ; move the stack somewhere else
    mov sp, bp

    mov bx, KERNEL_OFFSET
    mov dh, 3                             ; for some reason this was '2' in the tutorial
    mov dl, [BOOT_DRIVE]                  ; but that didn't work ...

    call disk_load
    jmp switch_pm                         ; will never return

%include "boot/print.asm"
%include "boot/enter.asm"
%include "boot/disk.asm"

[bits 32]                                 ; will be executed in 32bit,
ENTER:                                    ; protected mode

    call KERNEL_OFFSET                    ; start the kernel   
 
    halt

BOOT_DRIVE db 0

times 510 - ($-$$) db 0                   ; fill the boot sector 
dw 0xAA55
