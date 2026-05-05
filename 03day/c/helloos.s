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
	# init registers
	movw $0, %ax
	movw %ax, %ss
	movw $0x7c00, %sp
	movw %ax, %ds

	# load disk
	movw $0x0820, %ax
	movw %ax, %es  # buffer address(ES:BX)
	movb $0, %ch   # Cylinder 0
	movb $0, %dh   # head 0
	movb $2, %cl   # sector 2

readloop:
	movw $0, %si  #retry counter

retry:
	movb $0x02, %ah # ah=0x02 read
	movb $1, %al    # 1 sector
	movw $0, %bx
	movb $0x00, %dl
	int $0x13
	jnc next    # jump if not error

	addw $1, %si  # count up
	cmp $5, %si
	jae error

	# reset drive(drive A)
	movb $0x00, %ah
	movb $0x00, %dl
	int $0x13

	jmp entry


next:
	movw %es, %ax
	add $0x20, %ax  # 512 / 16 = 0x20

	movw %ax, %es
	add $1, %cl
	cmp $18, %cl

	jae readloop

fin:
	hlt
	jmp fin

error:
	movw $msg, %si

putloop:
	movb (%si), %dl
	addw $1, %si
	cmpb $0, %al
	je fin
	movb $0x0e, %dh
	movw $15, %bx
	int $0x10
	jmp putloop

msg:
	.string "\nload error\n\n"

.org 0x1fe
.byte 0x55, 0xaa
