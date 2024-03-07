WORD_SIZE equ 4

SECONDARY_IRQ_BASE equ 40
OFFSET_HIGH equ 0x0000

PRESENT_FLAG equ 1<<7 ; Must be 1 for any valid descriptor
DPL_FIELD equ 0<<5 ; Highest privilege
ZERO_BIT equ 0<<4 ; Constant
GATE_TYPE_FIELD equ 0xe ; 32-bit interrupt gate
FLAGS_WORD equ (PRESENT_FLAG | DPL_FIELD | ZERO_BIT | GATE_TYPE_FIELD)<<8 ; Low byte is reserved

; Interrupts 0-31 are used by the processor
; Interrupts 22-31 are reserved
; We need to fill the slots anyway in order to use subsequent interrupt numbers

; Start and end interrupt numbers
%macro ISR 2
	%assign i %1
	%rep %2-%1+1
		isr_%[i]:
			cli
			push %[i]
			jmp isr_basic
		%assign i i+1
	%endrep
%endmacro

ISR 0, 31

; TODO: Are these really the right numbers?
; Interrupts 32-47 are used for hardware interrupts after our PIC remapping
; Interrupts 40-47 are send to the secondary PIC

; Start and end interrupt numbers
%macro IRQ 2
	%assign i %1
	%rep %2-%1+1
		isr_%[i]:
			cli
			push %[i]
			jmp irq_basic
		%assign i i+1
	%endrep
%endmacro

IRQ 32, 47

isr_basic:
	call interrupt_handler
	add esp, WORD_SIZE ; Discard the current interrupt number
	sti
	iret

irq_basic:
	call interrupt_handler

	mov al, PIC_COMMAND_EOI
	out PIC_PORT_PRIMARY_COMMAND, al

	; Only inform secondary PIC if necessary
	cmp byte [esp], SECONDARY_IRQ_BASE
	jnge irq_basic_end
	out PIC_PORT_SECONDARY_COMMAND, al

	irq_basic_end:
		add esp, WORD_SIZE ; Discard the current interrupt number
		sti
		iret

; Number of entries
%macro IDT_ENTRY 1
	%assign i 0
	%rep %1
		dw isr_%[i], KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
		%assign i i+1
	%endrep
%endmacro

idt:
	IDT_ENTRY 48

idtr:
	idt_size: dw idtr - idt
	idt_base_address: dd idt
