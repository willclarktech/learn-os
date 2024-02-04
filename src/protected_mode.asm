[bits 32]

pm_init:
	; Set up segments for protected mode
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov esp, PM_STACK_BASE
	mov ebp, esp

	mov ebx, str_initialized_protected_mode
	mov ecx, 2 * 21 * 80
	call pm_print

	jmp KERNEL_LOAD_ADDRESS

pm_hang:
	jmp pm_hang

pm_print:
	pusha
	mov edx, VIDEO_MEMORY
	add edx, ecx
pm_print_loop:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK
	cmp al, 0
	je pm_print_done
	mov [edx], ax
	add ebx, 1
	add edx, 2
	jmp pm_print_loop
pm_print_done:
	popa
	ret

; Constants
PM_STACK_BASE equ 0x90000 ; Stack begins at the top of the free space
KERNEL_LOAD_ADDRESS equ 0x600
VIDEO_MEMORY equ 0xB8000 ; VGA text mode memory address
WHITE_ON_BLACK equ 0x0F ; Attribute byte: white text on black background

; Strings
str_initialized_protected_mode db "Initialized protected mode", 0
