QEMU      = qemu-system-i386
QEMU_ARGS = -L . -m 32 -rtc base=localtime -vga std -fda $(IMAGE)
IMAGE = fdimage

all: $(IMAGE)

nbuild: $(IMAGE)
	$(QEMU) $(QEMU_ARGS)

nasm: fdimage.nas
	nasm fdimage.nas -o $(IMAGE)

gas: helloos2.s
	as helloos2.s -o helloos2.o
	$(eval ELFHEAD_SIZE := $(shell readelf -h helloos2.o | grep "Size of this" | grep -o -E "[0-9]+"))
	dd if=helloos2.o of=helloos.img skip=$(ELFHEAD_SIZE) bs=1 count=512

gbuild:
	$(QEMU) -fda helloos.img

clean:
	rm -rf fdimage
