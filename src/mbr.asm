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

	call load_kernel

	mov si, loaded
	call print_string

	jmp 0x600 ; Jump to the kernel
	jmp hang

load_kernel:
	mov si, dap
	mov ah, 0x42 ; Function number for extended read
	mov dl, 0x80 ; Drive number for the HDD
	int 0x13
	jc hang
	ret

print_string:
	lodsb
	or al, al
	jz print_string_ret
	mov ah, 0x0E
	int 0x10 ; Print the character
	jmp print_string
print_string_ret:
	ret

hello db "Hello from the MBR!", 0x0D, 0x0A, 0
loaded db "Loaded kernel into RAM"

dap:
	db 0x10 ; Size of the DAP (16 bytes)
	db 0 ; Unused
	dw 1 ; Number of sectors to read
	dw 0x600 ; Offset of buffer in memory (destination)
	dw 0 ; Segment of buffer in memory
	dq 1 ; LBA of the first sector to read (the sector immediately after MBR)

; Infinite loop (hang the system if no bootable partition is found)
hang:
	jmp hang

; Boot signature
times 510-($-$$) db 0 ; Pad boot sector with 0s
dw 0xAA55 ; Conventional boot signature indicating the MBR is valid
