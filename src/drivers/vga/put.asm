; void vga_putc(char ch)
vga_putc:
	push eax
	push ebx

	movzx eax, word [offset]
	shl eax, 1

	add eax, VIDEO

	mov bh, [color]
	mov bl, [esp + 9]

	mov [eax], bx
	inc word [offset]

	pop ebx
	pop eax
	ret 2

; void vga_putt()
vga_putt:
	push eax
	push ebx
	push ecx

	mov bx, MAX_COL << 8 | TAB_SIZE

	; obtain row / column
	mov ax, [offset]
	div bh

	; save the row for later and put the column in ax
	push ax
	movzx ax, ah

	; new column
	div bl
	inc al
	mul bl
	mov cx, ax

	; restore the row
	pop ax
	mul bh
	add ax, cx

	; change the cursor
	mov [offset], ax

	pop ecx
	pop ebx
	pop eax
	ret

; void vga_putnl()
vga_putnl:
	push eax
	push ebx

	; get the current row
	mov ax, [offset]
	mov bl, MAX_COL
	div bl

	inc al
	cmp al, MAX_ROW
	jbe .scroll

	; set the new row
	mul bl
	mov [offset], ax

	pop ebx
	pop eax
	ret

.scroll:
	call _scroll
	call _clear_last_row

	mov word [offset], (MAX_ROW - 1) * MAX_COL

	pop ebx
	pop eax
	ret
