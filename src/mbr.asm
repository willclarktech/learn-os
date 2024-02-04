[org 0x7c00] ; The BIOS loads the MBR to this address

; The CPU starts in real mode
%include "src/real_mode.asm"
%include "src/gdt.asm"
%include "src/dap.asm"
%include "src/protected_mode.asm"

; Boot signature
times 510-($-$$) db 0 ; Pad boot sector with 0s
dw 0xAA55 ; Conventional boot signature indicating the MBR is valid
