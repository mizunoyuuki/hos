.code16

jmp entry
.byte 0x90
.ascii "HELLOIPL"
.word 512   # sector size(should be 512 byte)
.byte 1     # clustor size (should be sector)
.word 1     # start sector of FAT(normally 1 sector)
.byte 2     # number of FAT (should be 2)
.word 224   # size of root directory (normally 224)
.word 2880  # size of drive (should be 2880 sector)
.byte 0xf0  # media type
.word 9
.word 18
.word 2
.int  0
.int  2880  # size of  drive
.byte 0,0,0x29
.int  0xffffffff
.ascii "HELLO-OS"
.ascii "FAT12"
.skip 18,0

entry:
	movw $0, %ax
	movw %ax, %ss
	movw $0x7c00, %sp
	movw %ax, %ds
	movw %ax, %es

	movw $msg, %si

putloop:
	movb (%si), %al
	addw $1, %si
	cmpb $0, %al
	je fin
	movb $0x0e, %ah
	movw $15, %bx
	int $0x10
	jmp putloop

fin:
	hlt
	jmp fin

msg:
	.string "\nhello, world\n\n"

.org 0x01fe
.byte 0x55, 0xaa

.byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
.skip 4600
.byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
.skip 1469432

