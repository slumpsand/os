global memcpy
global memcpy_asm

; void memcpy(const u8* src, u8* dest, u32 n)
memcpy:
	mov eax, [esp + 4]
	mov ebx, [esp + 8]
	mov ecx, [esp + 12]
.loop1:
	mov dl, [eax]
	mov [ebx], dl

	inc eax
	inc ebx

	loop .loop1

	ret
