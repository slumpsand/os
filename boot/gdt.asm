[bits 16]

gdt_start:
        dq 0

gdt_code:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        db 0b11001111
        db 0

gdt_data:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0

gdt_descriptor:
        dw gdt_descriptor - gdt_start - 1
        dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
