[org 0x7C00]

; print_str(str: addr)
print_str:
    pop dword [.str_addr]
    pusha

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
