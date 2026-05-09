.text
.code16

.set CYLS, 0xff0
.set LEDS, 0xff1
.set VMODE, 0x0ff2
.set SCRNX, 0x0ff4
.set SCRNY, 0x0ff6
.set VRAM, 0x0ff8

movb $8, (VMODE)
movw $320, (SCRNX)
movw $200, (SCRNY)
movl $0x000a0000, (VRAM)

# get keyboard led status from BIOS
mov $0x02, %ah
int $0x16
mov %al, (LEDS)

fin:
	hlt
	jmp fin
