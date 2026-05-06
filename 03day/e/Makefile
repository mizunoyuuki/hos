ipl:
	gcc -nostdlib -T link.ld ipl.s -o ipl

os:
	gcc -nostdlib -T link.ld haribote.s -o haribote

build:
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	dd if=ipl of=floppy.img bs=512 count=1 conv=notrunc
	dd if=haribote of=floppy.img bs=512 seek=1 conv=notrunc

run: ipl os
	dd if=/dev/zero of=haribote.img bs=512 count=2880
	dd if=ipl of=haribote.img bs=512 count=1 conv=notrunc
	dd if=haribote of=haribote.img bs=512 seek=1 conv=notrunc
	qemu-system-i386 -fda haribote.img

clean:
	rm -rf *.bin *.img haribote ipl
