����                                        	lea $dff000,a6
	move.w #$4000,$9a(a6)
wv
	move.l 4(a6),d0
	and.l #$1ff00,d0
	cmp.l #$13700,d0
	bne.s wv
	move.w #2000,d7
	lea $400000,a0
	move.l a0,a1
	lea $120000,a2
.pe
	move.l (a0)+,d0
	rept 5
	move.w 0(a1,d0.w*2),(a2)+
	endr
	swap d0
	rept 5
	move.w 0(a1,d0.w*2),(a2)+
	endr
	dbf d7,.pe
	move.w #$fff,$180(a6)
	btst #6,$bfe001
	bne.s wv
	move.w #$c000,$9a(a6)
	rts
