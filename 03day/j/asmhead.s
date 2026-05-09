.text
.code16

.set BOTPAK,  0x00280000  # load destination of bootpack
.set DSKCAC,  0x00100000  # place of disk cache
.set DSKCAC0, 0x00008000  # place of disk cache (real mode)

# BOOT_INFO
.set CYLS,  0x0ff0
.set LEDS,  0x0ff1
.set VMODE, 0x0ff2
.set SCRNX, 0x0ff4
.set SCRNY, 0x0ff6
.set VRAM,  0x0ff8

# set video mode
movb $0x13, %al  # vga graphics 320 * 200 32bit color
movb $0x00, %ah
int $0x10

# save screen information
movb $8, (VMODE)
movw $320, (SCRNX)
movw $200, (SCRNY)
movl $0x000a0000, (VRAM)

# get keyboard led status from BIOS
movb $0x02, %ah
int $0x16
movb %al, (LEDS)

# PICが割り込みを受けないように
# よくわからないが、AT互換機の仕様では, PICの初期化をする場合CLI前にやる必要があるらしい

movb $0xff, %al
outb %al, $0x21
nop
outb %al, $0xa1

cli  # CPUレベルでの割り込み禁止

# A20GATEを設定(メモリを1MBまでアクセスできるようにする)
call waitkbdout
movb $0xd1, %al
outb %al, $0x64
call waitkbdout
movb $0xdf, %al # enable A20
outb %al, $0x60
call waitkbdout

# protect mode
.arch i486

lgdt (GDTR0)
movl $cr0, %eax
andl $0x7fffffff, %eax
orl  $0x00000001, %eax
movl $eax, %cr0
jmp pipelineflush

pipelineflush:
	movw $1*8, %ax
	movw %ax, %ds
	movw $ax, %es
	movw $ax, %fs
	movw $ax, %gs
	movw $ax, %ss

# bootpack転送
movl $bootpack, %esi
movl $BOTPAK, %edi
movl $512*1024/4, %ecx
call memcpy


# ディスクデータを本来の位置へ転送

# ブートセクタ
movl $0x7c00, %esi # 転送元
movl $DSKCAC, %edi
movl $512/4, %ecx
call memcpy


