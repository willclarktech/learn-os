; Disk Address Packet
dap:
	db 0x10 ; Size of the DAP (16 bytes)
	db 0 ; Unused
	dw 1 ; Number of sectors to read
	dw 0x600 ; Offset of buffer in memory (kernel destination)
	dw 0 ; Segment of buffer in memory
	dq 1 ; LBA of the first sector to read (the sector immediately after MBR)
