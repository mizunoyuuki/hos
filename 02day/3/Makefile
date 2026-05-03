AS=gcc
AS_OPT=-nostdlib -T link.lds
SRC=helloos.s
TARGET_IMG=helloos.img

QEMU=qemu-system-i386

all:
	$(AS) $(AS_OPT) $(SRC) -o $(TARGET_IMG)

$(TARGET_IMG): all

run: $(TARGET_IMG)
	$(QEMU) -drive format=raw,file=$(TARGET_IMG),if=floppy


