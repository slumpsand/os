[bits 16]
switch_pm:
        mov bx, MSG_SWITCH
        call println

        cli
        lgdt [gdt_descriptor]

        mov eax, cr0
        or eax, 1
        mov cr0, eax

        jmp CODE_SEG:init_pm

MSG_SWITCH db "Switching into 32-bit mode", 0

[bits 32]
init_pm:
        mov ax, DATA_SEG
        mov ds, ax
        mov ss, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

        mov ebp, 0x90000
        mov esp, ebp

        call BEGIN
