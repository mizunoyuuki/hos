.text
.code16

.set CYLS, 0x0ff0
.set LEDS, 0x0ff1
.set VMODE, 0x0ff2
.set SCRNX, 0x0ff4
.set SCRNY, 0x0ff6
.set VRAM, 0x0ff8

movb $0x13, %al
movb $0x00, %ah
int $0x10

# save screen information
movb $8, (VMODE)
int $0x16
mov %al, (LEDS)

movw $booted, %si

loop:
    movb (%si), %al
    addw $1, %si
    cmpb $0, %al
    je fin
    movb $0x0e, %ah
    movw $15, %bx
    int $0x10
    jmp loop

booted:
    .string "\nos booted!\n\n"

fin:
	hlt
	jmp fin
