; exported symbols
global vga_text_init2
global vga_text_putc2

; imported symbols

; constants
MAX_COL equ 80

; variables
cursor_x        db 0
cursor_y        db 0
color           dw 0x0F00

; void vga_text_init2()
vga_text_init2:
        ; read the higher byte
        mov al, 0x0F
        mov dx, 0x03D4
        out dx, al

        mov dx, 0x03D5
        in al, dx
        mov ch, al                      ; SWITCH?

        ; read the lower byte
        mov al, 0x0E
        mov dx, 0x03D4
        out dx, al

        mov dx, 0x03D5
        in al, dx
        mov cl, al                      ; SWITCH?

        ; calculate the row / col
        mov dx, 0
        mov ax, cx
        mov bx, MAX_COL
        div bx

        mov [cursor_x], dl
        mov [cursor_y], al

        ret

; void vga_text_putc2(char ch)
vga_text_putc2:
        mov bh, 0
        mov bl, [esp + 4]
        or bx, [color]
