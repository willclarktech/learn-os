ENTRY(_start)

SECTIONS {
	KERNEL_LOAD_ADDRESS = 0x0600;
	. = KERNEL_LOAD_ADDRESS;

	.text ALIGN(0x1000) : {
		*(.text)
	}

	.data ALIGN(0x1000) : {
		*(.data)
	}

	.bss ALIGN(0x1000) : {
		*(.bss)
		*(COMMON)
	}

	/DISCARD/ : {
		*(.comment)
	}
}
