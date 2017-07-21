[bits 16]
switch_pm:
    cli                         ; clear interrupts
    lgdt [gdt_descriptor]       ; load the gdt

    mov eax, cr0                ; enter the 32 bit mode
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm        ; far jump

[bits 32]
init_pm:
    mov ax, DATA_SEG            ; point all the segment-registers
    mov ds, ax                  ; at the data segment
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 90000h             ; move the stack at some free space
    mov esp, ebp

    call start
