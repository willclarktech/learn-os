extern kernel_main

NULL_SEGMENT equ gdt.null - gdt
KERNEL_CODE_SEGMENT equ gdt.kernel_code - gdt
KERNEL_DATA_SEGMENT equ gdt.kernel_data - gdt

; Interrupt code for performing video actions
; ah: The action to perform
INT_VIDEO equ 0x10
; Video action to set the video mode
; al: The video mode
INT_VIDEO_SET_VIDEO_MODE equ 0x00
; Video action to set the cursor type
; cx: The cursor type
INT_VIDEO_SET_CURSOR_TYPE equ 0x01

; CR0 register protection enable bit
PE_FLAG equ 1

VIDEO_MODE_TEXT equ 0x03
CURSOR_TYPE_DISABLED equ 0x2000
PIC_PORT_PRIMARY_COMMAND equ 0x20
PIC_PORT_PRIMARY_DATA equ 0x21
PIC_PORT_SECONDARY_COMMAND equ 0xa0
PIC_PORT_SECONDARY_DATA equ 0xa1

; Command to initialize the programmable interrupt controller (PIC)
; Send this to the command port and then send the following parameters to the data port:
; 1. New starting offset of IRQs
; 2. Number of the slot connected to the other PIC (primary/secondary)
; 3. Which mode (eg x86)
; 4. Which IRQs to enable/disable
PIC_COMMAND_INIT equ 0x11
PIC_OFFSET_PRIMARY equ 0x20
PIC_OFFSET_SECONDARY equ 0x28
PIC_SLOT_PRIMARY equ 0x04 ; 2^2
PIC_SLOT_SECONDARY equ 0x02
PIC_MODE_X86 equ 0x01
PIC_ENABLE_IRQS_ALL equ 0x00

; Command to inform the PIC of the end of an interrupt
PIC_COMMAND_EOI equ 0x20

bits 16

start:
	; Set the data segment to equal the current code segment
	; This way we can easily reference data defined in this file
	mov ax, cs
	mov ds, ax

	call load_gdt
	call init_video_mode
	call enter_protected_mode
	call setup_interrupts

	jmp KERNEL_CODE_SEGMENT:start_kernel

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
	or eax, PE_FLAG
	mov cr0, eax
	ret

setup_interrupts:
	call remap_pic
	call load_idt
	ret

remap_pic:
	mov al, PIC_COMMAND_INIT
	out PIC_PORT_PRIMARY_COMMAND, al
	out PIC_PORT_SECONDARY_COMMAND, al

	mov al, PIC_OFFSET_PRIMARY
	out PIC_PORT_PRIMARY_DATA, al

	mov al, PIC_OFFSET_SECONDARY
	out PIC_PORT_SECONDARY_DATA, al

	mov al, PIC_SLOT_PRIMARY
	out PIC_PORT_PRIMARY_DATA, al

	mov al, PIC_SLOT_SECONDARY
	out PIC_PORT_SECONDARY_DATA, al

	mov al, PIC_MODE_X86
	out PIC_PORT_PRIMARY_DATA, al
	out PIC_PORT_SECONDARY_DATA, al

	mov al, PIC_ENABLE_IRQS_ALL
	out PIC_PORT_PRIMARY_DATA, al
	out PIC_PORT_SECONDARY_DATA, al

	ret

load_idt:
	lidt [idtr - start]
	ret

bits 32

start_kernel:
	; Set the data segment and stack segment to match the GDT
	mov eax, KERNEL_DATA_SEGMENT
	mov ds, eax
	mov ss, eax

	; Null because these segments won't be used
	mov eax, NULL_SEGMENT
	mov es, eax
	mov fs, eax
	mov gs, eax

	sti ; Now we are ready to re-enable interrupts

	call kernel_main

	jmp $ ; Infinite loop

%include "gdt.asm"
%include "idt.asm"
