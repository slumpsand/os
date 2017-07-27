[bits 16]

CODE_SEG equ descriptor.code - descriptor
DATA_SEG equ descriptor.data - descriptor
STACK_SEG equ descriptor.stack - descriptor

GDT_ACCESS:
.PRESENT equ 1 << 7 | 1 << 4

.KERNEL_PRIVILEGE equ 0b00 << 5
.RING1_PRIVILEGE  equ 0b01 << 5
.RING2_PRIVILEGE  equ 0b10 << 5
.USER_PRIVILEGE   equ 0b11 << 5

.CODE_SECTOR equ 1 << 3
.DATA_SECTOR equ 0 << 3

.DC_ALLOW  equ 1 << 2
.DC_FORBID equ 0 << 2

.RW_ALLOW equ 1 << 1
.RW_FORBIT euq 0 << 1

GDT_FLAGS:
.GR_BYTES equ 0 << 7
.GR_BLOCKS equ 1 << 7

.SIZE_16 equ 0 << 6
.SIZE_32 equ 1 << 6

enter_protected:
        cli                             ; better not have interrupts on

        lgdt [descriptor.desc]          ; load the GDT

        mov eax, cr0
        or eax, 1                       ; set the '32-bit'-flag
        mov cr0, eax

        jmp CODE_SEG:ENTER              ; do a long-jump into the code-segment

descriptor:
        dq 0

.code:
        dw 0x0000                       ; limit (0-15 bit)
        dw 0x1000                       ; base (0-15 bit)
        db 0x00                         ; base (16-19 bit)
        db GDT_ACCESS.PRESENT | GDT_ACCESS.KERNEL_PRIVILEGE | GDT_ACCESS.CODE_SECTOR | GDT_ACCESS.DC_ALLOW | GDT_ACCESS.RW_ALLOW ; access (bit 0-7)
        db 0x0A | GDT_FLAGS.GR_BYTES | GDT_FLAGS.SIZE_32 ; limit (16-19), flags (8-11)

.stack:
        dw 0x0000
        dw 0x0000
        db 0x0A
        db GDT_ACCESS.PRESENT | GDT_ACCESS.KERNEL_PRIVILEGE | GTD_ACCESS_DATA_SECTOR | GTD_ACCESS_DC_ALLOW | GDT_ACCESS.RW_ALLOW
        db 0x0F | GDT_FLAGS.GR_BYTES | GDT_FLAGS.SIZE_32

.data:
        dw 0xFFFF                       ; limit (0-15 bit)
        dw 0x0000                       ; base (0-15 bit)
        db 0x0F                         ; base (16-19 bit)
        db GDT_ACCESS.PRESENT | GDT_ACCESS.KERNEL_PRIVILEGE | GDT_ACCESS.DATA_SECTOR | GDT_ACCESS.DC_ALLOW | GDT_ACCESS.RW_ALLOW ; access (bit 0-7)
        db 0x0F | GDT_FLAGS.GR_BYTES | GDT_FLAGS.SIZE_32 ; limit (16-19), flags (8-11)

.desc:                                  ; TODO: is this required?
        dw .desc - descriptor - 1
        dd descriptor

[bits 32]
ENTER:
        mov ax, DATA_SEG                                 ; set all the segments correctly
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

        mov ax, CODE_SEG
        mov cs, ax

        mov ax, STACK_SEG
        mov ss, ax

        mov ebp, 0x0F0000 - 0x0A0000                    ; move the stack to the end of the stack segment
        mov esp, ebp

        call TEXT_OFFSET                                ; call the asm-file that calls the main function
        jmp $
