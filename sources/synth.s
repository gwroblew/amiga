����                                        program:
	lea word,a4
	lea $1c0000,a6
	lea tonearr,a3
.mainlp
	movem.w (a4)+,d0-d3
	lsl.w #4,d0
	subq.w #1,d1
	bmi .nothcp
.copclp
	move.l 0(a3,d0.w),a0
	move.l 4(a3,d0.w),d4
	subq.w #1,d4
.copper
	move.b (a0)+,d5
	ext.w d5
	muls.w d2,d5
	asr.w #8,d5
	move.b d5,(a6)+
	dbf d4,.copper
	dbf d1,.copclp
.nothcp
	subq.w #1,d3
	bmi .endsyn
	move.w (a4),d1
	lsl.w #4,d1
	move.l 4(a3,d0.w),d5
	move.l 4(a3,d1.w),d4
	sub.l d5,d4
	addq.w #2,d3
	move.w d3,.divide
	move.w d3,.weigh1
	subq.w #1,.weigh1
	move.w #1,.weigh2
	lsl.l #8,d4
	divs.w d3,d4
	ext.l d4
	subq.w #2,d3
	lsl.l #8,d5
	add.l d4,d5
.morplp
	move.l 0(a3,d0.w),a0
	lea buffer1,a1
	move.l 4(a3,d0.w),d6
	move.l d5,d7
	lsr.l #8,d7
	bsr resize
	move.l 0(a3,d1.w),a0
	lea buffer2,a1
	move.l 4(a3,d1.w),d6
	move.l d5,d7
	lsr.l #8,d7
	bsr resize
	lea buffer1,a0
	lea buffer2,a1
	move.l d5,d6
	lsr.l #8,d6
	subq.w #1,d6
	movem.l d0-d1,-(a7)
.medilp
	move.b (a0)+,d0
	move.b (a1)+,d1
	ext.w d0
	ext.w d1
	muls.w .weigh1(pc),d0
	muls.w .weigh2(pc),d1
	divs.w .divide(pc),d0
	divs.w .divide(pc),d1
	add.w d1,d0
	cmp.w #127,d0
	ble.s .notgor
	moveq #127,d0
.notgor
	cmp.w #-127,d0
	bge.s .notdol
	moveq #-127,d0
.notdol
	move.b d0,(a6)+
	dbf d6,.medilp
	movem.l (a7)+,d0-d1
	add.l d4,d5
	addq.w #1,.weigh2
	subq.w #1,.weigh1
	dbf d3,.morplp
	bra .mainlp
.endsyn
	move.l a6,d0
	sub.l #$1c0000,d0
	lsr.l #1,d0
	move.l #$1c0000,$dff0a0
	move.w d0,$dff0a4
	move.w #64,$dff0a8
	move.w #174,$dff0a6
	move.w #$8001,$dff096
.wlmp
	btst #6,$bfe001
	bne.s .wlmp
	move.w #15,$dff096
	rts
.divide	dc.w 0
.weigh1	dc.w 0
.weigh2	dc.w 0

resize
	move.l d0,-(a7)
	lsl.l #8,d6
	divs.w d7,d6
	ext.l d6
	moveq #0,d0
	subq.w #1,d7
.reslp
	ror.l #8,d0
	move.b 0(a0,d0.w),(a1)+
	rol.l #8,d0
	add.l d6,d0
	dbf d7,.reslp
	move.l (a7)+,d0
	rts

morph

word

	dc.w 0,2,256,1
	dc.w 2,10,256,2
	dc.w 1,16,256,2
	dc.w 2,10,256,2
	dc.w 1,16,256,4
	dc.w 0,2,256,0

	dc.w 0,2,256,1
	dc.w 2,6,256,2
	dc.w 1,10,256,2
	dc.w 4,8,256,4
	dc.w 8,6,256,6
	dc.w 9,10,256,4
	dc.w 0,2,256,0

	dc.w 0,2,256,3
	dc.w 7,6,256,3
	dc.w 1,10,256,3
	dc.w 5,8,256,8
	dc.w 1,10,256,6
	dc.w 0,2,256,0

	dc.w 0,2,256,3
	dc.w 7,3,256,6
	dc.w 1,4,256,4
	dc.w 5,3,256,8
	dc.w 1,5,256,6
	dc.w 0,2,256,0

tonearr	dc.l silence,tone_a-silence,morph,0
	dc.l tone_a,tone_b-tone_a,morph,0
	dc.l tone_b,tone_e-tone_b,morph,0
	dc.l tone_e,tone_g-tone_e,morph,0
	dc.l tone_g,tone_i-tone_g,morph,0
	dc.l tone_i,tone_k-tone_i,morph,0
	dc.l tone_k,tone_m-tone_k,morph,0
	dc.l tone_m,tone_n-tone_m,morph,0
	dc.l tone_n,tone_o-tone_n,morph,0
	dc.l tone_o,endtone-tone_o,morph,0

silence	blk.b 190,0
tone_a	include "patt_a.i"
tone_b	include "patt_b.i"
tone_e	include "patt_e.i"
tone_g	include "patt_g.i"
tone_i	include "patt_i.i"
tone_k	include "patt_k.i"
tone_m	include	"patt_m.i"
tone_n	include	"patt_n.i"
tone_o	include "patt_o.i"

endtone

buffer1	ds.b	8192
buffer2	ds.b	8192
