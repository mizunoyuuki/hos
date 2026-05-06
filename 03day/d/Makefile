AS=gcc
LINK_SCRIPT=link.ld
AS_OPT=-nostdlib -T $(LINK_SCRIPT)
SRC=helloos.s
IMG=helloos.img
OBJ=helloos.bin
IMG_SIZE=1474560

QEMU=qemu-system-i386

all: img

img:asm
	dd if=$(OBJ) of=$(IMG) bs=1
	dd if=/dev/zero of=$(IMG) bs=1 count=0 seek=$(IMG_SIZE)

asm:
	$(AS) $(AS_OPT) $(SRC) -o $(OBJ)

$(IMG): all

run: $(IMG)
	$(QEMU) -drive format=raw,file=$(IMG),if=floppy

clean:
	rm -rf *.bin *.img
