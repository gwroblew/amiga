ùúùúÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿfreq1	= 166
freq2	= 166
delay	macro
	move.w #300,d7
.delpe\@
	nop
	dbf d7,.delpe\@
	endm
program
	bclr #1,$bfe001
	lea $dff000,a2
	move.l #$a0000,$a0(a2)
	move.w #$2000,$a4(a2)
	move.w #freq1,$a6(a2)
	move.w #0,$a8(a2)
	move.l #$a0000,$b0(a2)
	move.w #$2000,$b4(a2)
	move.w #freq2,$b6(a2)
	move.w #0,$b8(a2)
	move.w #$8003,$96(a2)
	move.w #$80,$9c(a2)
	lea $300000,a0
mysz
	lea $a0000,a6
	bsr depblo
	move.l #$a0000,$a0(a2)
	move.l #$a0000,$b0(a2)
.czenak
	btst #6,$bfe001
	beq.w getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenak
	move.w #64,$a8(a2)
	move.w #64,$b8(a2)
	move.w #$80,$9c(a2)
	move.w #freq1,$a6(a2)
	move.w #freq2,$b6(a2)
	delay
	move.l #$a4000,$a0(a2)
	move.l #$a4000,$b0(a2)
.czenas
	btst #6,$bfe001
	beq.w getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenas
	move.w #$80,$9c(a2)
	move.w #freq2,$a6(a2)
	move.w #freq1,$b6(a2)
	lea $a9000,a6
	bsr depblo
	move.l #$a9000,$a0(a2)
	move.l #$a9000,$b0(a2)
.czenal
	btst #6,$bfe001
	beq.b getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenal
	move.w #$80,$9c(a2)
	move.w #freq1,$a6(a2)
	move.w #freq2,$b6(a2)
	delay
	move.l #$ad000,$a0(a2)
	move.l #$ad000,$b0(a2)
.czenat
	btst #6,$bfe001
	beq.b getout
	move.w $1e(a2),d0
	and.w #$80,d0
	beq.b .czenat
	move.w #$80,$9c(a2)
	move.w #freq2,$a6(a2)
	move.w #freq1,$b6(a2)
	bra.w mysz
getout
	rts
depblo
	move.l a6,-(a7)
	rem
	lea vectors,a1
	move.w #511,d7
.getvecs
	move.b (a0)+,d0
	move.b d0,d1
	and.b #$f0,d0
	move.b d0,(a1)+
	lsl.b #4,d1
	move.b d1,(a1)+
	dbf d7,.getvecs
	erem

	move.l a0,a4
	lea 1024(a0),a0

	;lea vectors,a4
	lea bufpoi,a5
	lea buffil,a3
	move.l #32767,d7
	moveq #0,d6
	moveq #1,d5
.dekod
	bftst (a0){d6:1}
	beq.w .gotvec
	;addq.l #1,d6
	;bftst (a0){d6:1}
	;bne.b .gotvek
	addq.l #1,d6
	dbf d5,.nofill
	moveq #1,d5
	move.l a6,(a5)+
	st (a6)+	;addq.l #1,a6
	subq.l #1,d7
	bpl.b .dekod
	bra.w .jupod
.nofill
	move.l a6,(a3)+
	st (a6)+	;addq.l #1,a6
	subq.l #1,d7
	bpl.b .dekod
	bra.w .jupod
.gotvek
	addq.l #1,d6
	bftst (a0){d6:1}
	beq.b .lonvek
	addq.l #1,d6
	bftst (a0){d6:1}
	beq.b .vekto5
	addq.l #1,d6
	moveq #0,d0
	bfextu (a0){d6:7},d0
	addq.l #7,d6
	move.l 0(a4,d0.w*8),(a6)+
	moveq #1,d5
	subq.l #4,d7
	bpl.b .dekod
	bra.b .jupod
.vekto5
	addq.l #1,d6
	moveq #0,d0
	bfextu (a0){d6:7},d0
	addq.l #7,d6
	move.l 0(a4,d0.w*8),(a6)+
	move.b 4(a4,d0.w*8),(a6)+
	moveq #1,d5
	subq.l #5,d7
	bpl.b .dekod
	bra.b .jupod
.lonvek
	addq.l #1,d6
	bftst (a0){d6:1}
	beq.b .vekto7
	addq.l #1,d6
	moveq #0,d0
	bfextu (a0){d6:7},d0
	addq.l #7,d6
	move.l 0(a4,d0.w*8),(a6)+
	move.w 4(a4,d0.w*8),(a6)+
	moveq #1,d5
	subq.l #6,d7
	bpl.w .dekod
	bra.b .jupod
.vekto7
	addq.l #1,d6
	moveq #0,d0
	bfextu (a0){d6:7},d0
	addq.l #7,d6
	move.l 0(a4,d0.w*8),(a6)+
	move.l 4(a4,d0.w*8),(a6)
	addq.l #3,a6
	moveq #1,d5
	subq.l #7,d7
	bpl.w .dekod
	bra.b .jupod
.gotvec
	moveq #0,d0
	bfextu (a0){d6:8},d0
	addq.l #8,d6
	move.l 0(a4,d0.w*8),(a6)+
	move.l 4(a4,d0.w*8),(a6)+
	moveq #1,d5
	subq.l #8,d7
	bpl.w .dekod
.jupod
	moveq #7,d0
	and.l d6,d0
	beq.b .nokor
	addq.l #1,a0
.nokor
	lsr.l #3,d6
	add.l d6,a0

	move.l a5,d7
	lea bufpoi,a5
	sub.l a5,d7
	lsr.l #2,d7
	subq.w #1,d7
	bmi.b .nowpoi
	moveq #0,d6
.pewpoi
	move.l (a5)+,a1
	tst.w d6
	beq.b .gorpol
	not.w d6
	lsl.b #4,d0
	move.b d0,(a1)
	dbf d7,.pewpoi
	bra.b .nowpoi
.gorpol
	not.w d6
	move.b (a0)+,d0
	move.b d0,d1
	and.b #$f0,d1
	move.b d1,(a1)
	dbf d7,.pewpoi
.nowpoi

	move.l a3,d7
	lea buffil,a3
	sub.l a3,d7
	lsr.l #2,d7
	subq.w #1,d7
	bmi.b .nointe
.peinte
	move.l (a3)+,a1
	move.b -1(a1),d0
	move.b 1(a1),d1
	ext.w d0
	ext.w d1
	add.w d1,d0
	asr.w #1,d0
	move.b d0,(a1)
	dbf d7,.peinte
.nointe
	move.l (a7)+,a6
	rts
	move.w #32766,d7
	addq.l #1,a6
.filtr
	move.b -1(a6),d0
	move.b (a6),d1
	ext.w d0
	ext.w d1
	sub.w d1,d0
	asr.w #1,d0
	add.w d0,d1
	move.b d1,(a6)+
	dbf d7,.filtr
	rts
.error
	addq.l #8,a7
	rts

vectors	blk.b 128*8,0
bufpoi	blk.l 16384,0
buffil	blk.l 16384,0

