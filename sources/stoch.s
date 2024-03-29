����                                        block	= 8192
bits	= 4
start
	lea $380000,a4
	lea $480000,a5
	moveq #512/8-1,d5
	moveq #0,d4
.kazblo
	move.l a4,a0
	move.l a5,a1
	bsr makeblock
	;add.l d0,d4
	add.l #block,a4
	add.l #block,a5
	;dbf d5,.kazblo
	rts
makeblock
	move.l a1,-(a7)
	lea $400000,a1
	move.l #block,d7
.conv
	move.b (a0)+,d0
	add.b #128,d0
	lsr.b #bits,d0
	and.b #7,d0
	move.b d0,(a1)+
	subq.l #1,d7
	bne.s .conv
	lea $400000,a0
	move.l a0,a1
	move.l #block,d7
	;bsr makediff
	lea $400000,a0
	lea $140000,a1
	move.l #block,d7
	bsr makestat
	lea $400000,a0
	lea $140000,a1
	lea $120000,a2
	move.l #block,d7
	bsr transs

	lea $120000,a0
	move.l #block-1,d7
	;bsr filtr
	bsr paker
	add.l d3,d4

	addq.l #4,a7
	rts
	move.b $400000,d0
	lea $140000,a1
	lea $120000,a0
	lea $410000,a2
	move.l #block-1,d7
	bsr itranss
	move.l (a7)+,a1
	lea $410000,a0
	move.l #block,d7
.deconv
	move.b (a0)+,d0
	lsl.b #bits,d0
	sub.b #128,d0
	move.b d0,(a1)+
	subq.l #1,d7
	bne.s .deconv

	lea $120000,a0
	moveq #0,d0
	move.l #block-1,d7
.liczer
	tst.b (a0)+
	bne.s .nosss
	addq.l #1,d0
.nosss
	subq.l #1,d7
	bne.s .liczer
	rts

makediff
	subq.l #1,d7
.godif
	move.b (a0)+,d0
	sub.b (a0),d0
	move.b d0,(a1)+
	subq.l #1,d7
	bne.s .godif
	rts
itranss
	move.b d0,(a2)+
	and.w #255,d0
.petla
	move.b (a0)+,d1
	add.b 0(a1,d0.w),d1
	move.b d1,(a2)+
	move.b d1,d0
	subq.l #1,d7
	bne.s .petla
	rts
filtr
	cmp.b #1,(a0)
	beq.s .dofilt
	cmp.b #-1,(a0)
	bne.s .nofilt
.dofilt
	move.b #0,(a0)
.nofilt
	addq.l #1,a0
	subq.l #1,d7
	bne.s filtr
	rts
transs
	subq.l #2,d7
.pet
	move.b (a0)+,d0
	add.b 1(a0),d0
	asr.b #1,d0
	sub.b (a0),d0
	move.b d0,(a2)+
	subq.l #1,d7
	bne.s .pet
	rts
	moveq #0,d0
	subq.l #1,d7
.tryit
	move.b (a0)+,d0
	move.b (a0),d1
	sub.b 0(a1,d0.w),d1
	move.b d1,(a2)+
	subq.l #1,d7
	bne.s .tryit
	rts
makestat
	lea locbuf,a2
	move.w #16383,d6
	moveq #0,d0
.zerbuf
	move.l d0,(a2)+
	move.l d0,(a2)+
	move.l d0,(a2)+
	move.l d0,(a2)+
	dbf d6,.zerbuf
	lea locbuf,a2
	subq.l #1,d7
.doit
	move.w (a0),d0
	addq.l #1,0(a2,d0.l*4)
	addq.l #1,a0
	subq.l #1,d7
	bne.s .doit
	move.w #255,d7
	lea locbuf,a2
.zewpet
	moveq #0,d1
	move.w #255,d6
	moveq #0,d2
	move.l #$7f007f,d3
.wewpet
	cmp.l (a2)+,d1
	bhs.s .lamer
	move.l -4(a2),d1
	swap d3
	move.w d2,d3
.lamer
	addq.w #1,d2
	dbf d6,.wewpet
	;swap d3
	move.b d3,(a1)+
	dbf d7,.zewpet
	rts
locbuf	= $500000

paker
	moveq #0,d3
.lp
	lea strings,a2
.petry
	moveq #0,d0
	move.b (a2)+,d0
	move.l d0,d1
	cmp.l d0,d7
	bhs.w .jesens

.jesens
	move.l a0,a1
	subq.w #1,d0
.porow
	cmpm.b (a1)+,(a2)+
	bne.s .rozne
	dbf d0,.porow
	moveq #0,d0
	move.b (a2)+,d0
	add.l d0,d3
	move.l a1,a0
	sub.l d1,d7
	bne.s .lp
.rozne
	add.w d0,a2
	addq.l #1,a2
	cmp.b #-1,(a2)
	bne.s .petry
	add.l #4,d3
	addq.l #1,a0
	subq.l #1,d7
	bne.s .lp
	lsr.l #3,d3
	addq.l #1,d3
	rts

o	= -1
;strings
	dc.b 4,0,0,0,0,4		; 0000
	dc.b 4,0,0,0,1,4		; 0001
	dc.b 4,0,0,0,o,4		; 0010
	dc.b 4,0,1,0,1,4		; 0011
	dc.b 4,o,1,o,1,4		; 0100
	dc.b 4,0,o,0,o,4		; 0101
	dc.b 4,1,1,0,0,4		; 0110
	dc.b 4,0,0,o,o,4		; 0111
	dc.b 4,1,1,o,o,4		; 1000
	dc.b 4,1,o,0,1,4		; 1001
	dc.b 4,0,o,0,1,4		; 1010
	dc.b 4,1,0,0,1,4		; 1011
	dc.b -1

	; powtarzanie !
strings
	dc.b 6,0,0,0,0,0,0,3		; 000
	dc.b 5,0,0,0,0,0,3		; 001
	dc.b 4,0,0,0,0,3		; 010
	dc.b 3,0,0,0,3			; 011
	dc.b 3,1,1,1,4			; 1000
	dc.b 3,o,o,o,4			; 1001
	dc.b 2,0,0,3			; 101
	dc.b -1

	; non 9
	dc.b 8,0,0,0,0,0,0,0,0,3	; 001
	dc.b 7,0,0,0,0,0,0,0,3		; 010
	dc.b 6,0,0,0,0,0,0,3		; 011
	dc.b 5,0,0,0,0,0,4		; 1000
	dc.b 4,0,0,0,0,4		; 1001
	dc.b 3,0,0,0,3			; 000
	dc.b 3,1,1,1,4			; 1010
	dc.b 3,o,o,o,4			; 1011
	dc.b 2,0,0,5			; 11000
	dc.b 2,1,1,5			; 11001
	dc.b 2,o,o,5			; 11010
	dc.b 2,0,1,5			; 11011
	dc.b 2,1,0,5			; 11100
	dc.b 2,1,o,5			; 11101
	dc.b 2,o,1,6			; 111100
	dc.b 2,0,o,6			; 111101
	dc.b 2,o,0,6			; 111110
	dc.b -1

