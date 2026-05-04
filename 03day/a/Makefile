AS=gcc
AS_OPT=-nostdlib -T link.lds
TARGET=helloos.img
SRC=helloos.s

QEMU=qemu-system-i386

all:
	$(AS) $(AS_OPT) $(SRC) -o $(TARGET)

run:
	$(QEMU) -fda $(TARGET)

