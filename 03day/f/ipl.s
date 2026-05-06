.text
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

.set CYLS, 10

entry:
	# init register
	movw $0, %ax
	movw %ax, %ss
	movw $0x7c00, %sp
	movw %ax, %ds

	# load disk
	movw $0x820, %ax
	movw %ax, %es
	movb $0, %ch
	movb $0, %dh
	movb $2, %cl

readloop:
	movw $0, %si

retry:
	movb $0x02, %ah
	movb $1, %al
	movw $0, %bx
	movb $0x00, %dl
	int $0x13
	jnc next

	add $1, %si
	cmp $5, %si
	jae error

	# reset drive
	movb $0x00, %ah
	movb $0x00, %dl
	int $0x13

	jmp retry

next:
	movw %es, %ax
	add $0x20, %ax
	movb %al, %cl
	add $1, %cl
	cmp $18, %cl
	jbe readloop

	movb $1, %cl
	add $1, %dh
	cmp $2, %dh
	jb readloop

	movb $0, %dh
	add $1, %ch
	cmp $CYLS, %ch
	jb readloop

	jmp 0x8c00 	# jmp to os program
			# 0x0800(buffer address) + 0x4200 (first file place of FAT12)
			# セクタ2から先をメモリアドレス0x0820を先頭としてロード

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
