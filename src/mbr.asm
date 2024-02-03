[org 0x7c00] ; The BIOS loads the MBR to this address
[bits 16] ; The CPU starts in 16-bit real mode

; Infinite loop (hang the system if no bootable partition is found)
hang:
	jmp hang

; Boot signature
times 510-($-$$) db 0 ; Pad boot sector with 0s
dw 0xAA55 ; Conventional boot signature indicating the MBR is valid
