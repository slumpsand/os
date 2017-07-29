; function symbols
global vga_text_move_cursor
global vga_text_init
global vga_text_update
global vga_text_clear
global vga_text_next_line
global vga_text_get_offset

; varaible symbols
global vga_text_cursor_col
global vga_text_cursor_row
global vga_text_cursor_color
global vga_text_buffer

; extern symbols
extern memcpy

; constants
MAX_COL equ 80
MAX_ROW equ 25

VIDEO equ 0xB8000

W_ON_B equ 0x0F00

; variables
vga_text_cursor_col dw 0
vga_text_cursor_row dw 0
vga_text_cursor_color dw W_ON_B
vga_text_buffer dd VIDEO

; void vga_text_move_cursor()
vga_text_move_cursor:
        inc word [vga_text_cursor_col]
        cmp word [vga_text_cursor_col], MAX_COL
        jl .end

        call vga_text_next_line

.end:
        call vga_text_update
        ret

; void vga_text_update()
vga_text_update:
        call vga_text_get_offset

        push ax
        shr ax, 8

        mov byte [0x3D4], 0x0E
        mov byte [0x3D5], al

        pop ax
        and ax, 0x00FF

        mov byte [0x03D4], 0x0F
        mov byte [0x03D5], al

        ret

; void vga_text_clear()
vga_text_clear:
        mov edx, MAX_ROW

.loop1:
        mov ecx, MAX_COL

        mov eax, MAX_COL
        mul edx

.loop2:
        push eax
        add eax, ecx
        add eax, VIDEO

        mov word [eax], 0

        pop eax

        dec ecx
        jnc .loop2

        dec edx
        jnc .loop1

        mov word [vga_text_cursor_col], 0
        mov word [vga_text_cursor_row], 0

        call vga_text_update
        ret

; void vga_text_next_line()
vga_text_next_line:
        ; set the cursor to the next line
        mov word [vga_text_cursor_col], 0
        inc word [vga_text_cursor_row]

        ; check if it's required to scroll the screen
        cmp word [vga_text_cursor_row], MAX_ROW
        jl .end

        call .scroll_up
        call .clear_last_row
.end:
        call vga_text_update

        ret

; void _scroll_up()
.scroll_up:
        mov ecx, VIDEO
.scroll_loop:
        mov eax, ecx
        add ecx, MAX_COL * 2

        push dword MAX_COL * 2
        push eax
        push ecx
        call memcpy

        pop ecx
        add esp, 8

        cmp ecx, VIDEO + (MAX_ROW - 1) * MAX_COL * 2
        jl .scroll_loop

        dec word [vga_text_cursor_row]

        ret

; void _clear_last_row()
.clear_last_row:
        mov ecx, MAX_COL
.clear_loop:
        mov eax, ecx
        add eax, VIDEO + (MAX_ROW - 1) * MAX_COL * 2

        mov word [eax], 0
        loop .clear_loop
        ret

; u16 vga_text_get_offset()
vga_text_get_offset:
        mov ax, [vga_text_cursor_row]
        mov bx, MAX_COL
        mul bx

        add ax, [vga_text_cursor_col]
        ret
