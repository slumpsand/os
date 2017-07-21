gdt_start:
    dd 0             ; the GDT starts with a null-byte
    dd 0

gdt_code:
    dw 0xFFFF         ; segment length (bits 0-15)

    dw 0             ; segment base (bits 0-15)
    db 0             ; segment base (bits 16-23)

    db 10011010b     ; flags (bits 0-7)

    db 11001111b     ; flags (bits 8-11)
                     ; segment length (bits 16-19)

    db 0             ; segment base (bits 24-31)

gdt_data:            ; exactly the same as above, a few bits changed
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1       ; size (16 bit), has to be an index
    dd gdt_start                     ; address of the gdt

CODE_SEG equ gdt_code - gdt_start    ; the relative addresses will come in handy later
DATA_SEG equ gdt_data - gdt_start    
