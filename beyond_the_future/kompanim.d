����                                        source	= $120000
len	= 372464
destiny	= $180000
znapak
	lea source,a0
	lea destiny,a1
	lea source+len,a3
.pemain
	moveq #0,d6
	move.l a1,a2
	move.w (a0)+,d0
	cmp.w (a0),d0
	beq.b .same
	addq.l #1,a1
	move.w d0,(a1)+
	addq.w #1,d6
.caldif
	move.w (a0)+,d0
	cmp.w (a0),d0
	beq.b .jukod
	move.w d0,(a1)+
	addq.w #1,d6
	cmp.w #126,d6
	ble.b .caldif
.jukod
	subq.l #2,a0
	or.b #$80,d6
	move.b d6,(a2)
	and.w #$7f,d6
	cmp.l a3,a0
	blt.b .pemain
	rts
.same
	addq.w #1,d6
	addq.l #2,a0
.komsam
	addq.w #1,d6
	cmp.w #127,d6
	beq.b .gotmax
	cmp.w (a0)+,d0
	beq.b .komsam
	subq.l #2,a0
.gotmax
	move.b d6,(a1)+
	move.w d0,(a1)+
	cmp.l a3,a0
	blt.b .pemain
	rts
