; BIOS loads the bootloader into this memory address
BOOTLOADER_START equ 0x07c0
BOOTLOADER_SIZE equ 0x0200
BOOTLOADER_MAGIC_BYTES_SIZE equ 0x02
BOOTLOADER_MAGIC_BYTES equ 0xaa55
; TODO: Explain where these come from
KERNEL_SECTOR equ 0x0900
KERNEL_START equ 0x0000

; Interrupt code for performing video actions
; ah: The action to perform
INT_VIDEO equ 0x10
; Video action to move the cursor
; dl: The target position in the line
INT_VIDEO_MOVE_CURSOR equ 0x02
; Video action to read the current cursor position
; bh: TODO: what is this?
INT_VIDEO_READ_CURSOR equ 0x03
; Video action to print a character
; al: The character to print
INT_VIDEO_PRINT_CHAR equ 0x0e

; Interrupt code for performing HDD actions
; ah: The action to perform
INT_HDD equ 0x13
; HDD action to read data from the disk into memory
; al: The number of sectors to read
; ch: The track to read
; cl: The sector to start reading
; dh: The head to read
; dl: The disk type
; bx: The starting memory location for storing the data
INT_HDD_READ equ 0x02

HARD_DISK_0 equ 0x80

CHAR_TERMINATOR equ 0x00
CHAR_NEWLINE equ 0x0a

START_OF_LINE equ 0x00

start:
	; TODO: Explain these two lines
	mov ax, BOOTLOADER_START
	mov ds, ax

	mov si, title_string
	call print_string

	mov si, message_string
	call print_string

	call load_kernel_from_disk
	jmp KERNEL_SECTOR:KERNEL_START

; Prints a string
; si: The start address of the string to print
print_string:
	mov ah, INT_VIDEO_PRINT_CHAR

	print_next_char:
		lodsb
		cmp al, CHAR_TERMINATOR
		je printing_finished
		int INT_VIDEO
		jmp print_next_char

	printing_finished:
		mov al, CHAR_NEWLINE
		int INT_VIDEO

		mov ah, INT_VIDEO_READ_CURSOR
		mov bh, 0
		int INT_VIDEO

		mov ah, INT_VIDEO_MOVE_CURSOR
		mov dl, START_OF_LINE
		int INT_VIDEO

		ret

load_kernel_from_disk:
	N_SECTORS equ 0x01
	TRACK equ 0x00
	HEAD equ 0x00
	SECTOR equ 0x02 ; Right after the bootloader
	DISK_TYPE equ HARD_DISK_0
	MEMORY_TARGET equ 0x00

	; TODO: Explain these two lines
	mov ax, KERNEL_SECTOR
	mov es, ax

	mov ah, INT_HDD_READ
	mov al, N_SECTORS
	mov ch, TRACK
	mov cl, SECTOR
	mov dh, HEAD
	mov dl, DISK_TYPE
	mov bx, MEMORY_TARGET
	int INT_HDD

	jc kernel_load_error
	ret

kernel_load_error:
	mov si, load_error_string
	call print_string
	jmp $ ; Infinite loop

title_string db "Welcome to the bootloader", CHAR_TERMINATOR
message_string db "Loading kernel...", CHAR_TERMINATOR
load_error_string db "Failed to load kernel", CHAR_TERMINATOR

times (BOOTLOADER_SIZE-BOOTLOADER_MAGIC_BYTES_SIZE)-($-$$) db 0 ; Pad with null data
dw BOOTLOADER_MAGIC_BYTES
