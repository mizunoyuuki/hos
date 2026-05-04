AS=gcc
AS_OPT=-nostdlib -T $(LINK_FILE)
SRC=helloos.s
TARGET=helloos.img
LINK_FILE=link.ld
QEMU=qemu-system-i386

all:
	$(AS) $(AS_OPT) $(SRC) -o $(TARGET)

run:
	$(QEMU) -fda $(TARGET)

clean:
	rm -rf *,o helloos.img
