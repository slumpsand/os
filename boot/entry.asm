; My bootloader didn't work at some point (I made to many modifications at once).
; So i went back and took cfenollosas aproach.

[org 0x7C00]                                                                    ; set the file-origin to 0x7C00

KERNEL_OFFSET                   equ 0x1000                                      ; offset of the kernel-binary
VIDEO_MEMORY                    equ 0xB8000                                     ; address of the video memory
WHITE_ON_BLACK                  equ 0x0F

        mov [BOOT_DRIVE], dl                                                    ; save the boot-drive, the BIOS will put that in here

        mov bp, 0x9000                                                          ; move the stack somewhere safe
        mov sp, bp

        mov bx, MSG_REAL_MODE                                                   ; print a message to the screen
        call println

        call load_kernel                                                        ; load the kernel into RAM

        jmp switch_pm                                                           ; switch into 32-bit protected mode

%include "print.asm"
%include "disk.asm"
%include "gdt.asm"
%include "switch.asm"

[bits 16]
load_kernel:
        mov bx, MSG_LOAD_KERNEL
        call println

        mov bx, KERNEL_OFFSET                                                   ; load the kernel into memory
        mov dh, 16
        mov dl, [BOOT_DRIVE]
        call disk_load

        ret

[bits 32]
BEGIN:
        mov ebx, MSG_PROT_MODE
        call pm_println

        call KERNEL_OFFSET                                                      ; call the kernel
        jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE "I am in 16-Bit Real-Mode right now.", 0
MSG_PROT_MODE "I am in 32-bit Protected-Mode right now.", 0
MSG_LOAD_KERNEL "Loading kernel into memory", 0

times 510 - ($ - $$) db 0                                                       ; add some padding + magic number
dw 0xAA55
