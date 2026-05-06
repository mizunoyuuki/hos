all: floppy.img

floppy.img: ipl os
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	dd if=ipl of=floppy.img bs=512 count=1 conv=notrunc
	dd if=os of=floppy.img bs=512 count=1 seek=1 conv=notrunc

ipl: ipl.s ipl.ld
	as --32 ipl.s -o ipl.o
	ld -m elf_i386 -T ipl.ld ipl.o -o ipl

os: os.s os.ld
	as --32 os.s -o os.o
	ld -m elf_i386 -T os.ld os.o -o os

run: floppy.img
	qemu-system-i386 -fda floppy.img

clean:
	rm -rf ipl ipl.o os os.o *.img
