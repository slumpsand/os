[org 0x7C00]

; print_str(str: addr)
print_str:
    pop word [.str]
    pusha

.loop:
    mov bx, [.str]
    mov al, [bx]

    cmp al, 0
    je .end

    mov ah, 0x0E
    int 0x10

    inc word [.str]

    jmp .loop

.end:
    popa
    ret

.str:
    dw 0
