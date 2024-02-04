[bits 32]

pm_init:
	; Set up segments for protected mode
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp 0x600 ; Jump to the kernel
	jmp pm_hang

pm_hang:
	jmp pm_hang
