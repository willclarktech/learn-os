ASM = nasm
ASM_FLAT_BINARY = bin
ASM_ELF_BINARY = elf32

CC = x86_64-linux-gnu-gcc
KERNEL_FLAGS = -Wall -m32 -c -ffreestanding -fno-asynchronous-unwind-tables -fno-pie

LD = x86_64-linux-gnu-ld
LD_ELF_FORMAT = elf_i386

OBJCOPY = x86_64-linux-gnu-objcopy
OBJCOPY_BINARY_FORMAT = binary

SRC_DIR = src
BIN_DIR = bin

BOOTSTRAP_ASM = $(SRC_DIR)/bootstrap.asm
BOOTSTRAP_BIN = $(BIN_DIR)/bootstrap.bin
STARTER_ASM = $(SRC_DIR)/starter.asm
STARTER_OBJECT = $(BIN_DIR)/starter.o
KERNEL_C = $(SRC_DIR)/kernel.c
KERNEL_OBJECT = $(BIN_DIR)/kernel.elf
LINKER_SCRIPT = $(SRC_DIR)/linker.ld
LINKED_OBJECT = $(BIN_DIR)/linked.elf
KERNEL_BIN = $(BIN_DIR)/kernel.bin

HDD_IMG = hdd.img
HDD_IMG_LOCKFILE = hdd.img.lock

SECTOR_SIZE = 512

.PHONY: all clean

all: $(HDD_IMG)
	bochs -q

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BOOTSTRAP_BIN): $(BOOTSTRAP_ASM) | $(BIN_DIR)
	$(ASM) -f $(ASM_FLAT_BINARY) $(BOOTSTRAP_ASM) -o $(BOOTSTRAP_BIN)

$(STARTER_OBJECT): $(STARTER_ASM) | $(BIN_DIR)
	$(ASM) -f $(ASM_ELF_BINARY) $(STARTER_ASM) -o $(STARTER_OBJECT)

$(KERNEL_OBJECT): $(KERNEL_C) | $(BIN_DIR)
	$(CC) $(KERNEL_FLAGS) $(KERNEL_C) -o $(KERNEL_OBJECT)

$(LINKED_OBJECT): $(KERNEL_OBJECT) $(STARTER_OBJECT)
	$(LD) -m $(LD_ELF_FORMAT) -T $(LINKER_SCRIPT) $(STARTER_OBJECT) $(KERNEL_OBJECT) -o $(LINKED_OBJECT)

$(KERNEL_BIN): $(LINKED_OBJECT)
	$(OBJCOPY) -O $(OBJCOPY_BINARY_FORMAT) $(LINKED_OBJECT) $(KERNEL_BIN)

# TODO: Clean this up/explain numbers
$(HDD_IMG): $(BOOTSTRAP_BIN) $(KERNEL_BIN)
	dd if=$(BOOTSTRAP_BIN) of=$(HDD_IMG)
	dd seek=1 conv=sync if=$(KERNEL_BIN) of=$(HDD_IMG) bs=$(SECTOR_SIZE) count=5
	dd seek=6 conv=sync if=/dev/zero of=$(HDD_IMG) bs=$(SECTOR_SIZE) count=2046

clean:
	rm -rf $(BIN_DIR) $(HDD_IMG) $(HDD_IMG_LOCKFILE)
