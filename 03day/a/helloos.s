.code16

jmp entry
.byte 0x90
.ascii "HELLOIPL"
.word 512
.byte 1
.word 1
.byte 2
.word 224
.word 2880
.byte 0xf0
.word 9
.word 18
.word 2
.int 0
.int 2880
.byte 0,0,0x29
.int 0xffffffff
.ascii "HELLO-OS"
.ascii "FAT12"
.skip 18,0

entry:
	#init registers
	movw $0, %ax
	movw %ax, %ss
	movw $0x7c00, %sp
	movw %ax, %ds

	#load disk
	movw $0x0820, %ax
	movw %ax, %es
	movb $0, %ch
	movb $0, %dh
	movb $2, %cl

	movb $0x02, %ah
	movb $1, %al
	movw $0, %bx
	movb $0x00, %dl
	int $0x13
	jc error

fin:
	hlt
	jmp fin

error:
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

msg:
	.string "\nload error\n\n"

.org 0x01fe
.byte 0x55, 0xaa

