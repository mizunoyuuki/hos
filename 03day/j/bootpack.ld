/*
 * This linker script is created by refer following page.
 * https://vanya.jp.net/os/haribote.html
 */

OUTPUT_FORMAT("binary");

SECTIONS {
	.head 0x0 : {
		LONG(64 * 1024)         /* stack + .data + heapの大きさ(4KBの倍数)*/
		LONG(0x69726148)        /* 4 : シグネチャ "Hari"  */
		LONG(0) 		/* 12: mmareaの大きさ(4の倍数) */
		LONG(0x310000)		/* 16: .dataのサイズ */
		LONG(SIZEOF(.data))	/* 20: .dataの初期値列のファイル位置 */
		LONG(LOADADDR(.data))	/* 24: 0xE9000000 */
		LONG(0xE9000000)	/* 28: エントリアドレス - 0x20 */
		LONG(HariMain - 0x20)	/* 32: heap領域(malloc領域)開始アドレス*/
		LONG(0)
	}

	.text : {*(.text)}

	.data 0x310000 : AT ( ADDR(.text) + SIZEOF(.text)) {
		*(.data)
		*(.rodata*)
		*(.bss)
	}

	/DISCARD/ : { *(.eh_frame) }
}
