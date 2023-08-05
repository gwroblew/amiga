����   
   
   
   
   
   
   
   
   
   
numblo	= 2
n	= 65536
logn	= 16
eps	= 0

program
	lea $420000,a0
	lea $120000,a1
	moveq #numblo-1,d7
	sub.l a4,a4
.glope
	movem.l d7-a1,-(a7)
	bsr tryit
	movem.l (a7)+,d7-a1
	add.l #n,a0
	move.l #n-1,d6
	lea bufsour,a2
.przesa
	move.l (a2)+,d0
	move.b d0,(a1)+
	subq.l #1,d6
	bpl.b .przesa
	dbf d7,.glope
	rts

tryit
	lea bufsour,a1
	move.l #n-1,d7
.przep
	move.b (a0)+,d0
	extb.l d0
	move.l d0,(a1)+
	subq.l #1,d7
	bpl.b .przep

	bsr hadam
	lea bufsour,a0
	move.l #n-1,d7
	moveq #eps,d1
	moveq #-eps,d2
	move.l #$babacaca,d6
.filtit
	move.l (a0),d0
	cmp.l d1,d0
	bge.b .wporz
	cmp.l d2,d0
	ble.b .wporz
	moveq #0,d0
	subq.l #1,a4
.wporz
	addq.l #1,a4
	;and.l #$fffffff0,d0
	add.l #$6a6b6c91,d6
	ror.l #7,d6
	move.l d6,d5
	and.l #31,d5
	sub.l #16,d5
	;add.l d5,d0
	move.l d0,(a0)+
	subq.l #1,d7
	bpl.b .filtit

	lea bufsour+4,a0
	lea $110000,a1
	sf (a1)+
	move.l #n-2,d7
.cophar
	move.l (a0)+,d0
	asr.l #1,d0
	move.b d0,(a1)+
	subq.l #1,d7
	bpl.b .cophar
	bsr quantit
	lea bufsour+4,a0
	lea $110001,a1
	move.l #n-2,d7
.cophaq
	move.b (a1)+,d0
	extb.l d0
	add.l d0,d0
	move.l d0,(a0)+
	subq.l #1,d7
	bpl.b .cophaq

hadam
	moveq #logn-1,d7
	moveq #0,d0
	move.l #n/2-1,d6
.kazlog
	move.w d0,d5
	lea bufsour,a0
	lea 4(a0,d6.l*4),a1
.pezew
	move.l d6,d4
	move.l a0,a2
	move.l a1,a3
.maktra
	move.l (a2),d1
	move.l (a3),d2
	move.l d1,d3
	add.l d2,d1
	sub.l d2,d3
	move.l d1,(a2)+
	move.l d3,(a3)+
	subq.l #1,d4
	bpl.b .maktra
	lea 8(a0,d6.l*8),a0
	lea 8(a1,d6.l*8),a1
	dbf d5,.pezew
	addq.w #1,d0
	add.w d0,d0
	subq.w #1,d0
	addq.l #1,d6
	asr.l #1,d6
	subq.l #1,d6
	dbf d7,.kazlog
	lea bufsour,a0
	move.l #n-1,d7
	moveq #logn/2,d1
.suwit
	move.l (a0),d0
	asr.l d1,d0
	move.l d0,(a0)+
	subq.l #1,d7
	bpl.b .suwit

	lea bufsour,a0
	moveq #-1,d0
	moveq #0,d1
	move.l #n/2,d3
	move.l #n-2,d7
.sortit
	addq.l #1,d0
	cmp.l d1,d0
	bge.b .skipxc
	move.l 0(a0,d0.l*4),d4
	move.l 0(a0,d1.l*4),0(a0,d0.l*4)
	move.l d4,0(a0,d1.l*4)
.skipxc
	move.l d3,d2
.pekorr
	cmp.l d1,d2
	bgt.b .outkor
	sub.l d2,d1
	lsr.l #1,d2
	bra.b .pekorr
.outkor
	add.l d2,d1
	cmp.l d7,d0
	blt.b .sortit
	rts

play
	lea $dff000,a6
	move.l #$120000,$a0(a6)
	move.w #$ffff,$a4(a6)
	move.w #160,$a6(a6)
	move.w #64,$a8(a6)
	move.w #$8001,$96(a6)
mysz
	btst #6,$bfe001
	bne.b mysz
	rts

numblok	= 8
blok	= 8192
range	= 256
vector	= 8
qeps	= 16

quantit
	lea $110000,a0
	lea $110000,a1
	moveq #numblok-1,d7
.kazblo
	movem.l d7-a1,-(a7)
	bsr pakit
	add.l d1,toterr
	movem.l (a7)+,d7-a1
	move.l #blok-1,d5
	lea $580000,a2
.przew
	move.w (a2)+,d0
	move.b d0,(a1)+
	subq.l #1,d5
	bpl.b .przew
	lea blok(a0),a0
	dbf d7,.kazblo
	rts

pakit
	lea $580000,a1
	lea $540000,a3
	move.l #blok,d7
.przep
	move.b (a0)+,d0
	ext.w d0
	move.w d0,(a1)+
	and.w #$fff0,d0
	move.w d0,(a3)+
	subq.l #1,d7
	bpl.b .przep

	lea $580000,a0
	lea bufvec,a1
	move.w #range+vector-1,d7
.copvec
	move.w (a0)+,(a1)+
	dbf d7,.copvec
	move.l a0,souvec

	rept 4
	bsr matchvecs
	endr

	lea $580000,a0
	move.w #blok/vector-1,d7
	moveq #0,d1
.kazvec
	lea bufvec,a1
	move.w #range-1,d6
	move.l #30000,d5
.trykaz
	move.l a0,a2
	move.l a1,a3
	moveq #vector-1,d4
	moveq #0,d3
.sumerr
	move.w (a2)+,d0
	sub.w (a3)+,d0
	bpl.b .noneg
	neg.w d0
.noneg
	add.w d0,d3
	dbf d4,.sumerr
	cmp.w d3,d5
	ble.b .nonew
	move.w d3,d5
	move.l a1,a6
.nonew
	addq.l #2,a1
	dbf d6,.trykaz
	add.l d5,d1
	moveq #vector-1,d6
	cmp.w #qeps*vector,d5
	ble.b .dodit
	sub.l d5,d1
	move.l a0,a6
	sub.l #$40000,a6
	addq.l #vector/2,totlen
.dodit
	move.w (a6)+,(a0)+
	dbf d6,.dodit
	addq.l #1,totlen
.pofak
	dbf d7,.kazvec
	rts

matchvecs
	lea bufnum,a0
	lea bufsum,a1
	move.w #range+vector-1,d7
	moveq #0,d0
.kazit
	move.w d0,(a0)+
	move.l d0,(a1)+
	dbf d7,.kazit
	lea $580000,a0
	move.w #blok/vector-1,d7
	moveq #0,d1
.kazvec
	lea bufvec,a1
	move.w #range-1,d6
	move.l #30000,d5
.trykaz
	move.l a0,a2
	move.l a1,a3
	moveq #vector-1,d4
	moveq #0,d3
.sumerr
	move.w (a2)+,d0
	sub.w (a3)+,d0
	bpl.b .noneg
	neg.w d0
.noneg
	add.w d0,d3
	dbf d4,.sumerr
	cmp.w d3,d5
	ble.b .nonew
	move.w d3,d5
	move.l a1,a6
.nonew
	addq.l #2,a1
	dbf d6,.trykaz
	add.l d5,d1
	lea bufnum-bufvec(a6),a3
	sub.l #bufvec,a6
	add.l a6,a6
	add.l #bufsum,a6
	moveq #vector-1,d6
.dodit
	move.w (a0)+,d0
	ext.l d0
	add.l d0,(a6)+
	addq.w #1,(a3)+
	dbf d6,.dodit
	dbf d7,.kazvec
	lea bufvec,a0
	lea bufnum,a1
	lea bufsum,a2
	move.l souvec,a3
	move.w #range+vector-2,d7
.robvec
	move.l (a2)+,d0
	move.w (a1)+,d1
	bne.b .mozdzi
	move.w (a3)+,(a0)+
	dbf d7,.robvec
	bra.b .porove
.mozdzi
	divs.w d1,d0
	move.w d0,(a0)+
	dbf d7,.robvec
.porove
	move.l a3,souvec
	rts

	align 4,4
totlen	dc.l 0
toterr	dc.l 0
souvec	dc.l 0
bufvec	blk.w range+vector,0
bufnum	blk.w range+vector,0
bufsum	blk.l range+vector,0
bufsour	blk.l n,0
