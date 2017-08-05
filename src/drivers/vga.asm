; other symbols
extern memcpy

; sub-files
%include "drivers/vga/put.asm"
%include "drivers/vga/helper.asm"
%include "drivers/vga/print.asm"

; constants
MAX_COL		equ 80
MAX_ROW		equ 25
TAB_SIZE	equ 8
VIDEO		equ 0xB8000

; variables
offset		dw 0x0000
color		db 0x0F

; void vga_init()
vga_init:
	push eax
	push edx

	; change the cursor-shape
	mov dx, 0x03D4
	mov al, 0x0A
	out dx, al

	; disable the cursor
	inc dx
	mov al, 0x3F
	out dx, al

	pop edx
	pop eax
	ret

; void vga_clear()
vga_clear:
	push eax
	push ecx

	mov ecx, (MAX_ROW - 1) * MAX_COL * 2

.loop1:

	mov eax, VIDEO
	mov eax, ecx

	mov word [eax], 0
	loop .loop1

	mov word [offset], 0

	pop ecx
	pop eax
	ret

; void vga_color(u8 color)
vga_color:
	push eax

	mov al, [esp + 5]
	mov [color], al

	pop eax
	ret 2

; void vga_cursor(u8 x, u8 y)
vga_cursor:
	push eax
	push ebx

	mov al, [esp + 11]
	mov bl, MAX_COL
	mul bl

	add ax, [esp + 14]
	mov [offset], ax

	pop ebx
	pop eax
	ret 4
