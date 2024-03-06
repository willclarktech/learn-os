bits 16
extern kernel_main

; Offsets in GDT
KERNEL_CODE_SEGMENT equ 0x08
KERNEL_DATA_SEGMENT equ 0x10

; Interrupt code for performing video actions
; ah: The action to perform
INT_VIDEO equ 0x10
; Video action to set the video mode
; al: The video mode
INT_VIDEO_SET_VIDEO_MODE equ 0x00
; Video action to set the cursor type
; cx: The cursor type
INT_VIDEO_SET_CURSOR_TYPE equ 0x01

VIDEO_MODE_TEXT equ 0x03
CURSOR_TYPE_DISABLED equ 0x2000

start:
	; Set the data segment to equal the current code segment
	; This way we can easily reference data defined in this file
	mov ax, cs
	mov ds, ax

	call load_gdt
	call init_video_mode
	call enter_protected_mode
	call setup_interrupts

	call KERNEL_CODE_SEGMENT:start_kernel

load_gdt:
	cli ; Clearing interrupts before entering protected mode is recommended
	lgdt [gdtr - start]
	ret

init_video_mode:
	mov ah, INT_VIDEO_SET_VIDEO_MODE
	mov al, VIDEO_MODE_TEXT
	int INT_VIDEO

	mov ah, INT_VIDEO_SET_CURSOR_TYPE
	mov cx, CURSOR_TYPE_DISABLED
	int INT_VIDEO

	ret

enter_protected_mode:
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	ret

; TODO: Fill this out
setup_interrupts:
	ret

bits 32

start_kernel:
	; Set the data segment and stack segment to match the GDT
	mov eax, KERNEL_DATA_SEGMENT
	mov ds, eax
	mov ss, eax

	; Null value because these segments won't be used
	mov eax, 0x00
	mov es, eax
	mov fs, eax
	mov gs, eax

	sti ; Now we are ready to re-enable interrupts

	call kernel_main

%include "src/gdt.asm"
