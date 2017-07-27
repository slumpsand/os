[bits 16]

print:
        pusha
        mov ah, 0x0E

.loop:
        mov al, [bx]
        cmp al, 0
        je .end

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

print_hex:
        pusha

        mov cx, 0

.loop:
        cmp cx, 4
        je .end

        mov ax, dx
        and ax, 0x000F
        add al, 0x30

        cmp al, 0x39
        jle .step2
        add al, 7

.step2:
        mov bx, .out + 5
        sub bx, cx
        mov [bx], al
        ror dx, 4

        inc cx
        jmp .loop

.end:
        mov bx, .out
        call print

        popa
        ret

.out db "0x0000", 0

println:
        call print
        call print_nl

[bits 32]
pm_print:
        pusha
        mov edx, VIDEO_MEMORY
        mov ah, WHITE_ON_BLACK

.loop:
        mov al, [eax]
        cmp al, 0
        je .end

        mov [edx], ax
        inc ebx
        add edx, 2

        jmp .loop

.end:
        popa
        ret
