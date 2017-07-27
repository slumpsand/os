global vga_text_move_cursor
global vga_text_init
global vga_text_update

; funcitons
[extern vga_text_next_line]
[extern vga_text_clear]
[extern vga_text_get_offset]
[extern outb]
[extern putc]

; variables
[extern vga_text_cursor_col]
[extern vga_text_cursor_color]
[extern vga_text_buffer]

; constants
VGA_TEXT_MAX_COL equ 80

VGA_TEXT_WHITE_ON_BLACK equ 0x0F00

VGA_CURSOR_LOW equ 0x0F
VGA_CURSOR_HIGH equ 0x0E

REG_SCREEN_CTRL equ 0x03D4
REG_SCREEN_DATA equ 0x03D5

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
vga_text_update:                        ; TODO: this doesn't work!
        call vga_text_get_offset
        mov bx, ax

        shr ax, 8
        and bx, 0x00FF

        push VGA_CURSOR_HIGH
        push REG_SCREEN_CTRL
        call outb

        push ax
        push REG_SCREEN_DATA
        call outb

        push VGA_CURSOR_LOW
        push REG_SCREEN_CTRL

        push bx
        push REG_SCREEN_DATA
        call outb

        ret
