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


; print_str(str: addr)
print_str:
    pusha   ; todo: do they collide?
    pop bx

    mov ah, 0x0E

.loop:
    mov al, [bx]
    cmp al, 0
    jne .continue

    popa
    ret

.continue:
    int 0x10
    add bx, 1
    
    jmp .loop

; print_hex_b(val: byte)
print_hex_b:
    pusha

    pop ax ; val
    mov ah, 0

    ; todo: implement this

    popa
    ret

; print_hex_bs(arr: addr, count: byte)
print_hex_bs:
    pusha ; todo: will they collide?

    pop cx ; count
    pop bx ; addr

.loop:
    push word [bx]
    call print_hex_b

    ; increment the address
    add bx, 1
    mov bx, ax

    ; decrement the counter
    sub cl, 1
    mov cl, al

    ; edge condition
    cmp cl, 0
    ja .loop

    popa
    ret

; print_hex_w(val: word)
print_hex_w:
    pusha ; todo: will they collide?

    pop ax ; val
    mov bh, 0

    mov bl, ah
    push bx
    call print_hex_b

    mov bl, al
    push bx
    call print_hex_b

    popa
    ret

; print_hex_ws(arr: addr, count: byte)
print_hex_ws:
    pusha

    pop cx ; count
    pop bx ; arr

.loop:
    push word [bx]
    call print_hex_w

    ; increment the address
    add bx, 1
    mov bx, ax

    ; decrement the counter
    sub cl, 1
    mov cl, al

    ; edge condition
    cmp cl, 0
    ja .loop

    popa
    ret
