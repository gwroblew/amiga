����   �   �   �   �   �   �   �   �   �   �	lea $dff000,a6
	move.l #$120000,$a0(a6)
	move.w #$8000,$a4(a6)
	move.w #160,$a6(a6)
	move.w #64,$a8(a6)
	move.w #$8001,$96(a6)
mysz
	btst #6,$bfe001
	bne.b mysz
	rts
len	= 1024
eps	= 16
setvec	macro
	move.w #\1-1,vector
	endm

program
	lea $120000,a0
	moveq #63,d7
.blok
	movem.l d7-a0,-(a7)
	move.l a0,kupa
	lea bufor,a1
	move.w #len-1,d7
.prep
	move.b (a0)+,d0
	ext.w d0
	move.w d0,(a1)+
	dbf d7,.prep

	setvec 8
	bsr initpoi
	bsr findbest
	bsr markit
	movem.l (a7)+,d7-a0
	lea 1024(a0),a0
	dbf d7,.blok
	rts

getmap
	lea bufor,a0
	lea poitab,a1
	move.w #0,numpoi
	move.w #len-2,d7
	sub.w vector,d7
	move.w #$aaaa,d0
.teskav
	move.l a0,a2
	move.w vector,d6
.calwek
	cmp.w (a2)+,d0
	beq.b .thisout
	dbf d6,.calwek
	move.l a0,(a1)+
	addq.w #1,numpoi
.thisout
	addq.l #2,a0
	dbf d7,.teskav
	rts
initpoi
	lea bufor,a0
	lea poitab,a1
	move.w #len-2,d7
	sub.w vector,d7
	move.w #0,numpoi
.inipoi
	move.l a0,(a1)+
	addq.l #2,a0
	addq.w #1,numpoi
	dbf d7,.inipoi
	rts
markit
	lea bufvec,a0
	move.w vector,d7
	move.w vector,d0
	addq.w #1,d0
	muls #eps,d0
	move.w d0,.selfp1+2
.przep
	move.w (a6)+,(a0)+
	dbf d7,.przep
	lea poitab,a4
	move.l (a4)+,a0
	move.w numpoi,d3
	subq.w #1,d3
	lea bufvec,a1
	moveq #0,d4
	move.l kupa,a5
.kazprob
	move.w vector,d6
	move.l a0,a2
	move.l a1,a3
	moveq #0,d5
.licodl
	move.w (a2)+,d1
	sub.w (a3)+,d1
	bpl.b .noneg
	neg.w d1
.noneg
	cmp.w #eps*2,d1
	bge.b .tennie
	add.w d1,d5
	dbf d6,.licodl
.selfp1
	cmp.w #eps*8,d5
	bge.b .tennie
	move.l a0,a2
	move.l a1,a3
	move.w vector,d6
	move.w #$aaaa,d1
.filpas
	move.w d1,(a2)+
	move.w (a3)+,d0
	move.b d0,(a5)+
	dbf d6,.filpas
	addq.w #1,d4
	move.w vector,d1
	addq.w #1,d1
	add.w d1,d1
	add.w d1,a0
.pedopa
	cmp.l (a4),a0
	ble.b .tennie
	addq.l #4,a4
	dbf d3,.pedopa
	bra.b .konkon
.tennie
	move.l (a4)+,a0
	move.l a0,d0
	sub.l #bufor,d0
	lsr.l #1,d0
	add.l kupa,d0
	move.l d0,a5
	dbf d3,.kazprob
.konkon
	rts

findbest
	lea poitab,a4
	move.l (a4)+,a0
	move.w numpoi,d3
	subq.w #1,d3
	moveq #0,d2
	move.w vector,d0
	addq.w #1,d0
	muls #eps,d0
	move.w d0,.selfp1+2
.kazprob
	lea poitab,a5
	move.l (a5)+,a1
	move.w numpoi,d7
	subq.w #1,d7
	moveq #0,d4
.kazwar
	move.w vector,d6
	move.l a0,a2
	move.l a1,a3
	moveq #0,d5
.licodl
	move.w (a2)+,d1
	sub.w (a3)+,d1
	bpl.b .noneg
	neg.w d1
.noneg
	cmp.w #eps*2,d1
	bge.b .tennie
	add.w d1,d5
	dbf d6,.licodl
.selfp1
	cmp.w #eps*8,d5
	bge.b .tennie
	addq.w #1,d4
	move.w vector,d1
	addq.w #1,d1
	add.w d1,d1
	add.w d1,a1
.pedopa
	cmp.l (a5),a1
	ble.b .tennie
	addq.l #4,a5
	dbf d7,.pedopa
	bra.b .konszu
.tennie
	move.l (a5)+,a1
	dbf d7,.kazwar
.konszu
	cmp.w d4,d2
	bge.b .isgors
	move.w d4,d2
	move.l a0,a6
.isgors
	move.l (a4)+,a0
	dbf d3,.kazprob
	rts
numpoi	dc.w 0
vector	dc.w 0
	align 4,4
bufor	blk.w len+8,0
bufvec	blk.w 32,0
poitab	blk.l len,0
kupa	dc.l 0
