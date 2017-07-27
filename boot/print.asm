[bits 16]
print:                             ; bx points at the string
    pusha

.loop:
    mov al, [bx]
    cmp al, 0
    je .end

    mov ah, 0x0E
    int 0x10

    inc bx
    jmp .loop

.end:
    popa
    ret

print_nl:
    pusha

    mov ax, 0x0E0A
    int 0x10

    mov ax, 0x0E0D
    int 0x10

    popa
    ret

print_hex:                         ; dx points at the word
    pusha

    mov cx, 0

.loop:
    cmp cx, 4
    je .end

    mov ax, dx
    and ax, 0x0F
    add ax, 0x30

    cmp al, 0x39
    jle .step2

    add al, 7

.step2:
    mov bx, .HEX_OUT + 5
    sub bx, cx
    mov [bx], al
    ror dx, 4

    inc cx
    jmp .loop

.end:
    mov bx, .HEX_OUT
    call print

    popa
    ret

.HEX_OUT:
    db "0x0000", 0
