ASM = nasm
FLAT_BINARY = bin

SRC_DIR = src
BIN_DIR = bin

BOOTSTRAP_ASM = $(SRC_DIR)/bootstrap.asm
BOOTSTRAP_OBJECT = $(BIN_DIR)/bootstrap.o
KERNEL_ASM = $(SRC_DIR)/kernel.asm
KERNEL_OBJECT = $(BIN_DIR)/kernel.o

HDD_IMG = hdd.img

SECTOR_SIZE = 512

.PHONY: all clean

all: $(BOOTSTRAP_OBJECT) $(KERNEL_OBJECT)
	dd if=$(BOOTSTRAP_OBJECT) of=$(HDD_IMG)
	dd seek=1 conv=sync if=$(KERNEL_OBJECT) of=$(HDD_IMG) bs=$(SECTOR_SIZE)
	bochs -q

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BOOTSTRAP_OBJECT): $(BOOTSTRAP_ASM) | $(BIN_DIR)
	$(ASM) -f $(FLAT_BINARY) $(BOOTSTRAP_ASM) -o $(BOOTSTRAP_OBJECT)

$(KERNEL_OBJECT): $(KERNEL_ASM) | $(BIN_DIR)
	$(ASM) -f $(FLAT_BINARY) $(KERNEL_ASM) -o $(KERNEL_OBJECT)

clean:
	rm -rf $(BIN_DIR) $(HDD_IMG)
