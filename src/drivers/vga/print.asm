; void vga_simple_print(const char* str)
vga_simple_print:
	push eax
	push ebx

	mov eax, [esp + 12]

.loop1:
	cmp byte [eax], 0
	je .end

	movzx bx, byte [eax]
	push bx
	call vga_putc

	inc eax
	jmp .loop1

.end:
	pop eax
	pop ebx
	ret 4

; void vga_print(const char* str)
vga_print:
	push eax

	mov eax, [esp + 4]
	jmp .step1

.loop1:
	inc eax

.step1: ; check end
	cmp byte [eax], 0
	jne .step2

	pop eax
	ret 4

.step2:	; check newline
	cmp byte [eax], 10
	jne .step3

	call vga_putnl
	jmp .loop1

.step3: ; check tab
	cmp byte [eax], 9
	jne .step4

	call vga_putt
	jmp .loop1

.step4: ; general characters
	movzx ax, byte [eax]
	push ax
	call vga_putc

	jmp .loop1
