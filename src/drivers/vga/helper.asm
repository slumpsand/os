; static void _vga_clear_last_row()
_vga_clear_last_row:
	push eax
	push ecx

	mov ecx, MAX_COL
	mov eax, VIDEO + ((MAX_ROW - 1) * MAX_COL * 2) >> 1

.loop1:
	; move 4 bytes (2 characters) at a time
	mov dword [eax], 0

	add eax, 4
	loop .loop1

	pop ecx
	pop eax
	ret

; static void _vga_scroll()
_vga_scroll:
	push eax
	push ebx
	push ecx

	mov eax, VIDEO
	mov ebx, VIDEO + MAX_COL * 2

.loop1:
	mov ecx, [ebx]
	mov [eax], ecx

	add eax, 4
	add ebx, 4

	cmp ebx, VIDEO + MAX_ROW * MAX_COL * 2
	jl .loop1

	pop ecx
	pop ebx
	pop eax
	ret
