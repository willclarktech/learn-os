gdt_start:
	; Mandatory null descriptor
	dd 0x0
	dd 0x0

gdt_code: ; Code segment descriptor
	dw 0xFFFF ; Limit (bits 0-15)
	dw 0x0 ; Segment base (bits 0-15)
	db 0x0 ; Segment base (bits 16-23)
	db 10011010b ; Segment type and flags
	db 11001111b ; Limit (bits 16-19) and flags
	db 0x0 ; Segment base (bits 24-31)

gdt_data: ; Data segment descriptor
	dw 0xFFFF ; Limit (bits 0-15)
	dw 0x0 ; Segment base (bits 0-15)
	db 0x0 ; Segment base (bits 16-23)
	db 10010010b ; Segment type and flags
	db 11001111b ; Limit (bits 16-19) and flags
	db 0x0 ; Segment base (bits 24-31)

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; Size of the GDT
	dd gdt_start ; Physical address of the GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
