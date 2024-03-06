; A GDT which implements a flat memory model

PRESENT_FLAG equ 1<<7 ; Must be 1 for any valid segment
DPL_FIELD_KERNEL equ 0<<5 ; Highest privilege
DPL_FIELD_USERSPACE equ 3<<5 ; Lowest privilege
S_FLAG equ 1<<4 ; 0 = system segment, 1 = code or data segment
E_FLAG_CODE equ 1<<3; Executable
E_FLAG_DATA equ 0<<3; Not executable
DC_FLAG_CODE equ 0<<2; 0 = code is non-conforming, 1 = code is conforming
DC_FLAG_DATA equ 0<<2; 0 = data grows up, 1 = data grows down
RW_FLAG_CODE equ 1<<1; 0 = read access not allowed; 1 = read access allowed
RW_FLAG_DATA equ 1<<1; 0 = write access not allowed; 1 = write access allowed
A_FLAG equ 0<<0 ; 0 = not accessed, 1 = accessed

ACCESS_BYTE_KERNEL_CODE equ PRESENT_FLAG | DPL_FIELD_KERNEL | S_FLAG | E_FLAG_CODE | DC_FLAG_CODE | RW_FLAG_CODE | A_FLAG
ACCESS_BYTE_KERNEL_DATA equ PRESENT_FLAG | DPL_FIELD_KERNEL | S_FLAG | E_FLAG_DATA | DC_FLAG_DATA | RW_FLAG_DATA | A_FLAG
ACCESS_BYTE_USERSPACE_CODE equ PRESENT_FLAG | DPL_FIELD_USERSPACE | S_FLAG | E_FLAG_CODE | DC_FLAG_CODE | RW_FLAG_CODE | A_FLAG
ACCESS_BYTE_USERSPACE_DATA equ PRESENT_FLAG | DPL_FIELD_USERSPACE | S_FLAG | E_FLAG_DATA | DC_FLAG_DATA | RW_FLAG_DATA | A_FLAG

G_FLAG equ 1<<3 ; 0 = 1 byte blocks, 1 = 4KiB blocks
DB_FLAG equ 1<<2 ; 0 = 16-bit protected mode segment, 1 = 32-bit protected mode segment
L_FLAG equ 0<<1 ; 1 = 64-bit code segment (DB_FLAG should be 0)
FLAGS equ G_FLAG | DB_FLAG | L_FLAG ; Bit 0 is reserved

BASE_LOW equ 0x0000
BASE_MID equ 0x00
BASE_HIGH equ 0x00
LIMIT_LOW equ 0xFFFF
LIMIT_HIGH equ 0xF

FLAGS_BYTE equ FLAGS<<4 | LIMIT_HIGH

gdt:
	; Required null entry
	null_descriptor:
		dq 0
	kernel_code_descriptor:
		dw LIMIT_LOW
		dw BASE_LOW
		db BASE_MID
		db ACCESS_BYTE_KERNEL_CODE
		db FLAGS_BYTE
		db BASE_HIGH
	kernel_data_descriptor:
		dw LIMIT_LOW
		dw BASE_LOW
		db BASE_MID
		db ACCESS_BYTE_KERNEL_DATA
		db FLAGS_BYTE
		db BASE_HIGH
	userspace_code_descriptor:
		dw LIMIT_LOW
		dw BASE_LOW
		db BASE_MID
		db ACCESS_BYTE_USERSPACE_CODE
		db FLAGS_BYTE
		db BASE_HIGH
	userspace_data_descriptor:
		dw LIMIT_LOW
		dw BASE_LOW
		db BASE_MID
		db ACCESS_BYTE_USERSPACE_DATA
		db FLAGS_BYTE
		db BASE_HIGH

; This will be loaded into the gdtr register so it matches that structure
gdtr:
	gdt_size: dw gdtr - gdt
	gdt_base_address: dd gdt
