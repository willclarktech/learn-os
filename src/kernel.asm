[org 0x0600] ; The MBR loads the kernel to this address
[bits 16]; The CPU starts in 16-bit real mode

kernel_hang:
  jmp kernel_hang
