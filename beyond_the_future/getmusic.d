����   &   &   &   &   &   &   &   &   &   &admus	= $120000
docop	= $5e00		;$5840
adr	= $125e00	;$125840
len	= 10000		;190000
numblo	= 29
output	= $180000
quality	= 6
quantso
	move.l #adr,adpak
	lea output,a6
	move.w #docop,d7
	move.w #numblo,(a6)+
	move.w d7,(a6)+
	subq.w #1,d7
	lea admus,a0
.pecopm
	move.b (a0)+,(a6)+
	dbf d7,.pecopm
	moveq #numblo-1,d7
.pepak
	movem.l d7/a6,-(a7)
	move.l adpak,a0
	lea vectors,a1
	move.w #511,d7
.getvecs
	move.b (a0),d0
	ext.w d0
	move.w d0,(a1)+
	add.l #len/520,a0
	dbf d7,.getvecs
	rept 3
	movem.l (a7),d7/a6
	bsr dopasuj
	endr
	movem.l (a7)+,d7/a6
	move.l d7,-(a7)
	lea vectors,a0
	move.w #511,d7
.kazskl
	move.w (a0)+,d0
	move.b d0,(a6)+
	dbf d7,.kazskl
	move.l adpak,a0
	move.l #len/2,d7
.kazbyt
	move.b (a0)+,d0
	extb.l d0
	move.b (a0)+,d1
	extb.l d1
	lea vectors,a2
	move.w #255,d6
	move.w #32767,d4
	sub.l a5,a5
	move.w #quality,a4
.findbest
	move.w (a2)+,d2
	move.w (a2)+,d3
	sub.w d0,d2
	bpl.b .wlazn1
	neg.w d2
.wlazn1
	sub.w d1,d3
	bpl.b .wlazn2
	neg.w d3
.wlazn2
	add.w d3,d2
	cmp.w d4,d2
	bge.b .thisfu
	move.w d2,d4
	move.w a5,d5
	cmp.w a4,d4
	ble.b .gotbest
.thisfu
	addq.w #1,a5
	dbf d6,.findbest
.gotbest
	move.b d5,(a6)+
	subq.l #1,d7
	bne.b .kazbyt
	move.l (a7)+,d7
	add.l #len,adpak
	dbf d7,.pepak
	move.l a6,a0
	rts

dopasuj
	lea newvecs,a0
	moveq #0,d0
	move.w #511,d7
.kasit
	move.l d0,(a0)+
	dbf d7,.kasit
	lea vecnumb,a0
	move.w #255,d7
.kasli
	move.w d0,(a0)+
	dbf d7,.kasli
	move.l adpak,a0
	move.l #len/2,d7
.kazbyt
	move.b (a0)+,d0
	extb.l d0
	move.b (a0)+,d1
	extb.l d1
	lea vecnumb,a1
	lea vectors,a2
	lea newvecs,a3
	move.w #255,d6
	move.w #32767,d4
	moveq #quality,d5
.findbest
	move.w (a2)+,d2
	move.w (a2)+,d3
	sub.w d0,d2
	bpl.b .wlazn1
	neg.w d2
.wlazn1
	sub.w d1,d3
	bpl.b .wlazn2
	neg.w d3
.wlazn2
	add.w d3,d2
	cmp.w d4,d2
	bge.b .thisfu
	move.w d2,d4
	move.l a1,a4
	move.l a3,a6
	cmp.w d5,d4
	ble.b .gotbest
.thisfu
	addq.l #2,a1
	addq.l #8,a3
	dbf d6,.findbest
.gotbest
	subq.l #2,a0
	move.b (a0)+,d2
	extb.l d2
	move.b (a0)+,d3
	extb.l d3
	add.l d2,(a6)+
	add.l d3,(a6)+
	addq.w #1,(a4)
	subq.l #1,d7
	bne.b .kazbyt
	lea newvecs,a0
	lea vecnumb,a1
	lea vectors,a2
	move.w #255,d7
.kazvec
	move.l (a0)+,d0
	move.l (a0)+,d1
	move.w (a1)+,d2
	bne.b .ollok
	moveq #2,d2
	muls.w #$1234,d0
	muls.w #$4321,d1
	ror.w #7,d0
	rol.w #6,d1
.ollok
	divs.w d2,d0
	divs.w d2,d1
	move.w d0,(a2)+
	move.w d1,(a2)+
	dbf d7,.kazvec
	rts
adpak	dc.l 0
vectors	blk.w 256*2,0
vecnumb	blk.w 256,0
newvecs	blk.l 256*2,0
