global outb
global outw
global inb
global inw

; void outb(u16 port, u8 data)
outb:
        mov dx, [esp + 4]
        mov al, [esp + 8]
        out dx, al

        ret

; void outw(u16 port, u16 data)
outw:
        mov dx, [esp + 4]
        mov ax, [esp + 8]
        out dx, ax

        ret

; u8 inb(u16 port)
inb:
        mov dx, [esp + 4]
        in al, dx

        ret

; u16 inw(u16 port)
inw:
        mov dx, [esp + 4]
        in ax, dx

        ret
