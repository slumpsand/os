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

.continue
    int 0x10
    add bx, 1
    
    jmp .loop

; print_hex_b(val: byte)
print_hex_b:
    pusha

    ; todo: implement this

    popa
    ret

; print_hex_bs(arr: addr, count: byte)
print_hex_bs:
    pusha ; todo: will they collide?

    pop cl ; count
    pop bx ; addr

.loop:
    push [bx]
    call print_hex_b

    ; increment the address
    add bx, 1
    mov ax, bx

    ; decrement the counter
    sub cl, 1
    mov cl, al

    ; edge condition
    cmp cl, 0
    ja .loop

    popa
    ret

; parameters:
;   bx = the array address
;   cl = how many bytes
print_hex_bs:
    pusha

    mov ch, 0

.loop:
    mov al, [bx

    cmp ch, cl

    cmp cl, 0 ; will they collide?
    sub cl, 1
    ja .loop

    popa
    ret

; parameters:
;   bx = the word
print_hex_w:
    pusha ; save the register state

    mov cx, bx

    mov bl, ch
    call print_hex_b

    mov bl, cl
    call print_hex_b

    jmp print_str.done
