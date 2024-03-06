SECTOR_SIZE equ 0x0200

; BIOS loads the bootloader into this memory address
BOOTLOADER_START equ 0x07c0
BOOTLOADER_SIZE equ SECTOR_SIZE
BOOTLOADER_MAGIC_BYTES_SIZE equ 0x02
BOOTLOADER_MAGIC_BYTES equ 0xaa55

KERNEL_SECTOR equ 0x02 ; Right after the boot loader
; TODO: Explain where these come from
KERNEL_SEGMENT equ 0x0900
KERNEL_START equ 0x0000

; Interrupt code for performing video actions
; ah: The action to perform
INT_VIDEO equ 0x10
; Video action to move the cursor
; dl: The target column
INT_VIDEO_MOVE_CURSOR equ 0x02
; Video action to read the current cursor position
; bh: Page number (0 for default)
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
; es: The data segment for storing the data
; bx: The starting memory offset for storing the data
INT_HDD_READ equ 0x02

HARD_DISK_0 equ 0x80

CHAR_TERMINATOR equ 0x00
CHAR_NEWLINE equ 0x0a

DEFAULT_PAGE_NUMBER equ 0x00

START_OF_LINE equ 0x00

start:
	; Set the data segment to the start of the bootloader
	; This way we can easily reference data defined in this file
	mov ax, BOOTLOADER_START
	mov ds, ax

	mov si, title_string
	call print_string

	mov si, message_string
	call print_string

	call load_kernel_from_disk
	jmp KERNEL_SEGMENT:KERNEL_START

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
		mov bh, DEFAULT_PAGE_NUMBER
		int INT_VIDEO

		mov ah, INT_VIDEO_MOVE_CURSOR
		mov dl, START_OF_LINE
		int INT_VIDEO

		ret

load_kernel_from_disk:
	N_SECTORS equ 0x01
	TRACK equ 0x00
	HEAD equ 0x00

	mov ax, KERNEL_SEGMENT
	mov es, ax

	mov ax, [current_sector_to_load]
	sub ax, KERNEL_SECTOR ; Remove the sector offset from the RAM target
	mov bx, SECTOR_SIZE
	mul bx ; Multiply ax by bx
	mov bx, ax

	mov ah, INT_HDD_READ
	mov al, N_SECTORS
	mov ch, TRACK
	mov cl, [current_sector_to_load]
	mov dh, HEAD
	mov dl, HARD_DISK_0
	int INT_HDD

	jc kernel_load_error

	; TODO: Can we replace this loop by just setting N_SECTORS?
	; TODO: Can we remove the `byte`s here?
	inc byte [current_sector_to_load]
	dec byte [num_sectors_to_load]
	jnz load_kernel_from_disk

	ret

kernel_load_error:
	mov si, load_error_string
	call print_string
	jmp $ ; Infinite loop

title_string db "Welcome to the bootloader", CHAR_TERMINATOR
message_string db "Loading kernel...", CHAR_TERMINATOR
load_error_string db "Failed to load kernel", CHAR_TERMINATOR

current_sector_to_load db KERNEL_SECTOR
num_sectors_to_load db 0x0f

; Pad with null data
times (BOOTLOADER_SIZE-BOOTLOADER_MAGIC_BYTES_SIZE)-($-$$) db 0
dw BOOTLOADER_MAGIC_BYTES
