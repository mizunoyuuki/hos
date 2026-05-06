.code16
.set CYLS, 10

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
	movw %ax, %es
	movb $0, %ch  # Cylinder 0
	movb $0, %dh  # head 0
	movb $2, %cl  # sector 2

readloop:
	movw $0, %si  # retry counter

retry:
	movb $0x02, %ah
	movb $1, %al
	movw $0, %bx
	movb $0x00, %dl
	int $0x13
	jnc next
	
	addw $1, %si
	cmp $5, %si
	jae error

	# reset drive
	movb $0x00, %ah
	movb $0x00, %dl
	int $0x13

	jmp retry

next:
	movw %es, %ax
	addw $0x20, %ax  # 512 /  16 = 0x20 対象アドレスは(ES*16 + BX)で決まるので、ESを0x20ずらすと、512byte分ずらしたのと同じになる。
	movw %ax, %es
	addb $1, %cl
	cmp $18, %cl
	jae readloop

	movb $1, %dh
	addb $1, %ch
	cmp $CYLS, %ch
	jb readloop

fin:
	hlt
	jmp fin

error:
	movw $msg, %si

putloop:
	movb (%si), %al
	addw $1,  %si
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

