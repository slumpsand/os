global outb
global outw
global inb
global inw

; void outb(u16 port, u8 data)
outb:
        mov bx, [esp + 2]
        mov cl, [esp + 5]
        mov byte [bx], cl

        ret

; void outw(u16 port, u16 data)
outw:
        mov bx, [esp + 2]
        mov cx, [esp + 6]
        mov word [bx], cx

        ret

; u8 inb(u16 port)
inb:
        mov bx, [esp + 2]
        mov al, [bx]

        ret

; u16 inw(u16 port)
inw:
        mov bx, [esp + 2]
        mov ax, [bx]

        ret
