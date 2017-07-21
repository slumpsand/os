disk_load:
    pusha
    push dx

    mov ah, 2 ; 'read'
    mov al, dh ; n of sectors
    mov cl, 2 ; sector
    mov ch, 0 ; cylinder
    mov dh, 0 ; head number

    int 13h
    jc .disk_error

    pop dx
    cmp al, dh
    jne .sector_error
    
    popa
    ret

.disk_error:
    mov bx, .DISK_ERROR
    call print
    call print_nl

    mov dh, ah
    call print_hex

    jmp .disk_loop

.sector_error:
    mov bx, .SECTOR_ERROR
    call print

.disk_loop:
    jmp $

.DISK_ERROR:       db "Can't read from disk.", 0
.SECTOR_ERROR:     db "Incorrect number of sectors.", 0
