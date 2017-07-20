[org 0x7C00]

print_nl:
    pusha ; save the register state
    
    mov ah, 0x0E ; tty-mode
    
    mov al, 0x0A ; LF
    int 0x10
    
    mov al, 0x0E ; CR
    int 0x10

    jmp done

print_str:
    pusha ; save the register state

    ; parameters
    ;   bx = baseaddress

start:
    mov al, [bx] ; check for \0
    cmp al, 0
    je done

    mov ah, 0x0E ; tty-mode
    int 0x10

    add bx, 1 ; increment the address
    jmp start

done:
    popa ; recover the register state
    ret
