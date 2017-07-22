[bits 16]

; switch into the 32-bit protected mode.
switch_pm:
    cli                                         ; clear the interrupts

    lgdt [.desc]                                ; load the gdt

    mov eax, cr0                                ; set the 32-bit flag
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm                        ; jump into 32 bit instructions

.gdt:                                           ; 8 null bytes at the beginning
    dd 0
    dd 0

.code:                                          ; the code segment
    dw 0xFFFF

    dw 0
    db 0

    db 10011010b
    db 11001111b

    db 0

.data:                                          ; the data segment
    dw 0xFFFF

    dw 0
    db 0

    db 10010010b
    db 11001111b

    db 0

.desc:                                          ; the descriptor
    dw .desc - .gdt - 1
    dd .gdt

CODE_SEG equ switch_pm.code - switch_pm.gdt     ; these offsets will be usefull later
DATA_SEG equ switch_pm.data - switch_pm.gdt

[bits 32]
init_pm:
    mov ax, DATA_SEG                            ; paint the segement registers to 
    mov ds, ax                                  ; the data segment
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 90000h                             ; move the stack far away
    mov esp, ebp

    call ENTER                                  ; ready to start ...
