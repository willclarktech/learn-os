SECTIONS {
	KERNEL_LOAD_ADDRESS = 0x9000;
	. = KERNEL_LOAD_ADDRESS;

	.text : {
		code = .;
		*(.text)
	}

	.data : {
		data = .;
		*(.data)
		*(.rodata)
	}

	.bss : {
		bss = .;
		*(.bss)
	}

	end = .;
}
