[org 0x7c00] ; The BIOS loads the MBR to this address
[bits 16] ; The CPU starts in 16-bit real mode

start:
	cli ; Disable interrupts
	cld ; Clear direction flag

	xor ax, ax ; Set up segments
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov sp, ax ; Set stack pointer to the top of the segment

	mov si, hello
	call print_string
	call hang

print_string:
	lodsb
	or al, al
	jz print_string_ret
	mov ah, 0x0E
	int 0x10 ; Print the character
	jmp print_string
print_string_ret:
	ret

; Infinite loop (hang the system if no bootable partition is found)
hang:
	jmp hang

hello db "Hello from the MBR!", 0x0D, 0x0A, 0

; Boot signature
times 510-($-$$) db 0 ; Pad boot sector with 0s
dw 0xAA55 ; Conventional boot signature indicating the MBR is valid
