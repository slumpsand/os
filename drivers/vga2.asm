; exported symbols
global vga_text_init2
global vga_text_putc2
global vga_text_next_line2

; imported symbols

; constants
MAX_COL equ 80
VIDEO equ 0xB8000

; variables
offset          dw 0x0000
color           dw 0x0F

; void vga_text_init2()
vga_text_init2:
        ; read the higher cursor-byte
        mov al, 0x0E
        mov dx, 0x03D4
        out dx, al

        mov dx, 0x03D5
        in al, dx
        mov ah, al

        ; read the lower cursor-byte
        mov al, 0x0F
        mov dx, 0x03D4
        out dx, al

        mov dx, 0x03D5
        in al, dx

        mov [offset], ax

        ret

; static void _update_cursor()
_update_cursor:
        mov bx, [offset]

        ; the higher byte
        mov al, 0x0E
        mov dx, 0x03D4
        out dx, al

        mov al, bh
        mov dx, 0x03D5
        out dx, al

        ; the lower byte
        mov al, 0x0F
        mov dx, 0x03D4
        out dx, al

        mov al, bl
        mov dx, 0x03D5
        out dx, al

        ret

; void vga_text_next_line2()
vga_text_next_line2:
        mov ax, [offset]
        mov bx, MAX_COL
        div bl

        movzx ax, al
        inc ax
        mul bx

        mov [offset], ax
        call _update_cursor

        ret

; void vga_text_putc2(char ch)
vga_text_putc2:
        movzx eax, word [offset]
        shl ax, 1

        add eax, VIDEO

        mov bh, [color]
        mov bl, [esp + 4]

        mov [eax], bx

        inc word [offset]
        call _update_cursor

        ret

