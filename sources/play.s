����                                        	lea $dff000,a0
	move.l #$120000,$a0(a0)
	move.w #$ffff,$a4(a0)
	move.w #64,$a8(a0)
	move.w #200,$a6(a0)
	move.w #$8001,$dff096
ee
	btst #6,$bfe001
	bne.s ee
	move.w #1,$dff096
	rts
