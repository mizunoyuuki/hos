QEMU      = qemu-system-i386
QEMU_ARGS = -L . -m 32 -rtc base=localtime -vga std -fda $(IMAGE)
IMAGE = fdimage

all: $(IMAGE)

qemu: $(IMAGE)
	$(QEMU) $(QEMU_ARGS)

$(IMAGE): fdimage.nas
	nasm fdimage.nas -o $(IMAGE)

clean:
	rm -rf fdimage
