global vga_text_move_cursor
global vga_text_init
global vga_text_update
global vga_text_clear
global vga_text_next_line

; funcitons
extern vga_text_get_offset
extern outb
extern putc

; variables
extern vga_text_cursor_col
extern vga_text_cursor_row
extern vga_text_cursor_color
extern vga_text_buffer
extern memcpy

; constants
VGA_TEXT_MAX_COL equ 80
VGA_TEXT_MAX_ROW equ 25

VGA_TEXT_WHITE_ON_BLACK equ 0x0F00

VGA_CURSOR_LOW equ 0x0F
VGA_CURSOR_HIGH equ 0x0E

REG_SCREEN_CTRL equ 0x03D4
REG_SCREEN_DATA equ 0x03D5

VIDEO_MEMORY equ 0xB8000

; void vga_text_move_cursor()
vga_text_move_cursor:
        inc byte [vga_text_cursor_col]
        cmp byte [vga_text_cursor_col], VGA_TEXT_MAX_COL
        jl .end

        call vga_text_next_line

.end:
        call vga_text_update
        ret

; void vga_text_init()
vga_text_init:
        mov dword [vga_text_buffer], 0xB8000
        mov word [vga_text_cursor_color], VGA_TEXT_WHITE_ON_BLACK

        call vga_text_clear
        ret

; void vga_text_update()
vga_text_update:
        call vga_text_get_offset

        push ax
        shr ax, 8

        mov byte [REG_SCREEN_CTRL], VGA_CURSOR_HIGH
        mov byte [REG_SCREEN_DATA], al

        pop ax
        and ax, 0x00FF

        mov byte [REG_SCREEN_CTRL], VGA_CURSOR_LOW
        mov byte [REG_SCREEN_DATA], al

        ret

; void vga_text_clear()
vga_text_clear:
        mov edx, VGA_TEXT_MAX_ROW

.loop1:
        mov ecx, VGA_TEXT_MAX_COL

        mov eax, VGA_TEXT_MAX_COL
        mul edx

.loop2:
        push eax
        add eax, ecx
        add eax, VIDEO_MEMORY

        mov word [eax], 0

        pop eax

        dec ecx
        jnc .loop2

        dec edx
        jnc .loop1

        mov byte [vga_text_cursor_col], 0
        mov byte [vga_text_cursor_row], 0

        call vga_text_update
        ret

; void vga_text_next_line()
vga_text_next_line:
        ; set the cursor to the next line
        mov byte [vga_text_cursor_col], 0
        inc byte [vga_text_cursor_row]

        ; check if it's required to scroll the screen
        cmp byte [vga_text_cursor_row], VGA_TEXT_MAX_ROW
        jl .end

        call .scroll_up
        call .clear_last_row
.end:
        call vga_text_update

        ret

; void _scroll_up()
.scroll_up:
        mov ecx, VIDEO_MEMORY
.scroll_loop:
        mov eax, ecx
        add ecx, VGA_TEXT_MAX_COL * 2

        push dword VGA_TEXT_MAX_COL * 2
        push eax
        push ecx
        call memcpy

        pop ecx
        add esp, 8

        cmp ecx, VIDEO_MEMORY + (VGA_TEXT_MAX_ROW - 1) * VGA_TEXT_MAX_COL * 2
        jl .scroll_loop

        dec byte [vga_text_cursor_row]

        ret

; void _clear_last_row()
.clear_last_row:
        mov ecx, VGA_TEXT_MAX_COL
.clear_loop:
        mov eax, ecx
        add eax, VIDEO_MEMORY + (VGA_TEXT_MAX_ROW - 1) * VGA_TEXT_MAX_COL * 2

        mov word [eax], 0
        loop .clear_loop
        ret
