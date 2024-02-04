[bits 16] ; The CPU starts in 16-bit real mode

rm_init:
	cli ; Disable interrupts
	cld ; Clear direction flag

	; Set up segments for real mode
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	; Set stack pointer to the bottom of the segment
	mov sp, ax

	mov si, str_hello
	call rm_print

	call rm_load_kernel
	mov si, str_loaded_kernel
	call rm_print

	lgdt [gdt_descriptor] ; gdt_descriptor from gtd.asm
	mov si, str_loaded_gdt
	call rm_print

	jmp rm_switch_to_pm

; Infinite loop (hang the system if no bootable partition is found)
rm_hang:
	jmp rm_hang

rm_print:
	lodsb
	or al, al
	jz rm_print_ret
	mov ah, 0x0E
	int 0x10 ; Print the character
	jmp rm_print
rm_print_ret:
	ret

rm_load_kernel:
	mov si, dap ; dap from dap.asm
	mov ah, 0x42 ; Function number for extended read
	mov dl, 0x80 ; Drive number for the HDD
	int 0x13
	jc rm_hang
	ret

rm_switch_to_pm:
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp pm_init ; pm_init from protected_mode.asm

; Strings
str_hello db "Hello from the MBR!", 0x0D, 0x0A, 0
str_loaded_kernel db "Loaded kernel into RAM", 0x0D, 0x0A, 0
str_loaded_gdt db "Loaded GDT", 0x0D, 0x0A, 0
str_initialized_protected_mode db "Initialized protected mode", 0x0D, 0x0A, 0
