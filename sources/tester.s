����                                        	lea $dff000,a6
	move.w #$4000,$9a(a6)
wv
	move.l 4(a6),d0
	and.l #$1ff00,d0
	cmp.l #$13700,d0
	bne.s wv
	move.w #15000,d7
	lea $180000,a3
.pe
	move.l (a3)+,d0
	dbf d7,.pe
	move.w #$fff,$180(a6)
	btst #6,$bfe001
	bne.s wv
	move.w #$c000,$9a(a6)
	rts
