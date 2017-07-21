[org 0x7C00]

; print_nl()
print_nl:
    pusha
    
    mov ah, 0x0E ; tty-mode
    
    mov al, 0x0A ; LF
    int 0x10
    
    mov al, 0x0D ; CR
    int 0x10

    popa
    ret


; print_str(str_addr: bx)
print_str:
    pusha

    mov ah, 0x0E

.loop:
    mov al, [bx]
    cmp al, 0
    je .end

    int 0x10
    add bx, 1
    mov bx, ax

    jmp .loop

.end:
    popa
    ret

; print_hex_b(val_byte: ch)
print_hex_b:
    pusha

    mov cl, ch

    ; todo: implement this

    popa
    ret

; print_hex_bs(arr_addr: bx, count_byte: cl)
print_hex_bs:
    pusha

.loop:
    ; print the byte
    mov ch, bx
    call print_hex_b

    ; increment the address
    add bx, 1
    mov 

    ; decrement the counter
    sub cl, 1
    mov cl, al

    ; edge condition
    cmp cl, 0
    jna .end

    ; print a space
    mov ax, 0x0E20
    int 0x10

    jmp .loop

.end:
    popa
    ret

; print_hex_w(val_word: bx)
print_hex_w:
    pusha

    mov ch, bh
    call print_hex_b

    mov ch, bl
    call print_hex_b

    popa
    ret

; print_hex_ws(arr_addr: ax, count_byte: cl)
print_hex_ws:
    pusha

.loop:
    ; print the word
    push bx
    mov bx, [bx]
    call print_hex_w
    pop bx

    ; increment the address
    add bx, 1
    mov bx, ax

    ; decrement the counter
    sub cl, 1
    mov cl, al

    ; edge condition
    cmp cl, 0
    jna .end

    ; print a space
    mov ax, 0x0E20
    int 0x10

    jmp .loop

.end:
    popa
    ret

