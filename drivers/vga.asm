; exported symbols
global vga_text_init
global vga_text_putc
global vga_text_next_line
global vga_text_set_color
global vga_text_set_cursor
global vga_text_clear
global vga_text_print_simple
global vga_text_print
global vga_text_put_tab

; imported symbols
extern memcpy

; constants
MAX_COL         equ 80
MAX_ROW         equ 25
TAB_SIZE        equ 8
VIDEO           equ 0xB8000

; variables
offset          resb 2
row             resb 1
col             resb 1
color           resb 1

; void vga_text_init()
vga_text_init:
        mov byte [color],  0x0F

        call vga_text_clear
        call vga_text_disable_cursor

        ret

; void vga_text_disable_cursor()
vga_text_disable_cursor:
        mov dx, 0x03D4
        mov al, 0x0A
        out dx, al

        inc dx
        mov al, 0x3F
        out dx, al

        ret 

; static void _scroll()
_scroll:
        mov eax, VIDEO
        mov ebx, VIDEO + MAX_COL * 2

.loop1:
        mov cx, [ebx]
        mov [eax], cx

        add eax, 2
        add ebx, 2
        cmp ebx, VIDEO + (MAX_ROW) * MAX_COL * 2
        jl .loop1

        ret


; static void _clear_last_row()
_clear_last_row:
        mov ecx, MAX_COL
        mov eax, VIDEO + (MAX_ROW - 1) * MAX_COL * 2

.loop1:
        mov word [eax], 0

        add eax, 2
        loop .loop1

        ret

; static void _move_cursor()
_move_cursor:
        ; calculate the new row / column
        mov ax, [offset]
        mov bl, MAX_COL
        div bl

        mov [row], al
        mov [col], ah

        ; check if scrolling is required
        cmp al, MAX_ROW
        jge .scroll
        ret

.scroll:
        call _scroll
        call _clear_last_row

        mov word [offset], (MAX_ROW - 1) * MAX_COL
        mov byte [row], 24
        mov byte [col], 0

        ret


; void vga_text_next_line()
vga_text_next_line:
        ; change into the next row
        mov al, [row]
        mov ah, MAX_COL
        inc al
        mul ah
        mov [offset], ax

        ; move the cursor
        jmp _move_cursor

; void vga_text_putc(char ch)
vga_text_putc:
        movzx eax, word [offset]
        shl ax, 1

        add eax, VIDEO

        mov bh, [color]
        mov bl, [esp + 4]

        mov [eax], bx
        inc word [offset]

        ret

; void vga_text_set_color(u8 color)
vga_text_set_color:
        mov al, [esp + 4]
        mov [color], al
        ret

; void vga_text_set_cursor(u8 x, u8 y)
vga_text_set_cursor:
        mov al, byte [esp + 8]
        mov [row], al

        mov bl, byte [esp + 4]
        mov [col], al

        call _move_cursor

        ret

; void vga_text_clear()
vga_text_clear:
        mov ecx, (MAX_ROW - 1) * MAX_COL * 2

.loop1:
        mov eax, VIDEO
        add eax, ecx

        mov word [eax], 0
        loop .loop1

        mov word [offset], 0
        call _move_cursor

        ret

; void vga_text_print_simple(const char* str)
vga_text_print_simple:
        mov eax, [esp + 4]

        cmp byte [eax], 0
        jnz .loop1

        ret

.loop1:
        push eax
        movzx bx, byte [eax]

        push bx
        call vga_text_putc
        add esp, 2

        pop eax
        inc eax

        cmp byte [eax], 0
        jnz .loop1

        call _move_cursor
        ret        

; void vga_text_print(const char* str)
vga_text_print:
        mov eax, [esp + 4]

.loop1:
        push eax

        cmp byte [eax], 10
        je .newline

        cmp byte [eax], 9
        je .tab

        movzx ax, byte [eax]
        push ax
        call vga_text_putc
        add esp, 2

.next:
        pop eax
        inc eax

        cmp byte [eax], 0
        jne .loop1

        call _move_cursor
        ret

.tab:
        call vga_text_put_tab
        jmp .next

.newline:
        push .next
        jmp vga_text_next_line

; void vga_text_put_tab()
vga_text_put_tab:
        mov bx, MAX_COL << 8 | TAB_SIZE

        ; get the column / row
        mov ax, [offset]
        div bh

        ; save the row and put the column into ax
        push ax
        movzx ax, ah

        ; calculate the tab
        div bl
        inc al
        mul bl
        mov cx, ax

        ; get the offset
        pop ax
        mul bh
        add ax, cx
        
        ; update the cursor
        mov [offset], ax
        call _move_cursor

        ret
