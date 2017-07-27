global outb
global outw
global inb
global inw

; void outb(u16 port, u8 data)
outb:
        mov ebx, [esp + 4]
        mov ecx, [esp + 8]

        mov byte [ebx], cl

        ret

; void outw(u16 port, u16 data)
outw:
        mov ebx, [esp + 4]
        mov ecx, [esp + 8]

        mov word [ebx], cx

        ret

; u8 inb(u16 port)
inb:
        mov ebx, [esp + 4]
        mov al, [ebx]

        ret

; u16 inw(u16 port)
inw:
        mov ebx, [esp + 4]
        mov ax, [ebx]

        ret
