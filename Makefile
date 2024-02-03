SRC_DIR=src
BIN_DIR=bin

MBR_SRC=$(SRC_DIR)/mbr.asm
MBR_BIN=$(BIN_DIR)/mbr.bin

KERNEL_SRC=$(SRC_DIR)/kernel.asm
KERNEL_BIN=$(BIN_DIR)/kernel.bin
KERNEL_LOAD_ADDRESS=0x0600

HDD_IMG=hdd.img
DISK_SIZE_MB=10
SECTORS_PER_MB=2048

.PHONY: all clean run

all: $(HDD_IMG)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(MBR_BIN): $(MBR_SRC) | $(BIN_DIR)
	nasm -f bin -o $(MBR_BIN) $(MBR_SRC)

$(KERNEL_BIN): $(KERNEL_SRC) | $(BIN_DIR)
	nasm -f bin -o $(KERNEL_BIN) $(KERNEL_SRC)

$(HDD_IMG): $(MBR_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=$(HDD_IMG) bs=512 count=$(shell echo "$(DISK_SIZE_MB)*$(SECTORS_PER_MB)" | bc)
	dd if=$(MBR_BIN) of=$(HDD_IMG) conv=notrunc
	dd if=$(KERNEL_BIN) of=$(HDD_IMG) conv=notrunc seek=1

clean:
	rm -rf $(BIN_DIR) $(HDD_IMG)

run:
	bochs -q
