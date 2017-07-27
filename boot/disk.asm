[bits 16]
disk_load:
        pusha
        push dx

        mov ah, 0x02
        mov al, dh
        mov cl, 0x02
        mov ch, 0x00
        mov dh, 0x00

        int 0x13
        jc .derror

        pop dx
        cmp al, dh
        jne .serror

        popa
        ret

.derror:
        mov bx, MSG_DISK_ERROR
        call println

        mov dh, ah
        call print_hex

        jmp $

.serror:
        mov bx, MSG_SECTOR_ERROR
        call println

        jmp $

MSG_DISK_ERROR db "Can not read from disk", 0
MSG_SECTOR_ERROR db "Invalid amount of sectors read", 0
MSG_STEP db "Step", 0
