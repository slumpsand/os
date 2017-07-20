[org 0x7C00]

    mov ah, 0x0E ; enter tty mode

    ; print "Hello' to the console
    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    int 0x10
    mov al, 'o'
    int 0x10

    mov al, [the_secret] ; print the secret character
    int 0x10

    jmp $ ; $ = current address

the_secret:
    db "X"

    times 510-($-$$) db 0 ; write everything with zeroes except the last two bytes
    dw 0xAA55
