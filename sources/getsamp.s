����  �  Hs  9���ܧ��ܧ��ܧ��ܧ��ܧ��ܧ	r�;;;;;;;;;;;;;;;;;;;;;;;;;;;
ad	= $300000

int	macro
\10	dc.w \2
\1	= \10-vars
	endm
long	macro
\10	dc.l \2
\1	= \10-vars
	endm
callexec macro
	move.l 4.w,a6
	move.l a5,-(a7)
	jsr \1(a6)
	move.l (a7)+,a5
	endm
calldos	macro
	move.l dosbase(a5),a6
	move.l a5,-(a7)
	jsr \1(a6)
	move.l (a7)+,a5
	endm
openlib	macro
	lea .lname\@,a1
	callexec -408
	move.l d0,\1base(a5)
	bra.s .dalej\@
.lname\@ dc.b \2,".library",0
	even
.dalej\@
	endm

	lea vars,a5
	openlib dos,"dos"
	move.l #fname,d1
	move.l #1005,d2
	calldos -30
	tst.l d0
	bne.s .noloa
	rts
.noloa
	move.l d0,fhandle(a5)
	rept 2
	move.l fhandle(a5),d1
	move.l #ad,d2
	move.l #700000,d3
	calldos -42
	move.l d0,d7
	endr
	move.l fhandle(a5),d1
	calldos -36
	rts

fname	dc.b "dontask.smp",0
	even

vars
	long dosbase,0
	long fhandle,0
