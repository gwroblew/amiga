����                                        numframes = 38
noise	= 7
prog
	lea $300000,a0
	lea $308000,a1
	moveq #numframes-2,d7
.compall
	move.l a0,a2
	move.l a1,a3
	move.w #128*128-1,d6
.compfr
	move.w (a2)+,d0
	move.w (a3)+,d3
	move.w d0,d1
	move.w d0,d2
	rol.w #4,d0
	rol.w #7,d1
	lsr.w #6,d2
	and.w #14,d0
	and.w #14,d1
	and.w #14,d2
	move.w d3,d4
	move.w d3,d5
	rol.w #4,d3
	rol.w #7,d4
	lsr.w #6,d5
	and.w #14,d3
	and.w #14,d4
	and.w #14,d5
	sub.w d0,d3
	bpl.b .wlazna1
	neg.w d3
.wlazna1
	sub.w d1,d4
	bpl.b .wlazna2
	neg.w d4
.wlazna2
	sub.w d2,d5
	bpl.b .wlazna3
	neg.w d5
.wlazna3
	add.w d3,d5
	add.w d4,d5
	cmp.w #noise,d5
	bge.b .nosame
	move.w -2(a2),-2(a3)
.nosame
	dbf d6,.compfr
	add.l #32768,a0
	add.l #32768,a1
	dbf d7,.compall
	lea $300000,a0
	lea packed,a5
	move.w #8191,d7
.pecopf
	move.l (a0)+,(a5)+
	dbf d7,.pecopf
	lea $300000,a0
	lea $308000,a1
	moveq #numframes-2,d7
.compkom
	move.l a0,a2
	move.l a1,a3
	move.w #128*128-1,d6
	moveq #0,d5
.checeq
	cmpm.w (a2)+,(a3)+
	bne.b .nosamq
	addq.w #1,d5
	dbf d6,.checeq
	neg.w d5
	move.w d5,(a5)+
	bra.b .jupokof
.nosamq
	tst.w d5
	beq.b .nosamy
	neg.w d5
	move.w d5,(a5)+
	moveq #0,d5
.nosamy
	move.w -2(a3),d0
	lsr.w #4,d0
	move.w d0,(a5)+
	dbf d6,.checeq
.jupokof
	add.l #32768,a0
	add.l #32768,a1
	dbf d7,.compkom
	move.l a5,d0
	sub.l #packed,d0
	rts

	org $480000
	load $480000
packed	blk.l 600*256,0

	org $300000
	load $300000
	incbin frames
