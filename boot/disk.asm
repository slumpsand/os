[bits 16]

BOOT_DRIVE              resb 1

SECTORS_PER_CYLINDER equ 18
CYLINDERS_PER_HEAD equ

load_text:
        mov ah, 0x02
        mov al, CODE_SEC_SIZE

        mov ch, CODE_SEC_OFFSET / SECTORS_PER_CYLINDER
        mov cl, CODE_SEC_OFFSET % SECTORS_PER_CYLINDER

        mov dh, 0x00
        mov dl, [BOOT_DRIVE]

        mov es, 0x0000
        mov bx, CODE_SEC_OFFSET * 512

        int 0x13
        jc disk_error

        cmp al, CODE_SEC_SIZE
        jne sector_error

        ret

load_data:
        mov ah, 0x02
        mov al, DATA_SEC_SIZE

        mov ch, 0x00

        mov dh, 0
        mov dl, [BOOT_DRIVE]

        mov es, 0x0000
        mov bx, DATA_SEC_OFFSET * 512

        int 0x13
        jc disk_error

        cmp al, DATA_SEC_SIZE
        jne sector_error

        ret

disk_error:
        mov bx, .MESSAGE
        call println
        jmp $
.MESSAGE db "disk error while reading segments", 0

sector_error:
        mov bx, .MESSAGE
        call println
        jmp $
.MESSAGE db "disk-sector error while reading segments", 0
