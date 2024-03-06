WORD_SIZE equ 4

SECONDARY_IRQ_BASE equ 40
OFFSET_HIGH equ 0x0000

PRESENT_FLAG equ 1<<7 ; Must be 1 for any valid descriptor
DPL_FIELD equ 0<<5 ; Highest privilege
ZERO_BIT equ 0<<4 ; Constant
GATE_TYPE_FIELD equ 0xe ; 32-bit interrupt gate
FLAGS_WORD equ (PRESENT_FLAG | DPL_FIELD | ZERO_BIT | GATE_TYPE_FIELD)<<8 ; Low byte is reserved

; Interrupts 0-31 are used by the processor

isr_0:
	cli
	push 0
	jmp isr_basic

isr_1:
	cli
	push 1
	jmp isr_basic

isr_2:
	cli
	push 2
	jmp isr_basic

isr_3:
	cli
	push 3
	jmp isr_basic

isr_4:
	cli
	push 4
	jmp isr_basic

isr_5:
	cli
	push 5
	jmp isr_basic

isr_6:
	cli
	push 6
	jmp isr_basic

isr_7:
	cli
	push 7
	jmp isr_basic

isr_8:
	cli
	push 8
	jmp isr_basic

isr_9:
	cli
	push 9
	jmp isr_basic

isr_10:
	cli
	push 10
	jmp isr_basic

isr_11:
	cli
	push 11
	jmp isr_basic

isr_12:
	cli
	push 12
	jmp isr_basic

isr_13:
	cli
	push 13
	jmp isr_basic

isr_14:
	cli
	push 14
	jmp isr_basic

isr_15:
	cli
	push 15
	jmp isr_basic

isr_16:
	cli
	push 16
	jmp isr_basic

isr_17:
	cli
	push 17
	jmp isr_basic

isr_18:
	cli
	push 18
	jmp isr_basic

isr_19:
	cli
	push 19
	jmp isr_basic

isr_20:
	cli
	push 20
	jmp isr_basic

isr_21:
	cli
	push 21
	jmp isr_basic

; Interrupts 22-31 are reserved
; We need to fill the slots anyway in order to use subsequent interrupt numbers

isr_22:
	cli
	push 22
	jmp isr_basic

isr_23:
	cli
	push 23
	jmp isr_basic

isr_24:
	cli
	push 24
	jmp isr_basic

isr_25:
	cli
	push 25
	jmp isr_basic

isr_26:
	cli
	push 26
	jmp isr_basic

isr_27:
	cli
	push 27
	jmp isr_basic

isr_28:
	cli
	push 28
	jmp isr_basic

isr_29:
	cli
	push 29
	jmp isr_basic

isr_30:
	cli
	push 30
	jmp isr_basic

isr_31:
	cli
	push 31
	jmp isr_basic

; Interrupts 32-48 are used for hardware interrupts after our PIC remapping

isr_32:
	cli
	push 32
	jmp irq_basic

isr_33:
	cli
	push 33
	jmp irq_basic

isr_34:
	cli
	push 34
	jmp irq_basic

isr_35:
	cli
	push 35
	jmp irq_basic

isr_36:
	cli
	push 36
	jmp irq_basic

isr_37:
	cli
	push 37
	jmp irq_basic

isr_38:
	cli
	push 38
	jmp irq_basic

isr_39:
	cli
	push 39
	jmp irq_basic

; TODO: Are these really the right numbers?
; Interrupts 40-47 are send to the secondary PIC

isr_40:
	cli
	push 40
	jmp irq_basic

isr_41:
	cli
	push 41
	jmp irq_basic

isr_42:
	cli
	push 42
	jmp irq_basic

isr_43:
	cli
	push 43
	jmp irq_basic

isr_44:
	cli
	push 44
	jmp irq_basic

isr_45:
	cli
	push 45
	jmp irq_basic

isr_46:
	cli
	push 46
	jmp irq_basic

isr_47:
	cli
	push 47
	jmp irq_basic

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

idt:
	dw isr_0, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_1, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_2, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_3, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_4, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_5, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_6, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_7, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_8, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_9, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_10, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_11, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_12, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_13, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_14, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_15, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_16, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_17, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_18, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_19, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_20, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_21, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_22, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_23, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_24, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_25, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_26, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_27, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_28, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_29, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_30, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_31, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_32, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_33, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_34, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_35, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_36, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_37, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_38, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_39, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_40, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_41, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_42, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_43, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_44, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_45, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_46, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH
	dw isr_47, KERNEL_CODE_SEGMENT, FLAGS_WORD, OFFSET_HIGH

idtr:
	idt_size: dw idtr - idt
	idt_base_address: dd idt
