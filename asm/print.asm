[bits 32]              ; 32-bit protected mode

VIDEO     equ 0xB800   ; where the video memory is located
W_ON_B    equ 0x0F     ; white text on black background

; eax = string address
print:
    pusha

    mov edx, VIDEO

.loop:
    mov al, [ebx]
    mov ah, W_ON_B

    cmp al, 0
    je .end

    mov [edx], ax      ; put the char on the screen
    
    add ebx, 1         ; increment the string address, todo: use inc
    add edx, 2         ; increment the video-memory-addres

    jmp .loop

.end:
    popa
    ret
