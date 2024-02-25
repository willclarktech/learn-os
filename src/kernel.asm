; Interrupt code for performing video actions
; ah: The action to perform
INT_VIDEO equ 0x10
; Video action to print a character
; al: The character to print
INT_VIDEO_PRINT_CHAR equ 0x0e

CHAR_TERMINATOR equ 0x00

start:
	; Set the data segment to the start of the kernel
	; This way we can easily reference data defined in this file
	mov ax, cs
	mov ds, ax

	mov si, hello_string
	call print_string

	jmp $ ; Infinite loop

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
		ret

hello_string db "Hello from the kernel!", CHAR_TERMINATOR
