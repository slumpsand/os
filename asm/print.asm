[org 0x7C00]

; print_str(str: addr)
print_str:
    pop dword [.str_addr]
    pusha

    add dword [.str_addr], 2 ; todo: why do I need to do this?

    mov ah, 0x0E

.loop:
    mov bx, [.str_addr]
    mov al, [bx]

    cmp al, 0
    je .done

    int 0x10
    inc dword [.str_addr]

    jmp .loop

.str_addr: resw 2

.done:
    popa
    ret
