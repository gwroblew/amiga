����                    	move.l #20000*20000,d0
	move.w	#2,d6
	moveq	#15,d5
	move.l	d0,d2
	asr.l	#1,d2
	or.l	d0,d2
schaetzung:
	asl.l	#2,d2
	roxl.w	#1,d1
	dbf	d5,schaetzung
	tst.w	d1
	beq.s	sqrtend
sqrtloop:
	move.l	d0,d2
	divs	d1,d2
	add.w	d2,d1
	beq.s	sqrtend
	lsr.w	#1,d1
	dbf	d6,sqrtloop
sqrtend:
	rts
