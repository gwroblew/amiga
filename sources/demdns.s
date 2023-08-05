ùúùúÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿfreq1	= 161
delay	macro
	move.w #300,d7
.delpe\@
	nop
	dbf d7,.delpe\@
	endm
program
	bset #1,$bfe001
	lea $dff000,a2
	move.l #$a0000,$a0(a2)
	move.w #$4000,$a4(a2)
	move.w #freq1,$a6(a2)
	move.w #0,$a8(a2)
	move.l #$c0000,$b0(a2)
	move.w #$4000,$b4(a2)
	move.w #freq1,$b6(a2)
	move.w #0,$b8(a2)
	move.w #$8003,$96(a2)
	move.w #$80,$9c(a2)
	lea $300000,a0
	bsr depinit
mysz
	lea $90000,a6
	bsr depblo
	lea $90000,a1
	lea $c0000,a3
	bsr getdif
	lea $a0000,a6
	bsr depblo
	lea $a0000,a1
	lea $c0000,a3
	bsr dekster
	move.l #$a0000,$a0(a2)
	move.l #$c0000,$b0(a2)
.czenak
	btst #6,$bfe001
	beq.w getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenak
	move.w #64,$a8(a2)
	move.w #64,$b8(a2)
	move.w #$80,$9c(a2)
	lea $a9000,a6
	bsr depblo
	lea $94000,a1
	lea $c9000,a3
	bsr getdif
	lea $a9000,a1
	lea $c9000,a3
	bsr dekster
	move.l #$a9000,$a0(a2)
	move.l #$c9000,$b0(a2)
.czenal
	btst #6,$bfe001
	beq.b getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenal
	move.w #$80,$9c(a2)
	bra.w mysz
getout
	rts
getdif
	move.w #16383,d7
.peged
	move.b (a1)+,(a3)
	addq.l #2,a3
	dbf d7,.peged
	move.b -2(a3),-1(a3)
	sub.l #32767,a3
	move.w #16382,d7
.peapr
	move.b -1(a3),d0
	move.b 1(a3),d1
	asr.b #1,d0
	asr.b #1,d1
	add.b d1,d0
	move.b d0,(a3)
	addq.l #2,a3
	dbf d7,.peapr
	rts

dekster
	move.w #32767,d7
.pedek
	move.b (a1),d0
	move.b (a3),d1
	ext.w d0
	ext.w d1
	move.w d0,d2
	add.w d1,d0
	sub.w d1,d2
	asr.w #1,d0
	asr.w #1,d2
	move.b d0,(a1)+
	move.b d2,(a3)+
	dbf d7,.pedek
	rts
depinit
	cmp.b #"M",(a0)+
	bne.w error
	move.b (a0)+,d0
	btst #4,d0
	beq.b .nohomo
	st holmode
.nohomo
	and.w #15,d0
	move.w d0,nbitunc
	rts
depblo
	tst.w holmode
	bne.w depbloh
	move.l a6,-(a7)
	tst.b (a0)+
	bne.w error
	moveq #0,d2
	move.b (a0)+,d2
	cmp.b #3,d2
	bls.w error
	cmp.b #32,d2
	bhi.w error
	move.l d2,d3
	subq.w #1,d3

	move.l d2,d0
	lsl.l #7,d0
	move.l a0,a4
	add.l d0,a0

	move.l #32767,d7
	moveq #0,d6
	moveq #1,d5
	moveq #1,d4
.dekod
	bftst (a0){d6:1}
	beq.w .gotvec
	addq.l #1,d6
	dbf d5,.nofill
	moveq #1,d5
	moveq #0,d0
	bfextu (a0){d6:4},d0
	asl.b #4,d0
	move.b d0,(a6)+
	addq.l #4,d6
	tst.w d4
	bne.b .nouzu1
	move.b -3(a6),d1
	asr.b #1,d0
	asr.b #1,d1
	add.b d1,d0
	move.b d0,-2(a6)
	moveq #1,d4
.nouzu1
	subq.l #1,d7
	bpl.b .dekod
	bra.w .jupod
.nofill
	addq.l #1,a6
	moveq #0,d4
	subq.l #1,d7
	bpl.b .dekod
	bra.w .jupod
.gotvec
	moveq #0,d0
	bfextu (a0){d6:8},d0
	mulu.w d2,d0
	addq.l #8,d6
	lea 0(a4,d0.l),a1
	tst.w d4
	bne.b .nouzu2
	move.b (a1),d0
	move.b -2(a6),d1
	asr.b #1,d0
	asr.b #1,d1
	add.b d1,d0
	move.b d0,-1(a6)
	moveq #1,d4
.nouzu2
	move.w d3,d1
.pecopve
	move.b (a1)+,(a6)+
	dbf d1,.pecopve
	moveq #1,d5
	sub.l d2,d7
	bpl.w .dekod
.jupod
	moveq #7,d0
	and.l d6,d0
	beq.b .nokor
	addq.l #1,a0
.nokor
	lsr.l #3,d6
	add.l d6,a0

	move.l (a7)+,a6
	rts
depbloh
	move.l a6,-(a7)
	moveq #0,d0
	move.b (a0)+,d0
	cmp.w #128,d0
	bhi.w error
	moveq #0,d2
	move.b (a0)+,d2
	cmp.b #3,d2
	bls.w error
	cmp.b #32,d2
	bhi.w error
	move.l d2,d3
	subq.w #1,d3

	muls.w d2,d0
	;move.l a0,a4
	;add.l d0,a0

	movem.l d2-d3,-(a7)
	moveq #0,d6
	lea vectors,a4
	subq.w #2,d0
	move.b (a0)+,d1
	move.b d1,(a4)+
	ext.w d1
.getsam
	bftst (a0){d6:1}
	beq.b .nozer
	move.b d1,(a4)+
	addq.l #1,d6
	dbf d0,.getsam
	bra.b .pogets
.nozer
	addq.l #1,d6
	bfextu (a0){d6:1},d2
	addq.l #1,d6
	bfffo (a0){d6:7},d3
	sub.l d6,d3
	add.l d3,d6
	addq.l #1,d6
	moveq #1,d4
	tst.w d3
	beq.b .skipsp
	lsl.w d3,d4
	bfextu (a0){d6:d3},d5
	add.w d5,d4
	add.l d3,d6
.skipsp
	tst.w d2
	beq.b .nozmzn
	neg.w d4
.nozmzn
	add.w d4,d1
	move.b d1,(a4)+
	dbf d0,.getsam
.pogets
	movem.l (a7)+,d2-d3

	lea vectors,a4
	move.l #32767,d7
	move.l d2,a3
	addq.l #1,a3
	moveq #0,d4
	move.w nbitunc,d4
	moveq #8,d5
	sub.l d4,d5
.dekod
	bftst (a0){d6:1}
	beq.w .gotvec
	addq.l #1,d6
	moveq #0,d0
	bfextu (a0){d6:d4},d0
	asl.b d5,d0
	move.b d0,(a6)
	add.l d4,d6
	move.b -2(a6),d1
	asr.b #1,d0
	asr.b #1,d1
	add.b d1,d0
	move.b d0,-1(a6)
	addq.l #2,a6
	subq.l #2,d7
	bpl.b .dekod
	bra.w .jupod
.gotvec
	moveq #0,d0
	bfextu (a0){d6:8},d0
	mulu.w d2,d0
	addq.l #8,d6
	lea 0(a4,d0.l),a1
	move.b (a1),d0
	move.b -2(a6),d1
	asr.b #1,d0
	asr.b #1,d1
	add.b d1,d0
	move.b d0,-1(a6)
	move.w d3,d1
.pecopve
	move.b (a1)+,(a6)+
	dbf d1,.pecopve
	addq.l #1,a6
	sub.l a3,d7
	bpl.w .dekod
.jupod
	moveq #7,d0
	and.l d6,d0
	beq.b .nokor
	addq.l #1,a0
.nokor
	lsr.l #3,d6
	add.l d6,a0
	move.l (a7)+,a6
	move.b 32766(a6),32767(a6)
	rts
error
	btst #6,$bfe001
	bne.b error
	addq.l #8,a7
	rts
vectors	ds.b 16*128
holmode	dc.w 0
nbitunc	dc.w 0
