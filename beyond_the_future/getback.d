����                              r	= $120000
w	= $140000
	lea $120000+18,a0
	lea $140000,a1
	move.w #116*61-1,d7
kazpun
	move.b (a0)+,d0
	and.w #$e0,d0
	move.b (a0)+,d1
	and.w #$e0,d1
	move.b (a0)+,d2
	and.w #$e0,d2
	lsl.w #2,d0
	lsl.w #5,d1
	lsl.w #8,d2
	or.w d1,d0
	or.w d2,d0
	or.w #$7f,d0
	move.w d0,(a1)+
	dbf d7,kazpun
	rts
