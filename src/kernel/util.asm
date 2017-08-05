; void memcpy(const u8* src, u8* dest, u32 n)
memcpy:
	pusha

	mov eax, [ebp + 20]
	mov ebx, [ebp + 24]
	mov ecx, [ebp + 28]

.loop1:
	mov dl, [eax]
	mov [ebx], dl

	inc eax
	inc ebx

	loop .loop1

	popa
	ret
