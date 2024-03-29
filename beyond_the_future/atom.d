����  u� E	  �� �M N*                    ;;;;;;;;;;;;;;;
;UWAGA na $dff1fc
;ondisk	= 0
fapicin	macro
	moveq #\1,d0
	jsr dopicin
	endm
fapicout macro
	moveq #\1,d0
	jsr dopicout
	endm
depakmus macro
	lea \1,a0
	lea \2,a1
	jsr depmus
	endm
shadeon	macro
	move.w #\1,shadsped(a5)
	st shadflag(a5)
	endm
shadeoff macro
	sf shadflag(a5)
	endm
setplasm macro
	move.w #\1,plasmcol(a5)
	move.w #\2,plasmp1(a5)
	move.w #\3,plasmp2(a5)
	move.w #\4,plasmp3(a5)
	move.w #\5,plasmp4(a5)
	move.w #\6,plasmp5(a5)
	move.w #\7,plasmp6(a5)
	move.l #\8,plasmp7(a5)
	move.l #\9,plasmp8(a5)
	st plasmflag(a5)
	endm
plasmoff macro
	sf plasmflag(a5)
	endm
setproc	macro
	move.l #\1,extproc(a5)
	endm
procoff	macro
	move.l #0,extproc(a5)
	endm
waveon	macro
	move.w #\1,waveobj(a5)
	st waveflag(a5)
	bsr initwave
	endm
waveoff	macro
	sf waveflag(a5)
	endm
GetBits	macro
	move.w	d6,d0
	lsr.l	d1,d6
	sub.w	d1,d7
	bgt.s	.GBNoLoop\@
	add.w	d3,d7
	ror.l	d7,d6
	move.w	-(a2),d6
	rol.l	d7,d6
.GBNoLoop\@
	and.w	0(a0,d1.w*2),d0
	endm
BitTest	macro
	subq.w	#1,d7
	bne.s	.BTNoLoop\@
	moveq	#16,d7
	move.w	d6,d0
	lsr.l	d5,d6
	swap	d6
	move.w	-(a2),d6
	swap	d6
	lsr.w	d5,d0
	bra.s .dodat\@
.BTNoLoop\@
	lsr.l	d5,d6
.dodat\@
	endm
addcrtext macro
\1_ct	incbin \1.cmtext
	endm
decrtext macro
	lea \1_ct,a0
	lea pictures,a1
	jsr NormalDecrunch
	lea pictures,a0
	moveq #\2-1,d0
	jsr instext
	endm
decrunch macro
	move.l \1,a0
	move.l \2,a1
	jsr NormalDecrunch
	endm
getcrdata macro
	subq.w #1,decrrep(a5)
	bmi.b .nexent\@
	move.w repdata(a5),d0
	tst.w decrflag(a5)
	bpl.b .gotdata\@
	move.w (a1)+,d0
	bra.b .gotdata\@
.nexent\@
	move.b (a1)+,d0
	move.b d0,decrflag(a5)
	and.w #$7f,d0
	subq.w #1,d0
	move.w d0,decrrep(a5)
	move.w (a1)+,d0
	move.w d0,repdata(a5)
.gotdata\@
	endm
setdbar	macro
	move.w #\1,barcol(a5)
	move.w #\2,bascol(a5)
	move.w #-1,barflag(a5)
	endm
setbar	macro
	move.w #\1,barcol(a5)
	st barflag(a5)
	endm
baroff	macro
	move.w #0,barflag(a5)
	endm
clearc	macro
	movec cacr,d0
	tst.w d0
	bmi.b .circ_40\@
	or.w #$808,d0
	movec d0,cacr
	bra.b .circ_exit\@
.circ_40\@
	cpusha ic
	cpusha dc
.circ_exit\@
	endm
gettext	macro
	moveq #\1,d0
	bsr getscreen
	endm
morph	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #15,(a0)+
	move.w #\1,(a0)+
	move.w #\2,(a0)+
	bsr morphinit
	addq.w #1,nument(a5)
	endm
starson	macro
	st starsflag(a5)
	endm
starsoff macro
	sf starsflag(a5)
	endm
setback	macro
	move.l #\1,background(a5)
	endm
backoff	macro
	move.l #0,background(a5)
	endm
freeze	macro
	bsr dofreeze
	st frezflag(a5)
	endm
unfreeze macro
	sf frezflag(a5)
	endm
fuckin	macro
	move.w #\1,fadop(a5)
	move.w #0,fadfaz(a5)
	st isfuck(a5)
	move.l #dofuckin,inter(a5)
	endm
fuckout	macro
	move.w #\1,fadop(a5)
	move.w #16,fadfaz(a5)
	st isfuck(a5)
	move.l #dofuckout,inter(a5)
	endm
fuckoff	macro
	sf isfuck(a5)
	endm
fadein	macro
	moveq #\1,d0
	move.w #\2,d1
	jsr dofadein
	endm
fadeout	macro
	moveq #\1,d0
	move.w #\2,d1
	jsr dofadeout
	endm
waitmous macro
.wrmo\@
	btst #2,$dff016
	bne.b .wrmo\@
	endm
trans	macro
.pemov\@
	move.\4 \1,\2
	dbf \3,.pemov\@
	endm
wait	macro
	move.w #\1,czas(a5)
.wycpe\@
	btst #6,$bfe001
	beq.l exit
	tst.w czas(a5)
	bne.b .wycpe\@
	endm
showiff	macro
	jsr showit
	endm
getiff	macro
	lea \1,a0
	jsr depakiff
	endm
addiff	macro
	align 4,4
\1	incbin \2
	endm
addbackground macro
	align 4,4
\1	incbin \2
	endm
forcshad macro
	move.l #drtext,tabdraw+4
	move.l #drshad,tabdraw+12
	endm
normdraw macro
	move.l #drtexf,tabdraw+4
	move.l #drflat,tabdraw+12
	move.l #drtext,tabdraw
	move.l #drshad,tabdraw+8
	endm
setflat	macro
	move.l #drtexf,tabdraw
	move.l #drflat,tabdraw+8
	endm
setshad	macro
	move.l #drtext,tabdraw
	move.l #drshad,tabdraw+8
	endm
setmode	macro
	cmp.w #\1,trueflag(a5)
	beq.b .pococh\@
	move.w #\1,trueflag(a5)
	jsr setgmode
.pococh\@
	endm
stoptime macro
	move.w ttime(a5),ttime_s(a5)
	st stopped(a5)
	endm
starttime macro
	tst.w stopped(a5)
	beq.b .wonts\@
	move.w ttime_s(a5),ttime(a5)
	sf stopped(a5)
.wonts\@
	endm
closelib macro
	move.l \1base(a5),a1
	cmp.l #0,a1
	beq.b .whatsup\@
	callexec -414
.whatsup\@
	endm
openlib	macro
	lea .libnam\@,a1
	callexec -408
	move.l d0,\2base(a5)
	bra.b .daleo\@
.libnam\@ dc.b "\1.library",0
	even
.daleo\@
	endm
calldos	macro
	push a5
	move.l dosbase(a5),a6
	jsr \1(a6)
	pop a5
	endm
callgfx	macro
	push a5
	move.l gfxbase(a5),a6
	jsr \1(a6)
	pop a5
	endm
callexec macro
	push a5
	move.l 4.w,a6
	jsr \1(a6)
	pop a5
	endm
waitpat	macro
	tst.w music(a5)
	beq.b .nomup\@
	ifnc \2,''
	stoptime
	endc
.waipat\@
	ifc \2,''
	doit 5
	else
	ifnd ondisk
	btst #6,$bfe001
	beq.l exit
	endif
	endc
	cmp.w #\1*4,mt_PatternPos
	blt.b .waipat\@
	ifnc \2,''
	starttime
	endc
.nomup\@
	endm
waitpos	macro
	tst.w music(a5)
	beq.b .nomus\@
	ifnc \2,''
	stoptime
	endc
.waipet\@
	ifc \2,''
	doit 5
	else
	ifnd ondisk
	btst #6,$bfe001
	beq.l exit
	endif
	endc
	cmp.b #\1,mt_SongPos
	blt.b .waipet\@
	ifnc \2,''
	starttime
	endc
.nomus\@
	endm
addmusic macro
	align 4,4
\1	incbin \2
	endm
musicon	macro
	st music(a5)
	move.w #128,mt_percent
	endm
musicoff macro
	sf music(a5)
	endm
musicstop macro
	sf music(a5)
	jsr mt_end
	endm
musicfade macro
	stoptime
	moveq #127,d7
.pefad\@
	subq.w #1,mt_percent
	move.w #\1,czas(a5)
.pewai\@
	tst.w czas(a5)
	bne.b .pewai\@
	dbf d7,.pefad\@
	sf music(a5)
	bsr mt_end
	starttime
	endm
setmusic macro
	move.l #\1,mt_data(a5)
	push a5
	jsr mt_init
	pop a5
	endm
setshadow macro
	lea objtab+64*\1(a5),a0
	move.l _surfaces(a0),a0
	moveq #\2-1,d7
	bmi.b .noskis\@
.skipd\@
	move.w (a0),d0
	mulu #6,d0
	lea 6(a0,d0.w),a0
	dbf d7,.skipd\@
.noskis\@
	move.w #5,2(a0)
	move.w #\3*128+127,4(a0)
	endm
setmirror macro
	lea objtab+64*\1(a5),a0
	move.l _surfaces(a0),a0
	moveq #\2-1,d7
	bmi.b .noskip\@
.skips\@
	move.w (a0),d0
	mulu #6,d0
	lea 6(a0,d0.w),a0
	dbf d7,.skips\@
.noskip\@
	move.w #4,2(a0)
	move.w #\3*128+127,4(a0)
	endm
mapflat	macro
	moveq #\1,d0
	move.w #\2,d2
	move.w #\3,d3
	move.w #\4,d4
	move.w #\5,d5
	bsr mapit3
	endm
mapsphere4 macro
	moveq #\1,d0
	moveq #\2,d1
	moveq #\3,d2
	moveq #\4,d3
	bsr mapit2
	endm
mapsphere macro
	moveq #\1,d0
	moveq #\2,d1
	moveq #\3,d2
	moveq #\4,d3
	bsr mapit1
	endm
animon	macro
	lea anstruct\1,a0
	move.l a0,arranims+(4*\1)(a5)
	move.w ttime(a5),8(a0)
	addq.l #1,numanims(a5)
	bsr initanim
	endm
animoff	macro
	move.l #0,arranims+(4*\1)(a5)
	subq.l #1,numanims(a5)
	endm
addanim	macro
anstruct\1:
	dc.w \2,\3-1,\4,0,0,0
	dc.l 0,.andata\@,.nextan\@
.andata\@
	incbin \5
.nextan\@
	endm
objon	macro
	move.l scene(a5),a0
	sf \1*32+28(a0)
	endm
objoff	macro
	move.l scene(a5),a0
	st \1*32+28(a0)
	endm
movls	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #12,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
rotl	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #11,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movl	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #10,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movcs	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
;	ifnc '\8',''
;	move.l #5,(a0)+
;	else
	move.l #$90000,(a0)+
;	endc
	ifnc '\1',''
	move.l #\1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
rotct	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	lea ang_o(a5),a1
	moveq #0,d0
	move.l #$80000,(a0)+
	ifnc '\1',''
	move.l (a1)+,d1
	sub.l #\1,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l (a1)+,d1
	sub.l #\2,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l (a1)+,d1
	sub.l #\3,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	endm
rotc	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.l #$80000,(a0)+
	ifnc '\1',''
	move.l #\1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movct	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	lea ang_o(a5),a1
	lea move_o(a5),a2
	moveq #0,d0
	move.l #$70000,(a0)+
	ifnc '\1',''
	move.l #\1,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l #\2,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,d1
	sub.l (a2)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,d1
	sub.l (a2)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,d1
	sub.l (a2)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movcf	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	ifnc '\7',''
	move.l #$e0000,(a0)+
	else
	move.l #$d0000,(a0)+
	endc
	ifnc '\1',''
	move.l #\1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movc	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.l #$70000,(a0)+
	ifnc '\1',''
	move.l #\1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
rotos	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #6,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
rotost	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	move.l scene(a5),a1
	lsl.w #5,d0
	add.w d0,a0
	lea 4(a1,d0.w),a1
	moveq #0,d0
	move.w #6,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l (a1)+,d1
	sub.l #\2,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
setcam	macro
	ifnc '\1',''
	move.l #\1,ang_o(a5)
	endc
	ifnc '\2',''
	move.l #\2,ang_o+4(a5)
	endc
	ifnc '\3',''
	move.l #\3,ang_o+8(a5)
	endc
	ifnc '\4',''
	move.l #\4,move_o(a5)
	endc
	ifnc '\5',''
	move.l #\5,move_o+4(a5)
	endc
	ifnc '\6',''
	move.l #\6,move_o+8(a5)
	endc
	endm
movos	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	ifnc '\8',''
	move.w #5,(a0)+
	else
	move.w #4,(a0)+
	endc
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
setpower macro
	move.l lights(a5),a0
	moveq #\1,d0
	lsl.w #5,d0
	lea 0(a0,d0.w),a0
	move.l #\2,(a0)
	endm
setlight macro
	move.l lights(a5),a0
	moveq #\1,d0
	lsl.w #5,d0
	lea 4(a0,d0.w),a0
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\8',''
	move.l #\8,(a0)
	endc
	endm
setobj	macro
	move.l scene(a5),a0
	moveq #\1,d0
	lsl.w #5,d0
	lea 4(a0,d0.w),a0
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	addq.l #4,a0
	endc
	ifnc '\8',''
	move.l #\8,(a0)
	endc
	endm
addobject macro
	dc.l .skiploc\@
	align 4,4
.skiploc\@
	dc.l \1,\2,\3,\4,\5,\6
	ifnc '\7',''
	include \7
	endc
	endm
setscene macro
	move.l #\1,scene(a5)
	move.l #\1_l,lights(a5)
	bsr preplights
	endm
altsoff	macro
	move.l #0,ascene(a5)
	move.l #0,alights(a5)
	endm
setalts macro
	move.l scene(a5),-(a7)
	move.l lights(a5),-(a7)
	move.l #\1,scene(a5)
	move.l #\1_l,lights(a5)
	bsr preplights
	move.l #\1,ascene(a5)
	move.l #\1_l,alights(a5)
	move.l (a7)+,scene(a5)
	move.l (a7)+,lights(a5)
	endm
doit	macro
	move.w #\1,d0
	bsr runit
	endm
movof	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	ifnc '\8',''
	move.w #2,(a0)+
	else
	move.w #1,(a0)+
	endc
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
roto	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w #3,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	endm
rotot	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	move.l scene(a5),a1
	lsl.w #5,d0
	add.w d0,a0
	lea 4(a1,d0.w),a1
	moveq #0,d0
	move.w #3,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l (a1)+,d1
	sub.l #\2,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l (a1)+,d1
	sub.l #\3,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l (a1)+,d1
	sub.l #\4,d1
	move.l d1,(a0)+
	else
	move.l d0,(a0)+
	endc
	endm
movo	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	lsl.w #5,d0
	add.w d0,a0
	moveq #0,d0
	move.w d0,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,(a0)+
	else
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,(a0)+
	else
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
movot	macro
	move.w nument(a5),d0
	lea entries(a5),a0
	move.l scene(a5),a1
	lsl.w #5,d0
	add.w d0,a0
	lea 4(a1,d0.w),a1
	moveq #0,d0
	move.w d0,(a0)+
	move.w #\1,(a0)+
	ifnc '\2',''
	move.l #\2,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\3',''
	move.l #\3,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\4',''
	move.l #\4,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\5',''
	move.l #\5,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\6',''
	move.l #\6,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	ifnc '\7',''
	move.l #\7,d1
	sub.l (a1)+,d1
	move.l d1,(a0)+
	else
	addq.l #4,a1
	move.l d0,(a0)+
	endc
	addq.w #1,nument(a5)
	endm
clipit	macro
        move.l 8(a0),d2			;mov ebx,[esi+8]
	moveq #zclip,d3
        cmp.l d3,d2			;cmp ebx,zclip
        bgt.w .nocliz\@			;jg @@nocliz
        cmp.l 8(a1),d3			;cmp dword ptr [edi+8],zclip
        bgt.w \1			;jg @@mocliz
        				;mov ecx,zclip
        sub.l d2,d3			;sub ecx,ebx
        sub.l 8(a1),d2			;sub ebx,[edi+8]
	beq.w \1
        neg.l d2			;neg ebx
        move.l (a1),d0			;mov eax,[edi]
        sub.l (a0),d0			;sub eax,[esi]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l (a0),d0			;add eax,[esi]
        move.l d0,(a5)			;mov [ebp],eax
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 4(a0),d0			;add eax,[esi+4]
        move.l d0,4(a5)			;mov [ebp+4],eax
        move.l 12(a1),d0		;mov eax,[edi+12]
        sub.l 12(a0),d0			;sub eax,[esi+12]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 12(a0),d0			;add eax,[esi+12]
        move.l d0,12(a5)		;mov [ebp+12],eax
        move.w 16(a1),d0		;movzx eax,word ptr [edi+16]
        				;movzx edx,word ptr [esi+16]
        sub.w 16(a0),d0			;sub eax,edx
        muls.w d3,d0			;imul ecx
        divs.w d2,d0			;idiv ebx
        add.w 16(a0),d0			;add ax,[esi+16]
        move.w d0,24(a5)		;mov [ebp+24],ax
        move.w 18(a1),d0		;movzx eax,word ptr [edi+18]
        				;movzx edx,word ptr [esi+18]
        sub.w 18(a0),d0			;sub eax,edx
        muls.w d3,d0			;imul ecx
        divs.w d2,d0			;idiv ebx
        add.w 18(a0),d0			;add ax,[esi+18]
        move.w d0,26(a5)		;mov [ebp+26],ax
        moveq #zclip,d2			;mov ebx,zclip
        move.l d2,8(a5)			;mov [ebp+8],ebx
        bra.b .lipers\@			;jmp short @@lipers
.nocliz\@
        move.l (a0),(a5)		;mov eax,[esi]
        				;mov [ebp],eax
        move.l 4(a0),4(a5)		;mov eax,[esi+4]
        				;mov [ebp+4],eax
        move.l d2,8(a5)			;mov [ebp+8],ebx
        move.l 12(a0),12(a5)		;mov eax,[esi+12]
        				;mov [ebp+12],eax
        move.l 16(a0),24(a5)		;mov eax,[esi+16]
        				;mov [ebp+24],eax
.lipers\@
	move.l (a5),d0			;mov eax,[ebp]
	lsl.l #7,d0
	divs.w d2,d0			;idiv ebx
        add.w #xcenter,d0		;add eax,xcenter*256
	ext.l d0
	lsl.l #8,d0
        move.l d0,16(a5)		;mov [ebp+16],eax
        move.l 4(a5),d0			;mov eax,[ebp+4]
        lsl.l #7,d0			;cdq
        divs.w d2,d0			;idiv ebx
        add.w #ycenter,d0		;add eax,ycenter
	ext.l d0
        move.l d0,20(a5)		;mov [ebp+20],eax
	endm
clipir	macro
        move.l 8(a0),d2			;mov ebx,[esi+8]
	moveq #zclip,d3
        cmp.l d3,d2			;cmp ebx,zclip
        bgt.w .nocliz\@			;jg @@nocliz
        cmp.l 8(a1),d3			;cmp dword ptr [edi+8],zclip
        bgt.w \1			;jg @@mocliz
        				;mov ecx,zclip
        sub.l d2,d3			;sub ecx,ebx
        sub.l 8(a1),d2			;sub ebx,[edi+8]
	beq.w \1
        neg.l d2			;neg ebx
        move.l (a1),d0			;mov eax,[edi]
        sub.l (a0),d0			;sub eax,[esi]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l (a0),d0			;add eax,[esi]
        move.l d0,(a5)			;mov [ebp],eax
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 4(a0),d0			;add eax,[esi+4]
        move.l d0,4(a5)			;mov [ebp+4],eax
        move.w 16(a1),d0		;movzx eax,word ptr [edi+16]
        				;movzx edx,word ptr [esi+16]
        sub.w 16(a0),d0			;sub eax,edx
        muls.w d3,d0			;imul ecx
        divs.w d2,d0			;idiv ebx
        add.w 16(a0),d0			;add ax,[esi+16]
        move.w d0,24(a5)		;mov [ebp+24],ax
        move.w 18(a1),d0		;movzx eax,word ptr [edi+18]
        				;movzx edx,word ptr [esi+18]
        sub.w 18(a0),d0			;sub eax,edx
        muls.w d3,d0			;imul ecx
        divs.w d2,d0			;idiv ebx
        add.w 18(a0),d0			;add ax,[esi+18]
        move.w d0,26(a5)		;mov [ebp+26],ax
        moveq #zclip,d2			;mov ebx,zclip
        move.l d2,8(a5)			;mov [ebp+8],ebx
        bra.b .lipers\@			;jmp short @@lipers
.nocliz\@
        move.l (a0),(a5)		;mov eax,[esi]
        				;mov [ebp],eax
        move.l 4(a0),4(a5)		;mov eax,[esi+4]
        				;mov [ebp+4],eax
        move.l d2,8(a5)			;mov [ebp+8],ebx
        move.l 16(a0),24(a5)		;mov eax,[esi+16]
        				;mov [ebp+24],eax
.lipers\@
        move.l (a5),d0			;mov eax,[ebp]
	lsl.l #7,d0
	divs.w d2,d0			;idiv ebx
        add.w #xcenter,d0		;add eax,xcenter*256
	ext.l d0
	lsl.l #8,d0
        move.l d0,16(a5)		;mov [ebp+16],eax
        move.l 4(a5),d0			;mov eax,[ebp+4]
        lsl.l #7,d0			;cdq
        divs.w d2,d0			;idiv ebx
        add.w #ycenter,d0		;add eax,ycenter
	ext.l d0
        move.l d0,20(a5)		;mov [ebp+20],eax
	endm
clipig	macro
        move.l 8(a0),d2			;mov ebx,[esi+8]
	moveq #zclip,d3
        cmp.l d3,d2			;cmp ebx,zclip
        bgt.w .nocliz\@			;jg @@nocliz
        cmp.l 8(a1),d3			;cmp dword ptr [edi+8],zclip
        bgt.w \1			;jg @@mocliz
        				;mov ecx,zclip
        sub.l d2,d3			;sub ecx,ebx
        sub.l 8(a1),d2			;sub ebx,[edi+8]
	beq.w \1
        neg.l d2			;neg ebx
        move.l (a1),d0			;mov eax,[edi]
        sub.l (a0),d0			;sub eax,[esi]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l (a0),d0			;add eax,[esi]
        move.l d0,(a5)			;mov [ebp],eax
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 4(a0),d0			;add eax,[esi+4]
        move.l d0,4(a5)			;mov [ebp+4],eax
        move.l 12(a1),d0		;mov eax,[edi+12]
        sub.l 12(a0),d0			;sub eax,[esi+12]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 12(a0),d0			;add eax,[esi+12]
        move.l d0,12(a5)		;mov [ebp+12],eax
        moveq #zclip,d2			;mov ebx,zclip
        move.l d2,8(a5)			;mov [ebp+8],ebx
        bra.b .lipers\@			;jmp short @@lipers
.nocliz\@
        move.l (a0),(a5)		;mov eax,[esi]
        				;mov [ebp],eax
        move.l 4(a0),4(a5)		;mov eax,[esi+4]
        				;mov [ebp+4],eax
        move.l d2,8(a5)			;mov [ebp+8],ebx
        move.l 12(a0),12(a5)		;mov eax,[esi+12]
        				;mov [ebp+12],eax
.lipers\@
        move.l (a5),d0			;mov eax,[ebp]
	lsl.l #7,d0
	divs.w d2,d0			;idiv ebx
        add.w #xcenter,d0		;add eax,xcenter*256
	ext.l d0
	lsl.l #8,d0
        move.l d0,16(a5)		;mov [ebp+16],eax
        move.l 4(a5),d0			;mov eax,[ebp+4]
        lsl.l #7,d0			;cdq
        divs.w d2,d0			;idiv ebx
        add.w #ycenter,d0		;add eax,ycenter
	ext.l d0
        move.l d0,20(a5)		;mov [ebp+20],eax
	endm
clipif	macro
        move.l 8(a0),d2			;mov ebx,[esi+8]
	moveq #zclip,d3
        cmp.l d3,d2			;cmp ebx,zclip
        bgt.w .nocliz\@			;jg @@nocliz
        cmp.l 8(a1),d3			;cmp dword ptr [edi+8],zclip
        bgt.w \1			;jg @@mocliz
        				;mov ecx,zclip
        sub.l d2,d3			;sub ecx,ebx
        sub.l 8(a1),d2			;sub ebx,[edi+8]
	beq.w \1
        neg.l d2			;neg ebx
        move.l (a1),d0			;mov eax,[edi]
        sub.l (a0),d0			;sub eax,[esi]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l (a0),d0			;add eax,[esi]
        move.l d0,(a5)			;mov [ebp],eax
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        muls.l d3,d0			;imul ecx
        divs.l d2,d0			;idiv ebx
        add.l 4(a0),d0			;add eax,[esi+4]
        move.l d0,4(a5)			;mov [ebp+4],eax
        moveq #zclip,d2			;mov ebx,zclip
        move.l d2,8(a5)			;mov [ebp+8],ebx
        bra.b .lipers\@			;jmp short @@lipers
.nocliz\@
        move.l (a0),(a5)		;mov eax,[esi]
        				;mov [ebp],eax
        move.l 4(a0),4(a5)		;mov eax,[esi+4]
        				;mov [ebp+4],eax
        move.l d2,8(a5)			;mov [ebp+8],ebx
.lipers\@
        move.l (a5),d0			;mov eax,[ebp]
	lsl.l #7,d0
	divs.w d2,d0			;idiv ebx
        add.w #xcenter,d0		;add eax,xcenter*256
	ext.l d0
	lsl.l #8,d0
        move.l d0,16(a5)		;mov [ebp+16],eax
        move.l 4(a5),d0			;mov eax,[ebp+4]
        lsl.l #7,d0			;cdq
        divs.w d2,d0			;idiv ebx
        add.w #ycenter,d0		;add eax,ycenter
	ext.l d0
        move.l d0,20(a5)		;mov [ebp+20],eax
	endm
clipxt	macro
        move.l (\2),d0			;mov ebx,[esi]
        sub.l (\3),d0			;sub ebx,[edi]
	beq.w \1
	tst.w d0
	beq.w \1
        move.l d3,(\2)			;mov [esi],ecx
        sub.l (\3),d3			;sub ecx,[edi]
        move.l 4(\2),d1			;mov eax,[esi+4]
        sub.l 4(\3),d1			;sub eax,[edi+4]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l 4(\3),d1			;add eax,[edi+4]
        move.l d1,4(\2)			;mov [esi+4],eax
	move.l -4(\2),d1
	sub.l -4(\3),d1
	asr.l #8,d1
	muls.l d3,d1
	divs.l d0,d1
	lsl.l #8,d1
	add.l -4(\3),d1
	move.l d1,-4(\2)
        move.l -8(\2),d1		;mov eax,[esi-8]
        sub.l -8(\3),d1			;sub eax,[edi-8]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l -8(\3),d1			;add eax,[edi-8]
        move.l d1,-8(\2)		;mov [esi-8],eax
        move.w 8(\2),d1			;movzx eax,word ptr [esi+8]
        				;movzx edx,word ptr [edi+8]
        sub.w 8(\3),d1			;sub eax,edx
        muls.w d3,d1			;imul ecx
        divs.w d0,d1			;idiv ebx
        add.w 8(\3),d1			;add ax,[edi+8]
        move.w d1,8(\2)			;mov [esi+8],ax
        move.w 10(\2),d1		;movzx eax,word ptr [esi+10]
        sub.w 10(\3),d1			;movzx edx,word ptr [edi+10]
        				;sub eax,edx
        muls.w d3,d1			;imul ecx
        divs.w d0,d1			;idiv ebx
        add.w 10(\3),d1			;add ax,[edi+10]
        move.w d1,10(\2)		;mov [esi+10],ax
        endm
clipxr	macro
        move.l (\2),d0			;mov ebx,[esi]
        sub.l (\3),d0			;sub ebx,[edi]
	beq.w \1
	tst.w d0
	beq.w \1
        move.l d3,(\2)			;mov [esi],ecx
        sub.l (\3),d3			;sub ecx,[edi]
        move.l 4(\2),d1			;mov eax,[esi+4]
        sub.l 4(\3),d1			;sub eax,[edi+4]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l 4(\3),d1			;add eax,[edi+4]
        move.l d1,4(\2)			;mov [esi+4],eax
        move.l -8(\2),d1		;mov eax,[esi-8]
        sub.l -8(\3),d1			;sub eax,[edi-8]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l -8(\3),d1			;add eax,[edi-8]
        move.l d1,-8(\2)		;mov [esi-8],eax
        move.w 8(\2),d1			;movzx eax,word ptr [esi+8]
        				;movzx edx,word ptr [edi+8]
        sub.w 8(\3),d1			;sub eax,edx
        muls.w d3,d1			;imul ecx
        divs.w d0,d1			;idiv ebx
        add.w 8(\3),d1			;add ax,[edi+8]
        move.w d1,8(\2)			;mov [esi+8],ax
        move.w 10(\2),d1		;movzx eax,word ptr [esi+10]
        sub.w 10(\3),d1			;movzx edx,word ptr [edi+10]
        				;sub eax,edx
        muls.w d3,d1			;imul ecx
        divs.w d0,d1			;idiv ebx
        add.w 10(\3),d1			;add ax,[edi+10]
        move.w d1,10(\2)		;mov [esi+10],ax
        endm
clipxg	macro
        move.l (\2),d0			;mov ebx,[esi]
        sub.l (\3),d0			;sub ebx,[edi]
	beq.w \1
	tst.w d0
	beq.w \1
        move.l d3,(\2)			;mov [esi],ecx
        sub.l (\3),d3			;sub ecx,[edi]
        move.l 4(\2),d1			;mov eax,[esi+4]
        sub.l 4(\3),d1			;sub eax,[edi+4]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l 4(\3),d1			;add eax,[edi+4]
        move.l d1,4(\2)			;mov [esi+4],eax
	move.l -4(\2),d1
	sub.l -4(\3),d1
	asr.l #8,d1
	muls.l d3,d1
	divs.l d0,d1
	lsl.l #8,d1
	add.l -4(\3),d1
	move.l d1,-4(\2)
        move.l -8(\2),d1		;mov eax,[esi-8]
        sub.l -8(\3),d1			;sub eax,[edi-8]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l -8(\3),d1			;add eax,[edi-8]
        move.l d1,-8(\2)		;mov [esi-8],eax
        endm
clipxf	macro
        move.l (\2),d0			;mov ebx,[esi]
        sub.l (\3),d0			;sub ebx,[edi]
	beq.w \1
	tst.w d0
	beq.w \1
        move.l d3,(\2)			;mov [esi],ecx
        sub.l (\3),d3			;sub ecx,[edi]
        move.l 4(\2),d1			;mov eax,[esi+4]
        sub.l 4(\3),d1			;sub eax,[edi+4]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l 4(\3),d1			;add eax,[edi+4]
        move.l d1,4(\2)			;mov [esi+4],eax
        move.l -8(\2),d1		;mov eax,[esi-8]
        sub.l -8(\3),d1			;sub eax,[edi-8]
        muls.l d3,d1			;imul ecx
        divs.l d0,d1			;idiv ebx
        add.l -8(\3),d1			;add eax,[edi-8]
        move.l d1,-8(\2)		;mov [esi-8],eax
        endm
mnoz	macro
	muls \1,\2
	add.l \2,\2
	swap \2
	endm
alloc	macro
	move.l \2,d0
	bsr malloc
	tst.l d0
	bne.b .jemem\@
	rts
.jemem\@
	move.l d0,\1
	endm
mpush	macro
	movem.l \1,-(a7)
	endm
mpop	macro
	movem.l (a7)+,\1
	endm
push	macro
	move.l \1,-(a7)
	endm
pop	macro
	move.l (a7)+,\1
	endm
int	macro
\10	dc.w \2
\1	= \10-vars
	endm
long	macro
\10	dc.l \2
\1	= \10-vars
	endm
along	macro
\10	blk.l \2,0
\1	= \10-vars
	endm
pointer	macro
\10
\1	= \10-vars
	endm

	jmp start
linlen	= 4*(32*3+20+4+4+1)
xclip   = 115
yclip   = 61
zclip   = 10
xcenter = (xclip+1)/2
ycenter = (yclip+1)/2
maxobj	= 64
maxarr	= 160
maxmem	= 22*1024
maxentries = 128
maxscene = 128
maxlights = 16
maxstack = 1024
stdllen	= 32
stdllog	= 5
dlsmooth = 16
dlsmlog	= 4
maxanims = 4
maxstars = 500
_numcovers equ 0
_numpoints equ 4
_numsurfaces equ 8
_covers equ 12
_points equ 16
_surfaces equ 20
_poivec equ 24
_reserved equ 28
;_phong equ 32

	section myszowy,code_p
	align 4,4
maizbuf	blk.l (yclip+2)*(xclip+1),0
maiscr	blk.l (yclip+2)*(xclip+1)/2,0

	section zwierz,code_p
	align 4,4
diffarr	blk.l 9*maxarr,0
bufobr	blk.l 3*maxarr,0
maipoi	blk.l 3*maxarr,0
maivec	blk.l maxarr,0
maicol	blk.l 3*maxarr,0
mainew	blk.l 3*maxarr,0
mirpoi	blk.l 3*maxarr,0
mirvec	blk.l maxarr,0
mircol	blk.l 3*maxarr,0
mirnew	blk.l 3*maxarr,0
mirzbuf	blk.l (yclip+2)*(xclip+1),0
picbuf
mirscr	blk.l (yclip+2)*(xclip+1)/2,0
frezbuf	blk.l (yclip+2)*(xclip+1),0
frescr	blk.l (yclip+2)*(xclip+1)/2,0
starsarr blk.l 3*(maxstars+1),0
truepal	blk.l 256*256,0
getsarr	blk.l 2048,0
textures
	;incdir cc0:
	incbin presents.text
	incbin meteor.text
colbyts
earth1	incbin earth1.text
	incbin earth2.text
	incbin earth3.text
	incbin earth4.text
numtextures = 6
	addcrtext floor2
	addcrtext wood1
	addcrtext floor1
	addcrtext intelout
	addcrtext oko
	addcrtext scraper
	addcrtext cindy
pictures:
	addiff title,title.ilbm
	addiff unionpic,union.ilbm
	addiff enjoy,enjoy.ilbm
backgrounds:
	addbackground oko,oko.back
	addbackground landscape,landscape.back
	addbackground face,face.back
	addbackground ask,ask.back
	addiff stairs,stairs.ilbm
	addiff crcode,cred-code.ilbm
	addiff crgfx,cred-gfx.ilbm
	addiff crmus1,cred-music1.ilbm
	addiff crmus2,cred-music2.ilbm
	addiff shot1,shot1.cmpic
	addiff shot2,shot2.cmpic
	addiff shot3,shot3.cmpic
	addiff shot4,shot4.cmpic
	addiff shot6,shot6.cmpic
	addcrtext rip
	addcrtext wall
	addcrtext door

	section mysz,code_p
	align 4,4
vars
	int czas,0
	int ttime,0
	int oldtime,0
	int music,0
	int fracou,0
	int nument,0
	int numrun,0
	int fractime,0
	int fracczas,0
	int mirflag,0
	int mir_a,0
	int mir_b,0
	int mir_c,0
	int saint,0
	int sadma,0
	int trueflag,0
	int ttime_s,0
	int numobjects,0
	int fadop,0
	int fadfaz,0
	int isfuck,0
	int frezflag,0
	int starsflag,0
	int barcol,0
	int bascol,0
	int barflag,0
	int decrrep,0
	int decrflag,0
	int repdata,0
	int waveflag,0
	int waveobj,0
	int wavetime,0
	int plasmflag,0
	int plasmcol,0
	int plasmp1,0
	int plasmp2,0
	int plasmp3,0
	int plasmp4,0
	int plasmp5,0
	int plasmp6,0
	int shadflag,0
	int shadsped,0
	int shad_a,0
	int shad_b,0
	int shad_c,0
	int cienflag,0
	int stopped,0
	align 4,4
	long shad_d,0
	long shad_id,0
	long plasmp7,0
	long plasmp8,0
	long extproc,0
	long mir_d,0
	long mir_n,0
	long mir_id,0
	long numcovers,0
	long numpoints,0
	long numsurfaces,0
	long covers,0
	long points,0
	long surfaces,0
	long poivec,0
	long reserved,0
;	long phong,0
nodelen	= 8
	blk.l 8,0		;dd 7 dup(0)
	long nextobj,0
	long object,0
	long scene,0
	long lights,0
	long ascene,0
	long alights,0
	long freem,maxmem
	long memad,freemem
	long ekr,0
	long aekr,0
	long inter,0
	long stack,0
	long numlights,0
	long numanims,0
	long newpoi,0
	long vector,0
	long colpoi,0
	long newvec,0
	long zbuffer,0
	long screen,0
	long mt_data,0
	long int6c,0
	long wb_message,0
	long dosbase,0
	long gfxbase,0
	long background,0
	long oldcop,0
	long ocoper1,0
	long ocoper2,0
	along arranims,maxanims
	along move,3
	along ang,3
	along move_s,3
	along ang_s,3
	along move_o,3
	along ang_o,3
	along objtab,maxobj*16
	along bufscene,maxscene*8
	along buflights,maxlights*8
	along poilights,maxlights*6
	along entries,maxentries*8
	along mirbuf,16
	along mystack,(maxstack+2)
	pointer tabmir
;	dc.l 0,0,0,0,0,0
	dc.l 0,2,1,2,0,1
	pointer tabsin
	incbin sin
	along plasmsin,750
	along shadarr,1024
	pointer tabsur
	dc.w 3,3,3,3,3,3,6,6,6,9,9,9,12,12,12,15,15,15,18,18,18
	dc.w 21,21,21,24,24,24,27,27,27,30,30,30,33,33,33,36,36,36,39,39,39
	dc.w 42,42,42,45,45,45,48,48,48,51,51,51,54,54,54,57,57,57,60,60,60
	pointer transarr
	nop
	lsr.b #1,d0
	lsr.b #2,d0
	lsr.b #3,d0
	lsr.b #4,d0
	lsr.b #5,d0
	lsr.b #6,d0
	lsr.b #7,d0

start:
	lea vars,a5
	sub.l a1,a1
	callexec -294
	move.l d0,a4
	tst.l $ac(a4)
	bne.b .fromCLI
	lea $5c(a4),a0
	callexec -384
	callexec -372
	move.l d0,wb_message(a5)
.fromCLI
	openlib graphics,gfx
	openlib dos,dos
	tst.l gfxbase(a5)
	beq.w .wrongman
	tst.l dosbase(a5)
	beq.w .wrongman
	jsr initcop
	jsr makmir
	jsr maktex		;call maktex
	jsr maktpal
	jsr initgscr
	jsr initpsin
	jsr initsarr
        			;call SetPalette
	jsr prepobj		;call prepobj
	tst.l d0		;jc @@notmem
	bne.b .notmem
	moveq #1,d0
	bra.w .nicedos
.notmem
	bsr initrend
	jsr initstars
	move.l gfxbase(a5),a0
	move.l $22(a0),oldcop(a5)
	move.l $26(a0),ocoper1(a5)
	move.l $32(a0),ocoper2(a5)
	sub.l a1,a1
	callgfx -222
	callgfx -270
	callgfx -270
	callexec -150
	tst.l d0
	beq.b .nodemo
	push d0
	bsr.w demo
	bsr.w output
	pop d0
	callexec -156
	bra.b .nicedos
.nodemo
	moveq #2,d0
.nicedos
	move.l oldcop(a5),a1
	callgfx -222
	move.l ocoper1(a5),$dff080
	move.l ocoper2(a5),$dff084
	move.w d0,$dff088
	moveq #0,d0
	push d0
	bsr.b outtext
	closelib gfx
	closelib dos
	pop d0
.wrongman
	tst.l wb_message(a5)
	beq.b .noreply
	push d0
	move.l wb_message(a5),a1
	callexec -378
	pop d0
.noreply
	rts
output:
	ext.l d1
	add.w #"0",d2
	move.b d2,frate+3
	divu #10,d1
	tst.w d1
	bne.b .noless
	move.w #32-"0",d1
.noless
	add.w #"0",d1
	move.b d1,frate
	swap d1
	add.w #"0",d1
	move.b d1,frate+1
	rts
outtext:
	push d0
	calldos -60
	pop d7
	ifd ondisk
	move.l d0,d1
	bne.b .jecout
	rts
.jecout
	movem.l .mesarr(pc,d7.w*8),d2-d3
	sub.l d2,d3
	calldos -48
	endif
	rts
.mesarr	dc.l text,endoft,nomem,endnom,supmod,endsup
nomem	dc.b "Strange, not enough memory!",13,10
endnom	even
supmod	dc.b "Strange, can't get into supervisor mode!",13,10
endsup	even
text	dc.b "---------------------------------------------------------------",13,10
	dc.b "BBBB  EEEE Y   Y  OOO  NN    N DDDD ",13,10
	dc.b "B   B E     Y Y  O   O N N   N D   D",13,10
	dc.b "BBBB  EEEE   Y   O   O N  N  N D   D",13,10
	dc.b "B   B E      Y   O   O N   N N D   D",13,10
	dc.b "BBBB  EEEE   Y    OOO  N    NN DDDD ",13,10,13,10
	dc.b "       FFFF U   U TTTTT U   U RRRR  EEEE",13,10
	dc.b "       F    U   U   T   U   U R   R E   ",13,10
	dc.b " THE   FFF  U   U   T   U   U RRRR  EEEE",13,10
	dc.b "       F    U   U   T   U   U R  R  E   ",13,10
	dc.b "       F     UUU    T    UUU  R   R EEEE",13,10,13,10
	dc.b "code: Musashi   gfx: Berserker   music: Dan & Scorpik",13,10
	dc.b "logo Union was drawn by Lazur",13,10,13,10
	dc.b "Demo released on The Party IV in december 1994",13,10,13,10
	dc.b "Greetings to:",13,10
	dc.b "Sanity, Pygmy Project, Fairlight, Complex,",13,10
	dc.b "Stellar, all polish groups & all i forgot.",13,10,13,10
	dc.b "Thanx to JKK for technical support.",13,10
	dc.b "---------------------------------------------------------------",13,10
	dc.b "Thank you for watching my show.",13,10
	dc.b "Average framerate was "
frate	dc.b "00.0 frames per second.",13,10
	dc.b "---------------------------------------------------------------",13,10
endoft	even

demo:
	clearc
	lea $dff000,a6
	move.w $1c(a6),saint(a5)
	move.w 2(a6),sadma(a5)
	move.w #$7fff,d0
	move.w d0,$9a(a6)
	move.w d0,$96(a6)
	move.w d0,$9c(a6)
	movec vbr,a0
	move.l $6c(a0),int6c(a5)
	move.l #vprzer,$6c(a0)
	move.w #$c020,$9a(a6)
	move.w #15,$1fc(a6)
 	move.l #coper,$80(a6)
	move.l #coper2,$84(a6)
	move.w #$87c0,$96(a6)
	move.w d0,$88(a6)
	move.l a7,stack(a5)
	lea mystack+(maxstack*4)(a5),a7

	setmirror 7,0,2
	setmirror 7,1,2
	setmirror 7,2,2
	setmirror 7,3,2
	setmirror 7,4,2
	setmirror 7,5,2
	mapsphere4 1,2,8,6
	mapflat 15,-200,-30,370,70
	setmirror 19,0,%111001001

	;bsr glass
	;bra pexit
	;bra testob

	depakmus musdata,music1
	bsr intro
	stoptime
	setmusic music1
	musicon
	starttime
	bsr cosmos
	stoptime
	getiff title
	starttime
	waitpat 56,x
	stoptime
	fadein 1,$f61
	decrtext intelout,6
	decrtext floor2,4
	decrtext wood1,5
	decrtext floor1,3
	wait 100
	fadeout 1,$4f
	starttime
	bsr doom
	bsr mtunel
	bsr mirrors
	bsr bell
	bsr village
	bsr logos
	bsr spheres
	bsr lamp
	bsr shadow
	bsr glass
	bsr senjoy
	bsr morphing
	bsr love
	bsr miska
	bsr city
	bsr restin
	musicstop
	stoptime
	depakmus music2,music1
	wait 100
	setmusic music1
	musicon
	wait 100
	bra endpart
pexit
	doit 1
	bra pexit
exit:
	starttime
	move.l stack(a5),a7
	move.w fracou(a5),d1
	ext.l d1
	move.w ttime(a5),d2
	beq.b .nofrac
	mulu #50,d1
	divu d2,d1
	move.l d1,d0
	swap d0
	mulu #10,d0
	divu d2,d0
	move.w d0,d2
.nofrac
	mpush d1-d2
	lea $dff000,a6
	move.w #$7fff,d0
	move.w d0,$9a(a6)
	move.w d0,$96(a6)
	move.w d0,$9c(a6)
	bsr.l mt_end
	movec vbr,a0
	move.l int6c(a5),$6c(a0)
	or.w #$8000,saint(a5)
	or.w #$8000,sadma(a5)
	move.w saint(a5),$9a(a6)
	move.w sadma(a5),$96(a6)
	mpop d1-d2
	rts

vprzer:
	push a0
	lea vars,a0
	addq.w #1,ttime(a0)
	tst.w czas(a0)
	beq.s .notim
	subq.w #1,czas(a0)
.notim
	tst.l inter(a0)
	beq.s .noint
	push a0
	move.l inter(a0),a0
	jsr (a0)
	pop a0
.noint
	tst.w music(a0)
	beq.b .nomusic
	jsr mt_music
.nomusic
	pop a0
	move.w #$20,$dff09c
	move.w #$20,$dff09c
	rte

lamp:
	setmode 0
	setscene chaos
	setcam 0,0,0,0,0,0
	shadeon 1
	waitpos 43,x
	fuckin 1
	movo 0,50,100,150,150
	doit 80
	fuckoff
	movo 0,100,200,300,300,,200
	doit 180
	fuckout 1
	movo 0,25,50,75,20,,75
	doit 40
	fuckoff
	shadeoff
	rts

spheres:
	setmode 0
	setscene sphs
	setcam 60,0,0,200,0,400
	shadeon 2
	setobj 0,,,,30,-10,600
	setobj 1,,,,-20,20,700
	setobj 2,,,,0,30,800
	setobj 3,,,,-30,-20,900
	setobj 4,,,,30,20,1000
	waitpos 41,x
	movo 0,100,200,300
	movo 1,100,200,300
	movo 2,100,200,300
	movo 3,100,200,300
	movo 4,100,200,300
	movc ,,,,,610
	doit 200
	doit 150
	shadeoff
	rts

endpart:
	decrunch #shot1,#picbuf
	fapicin 4
	wait 100
	fapicout 4
	decrunch #shot2,#picbuf
	fapicin 4
	wait 100
	fapicout 4
	getiff crcode
	fadein 3,0
	wait 100
	fadeout 3,0
	getiff stairs
	fadein 4,0
	wait 100
	fadeout 4,0
	getiff crgfx
	fadein 3,0
	wait 100
	fadeout 3,0
	decrunch #shot3,#picbuf
	fapicin 4
	wait 100
	fapicout 4
	getiff crmus1
	fadein 3,0
	wait 100
	fadeout 3,0
	decrunch #shot4,#picbuf
	fapicin 4
	wait 100
	fapicout 4
	getiff crmus2
	fadein 3,0
	wait 100
	fadeout 3,0
	decrunch #shot6,#picbuf
	fapicin 4
	wait 100
	fapicout 4
	bra endpart

city:
	setmode 0
	setcam 0,0,0,100,-24,40
	setscene ncity
	animon 0
	objoff 5
	objoff 6
	waitpos 69,x
	fuckin 6
	doit 300
	fuckoff
	setbar 7
	movc ,,,-100,-10,-240
	doit 100
	movcf ,0,,,,100
	doit 75
	movcf 90,0,,,,380,x
	doit 125
	objoff 3
	objoff 0
	movc ,,,-210
	doit 50
	objoff 2
	objon 5
	objon 6
	movc 90
	doit 50
	movc ,,,,,-160
	doit 80
	movc -90
	doit 80
	fuckout 2
	doit 65
	fuckoff
	animoff 0
	baroff
	rts

restin:
	setmode 0
	setscene rips
	setcam 90,0,0,150,-10,200
	decrtext rip,1
	decrtext wall,2
	decrtext door,3
	setdbar 7,7*8
	waitpos 74,x
	fuckin 2
	doit 50
	movc ,,,50,-10,-80
	doit 100
	fuckoff
	movc 90,,,-200,-10
	doit 100
	movc 180,,,,30,-140
	doit 100
	movct ,,,-13,-15,16
	doit 100
	doit 100
	movc ,,,,20
	doit 50
	doit 250
	fuckout 6
	doit 150
	fuckoff
	baroff
	rts

glass:
	jsr prepglas
	decrtext cindy,1
	setmode 0
	setcam 0,0,0,0,0,0
	setscene glas
	setobj 0,0,135,0,0,0,100,$7010000
	waitpos 49,x
	fuckin 1
	doit 50
	fuckoff
	movo 0,,,,,,20
	doit 50
	setobj 0,,,,,,,$6010000
	movo 0,10,20,30
	doit 20
	setobj 0,,,,,,,$5010000
	movo 0,10,20,30
	doit 20
	setobj 0,,,,,,,$4010000
	movo 0,10,20,30
	doit 20
	setobj 0,,,,,,,$3010000
	movo 0,10,20,30
	doit 20
	setobj 0,,,,,,,$2010000
	movo 0,10,20,30
	doit 20
	movo 0,100,200,300
	doit 200
	movo 0,25,50,75,-100
	doit 50
	setback face
	fuckin 0
	decrtext floor2,1
	setobj 0,,,,100
	doit 20
	fuckoff
	movo 0,100,200,300,-200
	doit 250
	objoff 0
	fuckout 0
	doit 20
	fuckoff
	backoff
	rts

shadow:
	setmode 0
	setscene shads
	setshadow 35,0,$db
	setcam 0,0,0,0,-30,100
	setbar %111100111
	objoff 1
	waitpos 45,x
	fuckin 2
	doit 50
	fuckoff
	movl 0,,,,-200,40
	movo 0,,,,-200,40
	doit 50
	movc ,,,,30,-150
	doit 50
	movl 0,,,,200,-40
	movo 0,,,,200,-40
	movc ,,-55,,-300,50
	doit 50
	movls 0,0,0,-100,-100,0,-100
	movos 0,0,0,-100,-100,0,-100
	doit 50
	movls 0,-100,0,0,-100,0,100
	movos 0,-100,0,0,-100,0,100
	doit 50
	movls 0,0,0,100,100,0,100
	movos 0,0,0,100,100,0,100
	doit 50
	movls 0,100,0,0,100,0,-100
	movos 0,100,0,0,100,0,-100
	doit 50
	objon 1
	movo 1,,,90,100
	movct 90,0,310,150,-180,260
	movls 0,0,0,-100,-100,0,-100
	movos 0,0,0,-100,-100,0,-100
	doit 60
	movo 1,,,180,200
	movc ,,-20
	doit 120
	movc ,,-5
	fuckout 1
	doit 60
	fuckoff
	baroff
	rts

miska:
	setmode 1
	setscene posws
	setcam 0,0,0,0,0,0
	waitpos 67,x
	fuckin 4
	movo 0,100,50,150
	doit 100
	fuckoff
	movo 0,400,200,600
	doit 420
	fuckout 4
	movo 0,100,50,150
	doit 100
	fuckoff
	rts

bell:
	setmode 0
	setcam 0,0,0,0,0,0
	setscene bells
	setplasm %111111000,$7f,7,$ff,8,1,1,$10000,$10000
	fuckin 1
	doit 50
	fuckoff
	movo 0,1200,800,400,-300
	doit 600
	fuckout 1
	doit 50
	fuckoff
	plasmoff
	rts

village:
	setmode 0
	setscene stret
	setcam 90,0,0,400,-50,400
	setdbar 7,7*64
	objoff 2
	objoff 3
	movc ,,,-200,50
	waitpos 29,x
	fuckin 2
	doit 100
	fuckoff
	movc 180,,,-600
	doit 200
	movc 90,,,40,-54,-200
	doit 100
	movc -30,,,130
	doit 100
	setpower 0,6
	movc -3,,,10,5,15
	doit 15
	setpower 0,5
	movc -3,,,10,5,15
	doit 15
	setpower 0,4
	movc -3,,,10,5,15
	doit 15
	setpower 0,3
	movc -3,,,10,5,15
	doit 15
	setpower 1,6
	movc -3,,,10,5,15
	doit 15
	setpower 1,5
	movc -3,,,10,5,15
	doit 15
	setpower 1,4
	movc -3,,,10,5,15
	doit 15
	setpower 1,3
	movc -3,,,10,5,15
	doit 15
	objon 2
	objon 3
	setpower 2,$10008
	movo 2,,,,-300
	movo 3,,,,-300
	movl 2,720,,,-300
	doit 100
	movo 2,,,,-300
	movo 3,,,,-300
	movl 2,720,,,-300
	movc 130
	doit 100
	movl 2,360
	doit 60
	fuckout 2
	movl 2,360
	doit 60
	fuckoff
	baroff
	rts

doom:
	setmode 0
	setcam 0,0,0,-256,0,280
	setalts intel
	setscene shock
	setlight 0,0,0,0,-256,0,280
	setbar 7*8*8
	waitpos 9
	setproc obrintel
	doit 100
	movc ,,,,,-280
	movl 0,,,,,,-280
	doit 50
	movc -90
	doit 50
	movc ,,,256
	movl 0,,,,,,256
	doit 50
	movc 90,,-90,,-2000
	movl 0,,,,,-2000
	doit 50
	movot 0,100,200,300,200,-2000,800
	movot 1,200,100,300,400,-2000,600
	movot 2,300,300,200,600,-2000,400
	movot 3,100,100,100,800,-2000,200
	movot 4,200,200,200,200,-2000,-800
	movot 5,300,300,300,400,-2000,-600
	movot 6,00,300,00,0,-1800,0
	movot 7,200,222,333,600,-2000,-400
	movot 8,100,333,200,-800,-2000,-200
	movot 9,123,456,321,-200,-2000,800
	movot 10,333,444,222,-400,-2000,600
	movot 11,111,222,333,-600,-2000,400
	movc 90
	fuckout 5
	doit 100
	procoff
	altsoff
	baroff
	rts

obrintel
	lea intel,a0
	addq.l #2,4(a0)
	addq.l #4,8(a0)
	addq.l #6,12(a0)
	move.l #360,d0
	cmp.l 4(a0),d0
	bge.b .nozpe1
	sub.l d0,4(a0)
.nozpe1
	cmp.l 8(a0),d0
	bge.b .nozpe2
	sub.l d0,8(a0)
.nozpe2
	cmp.l 12(a0),d0
	bge.b .nozpe3
	sub.l d0,12(a0)
.nozpe3
	rts

logos:
	setmode 0
	setcam 0,0,0,0,0,0
	setscene union
	setobj 0,,,,,,370+1000
	setback landscape
	waitpos 35,x
	objoff 1
	fuckin 1
	movo 0,,,,,,-1000
	doit 90
	fuckoff
	movo 0,90,,,50,0,-50
	doit 50
	movo 0,,,,,,-200
	doit 50
	movo 0,-180,,,-100,0,100
	doit 50
	waveon 15
	movo 0,,,,,,-200
	doit 50
	movo 0,90,,,50,0,200
	doit 50
	movot 0,0,0,0,0,0,370
	movc 30,0,-15,200,-100,0
	doit 50
	doit 40
	movo 0,360
	doit 130
	setobj 1,,,,,-300
	objon 1
	movo 0,180
	movo 1,,,,,300
	doit 100
	movo 0,360
	movc -60,,,-400
	doit 120
	movo 0,360
	movc 60,,,400
	doit 120
	fuckout 1
	movo 0,120
	movc -20,,,-130
	doit 50
	fuckoff
	waveoff
	backoff
	rts

mtunel:
	waitpos 11
	fuckoff
	setmode 0
	setscene tunel
	setcam 270,0,0,-700,0,0
	setlight 0,0,0,0,-700,0,0
	setobj 0,0,0,0,0,0,520
	setobj 1,0,0,0,0,0,420
	setobj 2,0,0,0,0,0,320
	setobj 3,0,0,0,0,0,220
	setobj 4,0,0,0,0,0,120
	setobj 5,90,0,0,120,0,0
	setobj 6,90,0,0,-120,0,0
	setobj 7,90,0,0,-220,0,0
	setobj 8,90,0,0,-320,0,0
	setobj 9,90,0,0,-420,0,0
	setobj 10,90,0,0,220,0,0
	setobj 11,90,0,0,320,0,0
	fuckin 3
	movc ,360,,700
	movl 0,,,,700
	starson
	doit 300
	fuckoff
	movc 90
	doit 50
	movo 0,0,0,0,0,0,-400
	movo 1,0,0,0,0,0,-400
	movo 2,0,0,0,0,0,-400
	movo 3,0,0,0,0,0,-400
	movo 4,0,0,0,0,0,-400
	movc ,360
	doit 200
	setscene mirr2
	setmirror 20,0,2
	setmirror 20,1,2
	setmirror 20,2,2
	setmirror 20,3,2
	setmirror 20,4,2
	setmirror 20,5,2
	starsoff
	movo 0,100,150,50,,,-900
	doit 50
	movo 0,100,150,50
	doit 100

	movo 0,200,300,100
	movo 1,100,200,300
	doit 200
	fuckout 1
	movo 0,50,75,25
	movo 1,25,50,75
	doit 50
	setmirror 20,6,$1b
	setmirror 20,7,$1b
	setmirror 20,8,$1b
	setmirror 20,9,$1b
	setmirror 20,10,$1b
	setmirror 20,11,$1b
	fuckin 1
	movo 0,50,75,25
	movo 1,25,50,75
	doit 50
	fuckoff
	movo 0,200,300,100
	movo 1,100,200,300
	doit 200
	movo 0,50,75,25
	movo 1,25,50,75
	fuckout 1
	doit 50
	fuckoff
	rts

cosmos:
	setmode 0
	setscene cosm2
	starson
	setflat
	setcam 180,0,0,0,0,0
	setobj 0,0,0,270,,-20,-2000
	setobj 1,100,200,300,200,0,-160
	setobj 2,200,300,100,20,-30,-300
	setobj 3,333,222,111,30,40,-500
	setobj 4,124,230,333,-60,-20,-800
	setobj 5,55,0,222,-100,100,-400
	setobj 6,222,333,20,30,-40,-100
	setobj 7,333,333,333,100,20,-160
	movo 1,123,234,345,-400,10,-200
	movo 2,500,300,600,-30,20,400
	movo 3,200,700,300,100,50,130
	movo 4,500,700,200,-150,-20,180
	movo 5,300,300,400,80,-30,-200
	movo 6,222,333,666,-30,40,-20
	movo 7,434,232,121,-100,-20,40
	movo 0,,,,,,1000
	fuckin 4
	doit 220
	fuckoff
	objoff 1
	objoff 2
	movo 3,200,700,300,100,50,130
	movo 4,500,700,200,-150,-20,180
	movo 5,300,300,400,80,-30,-200
	movo 6,222,333,666,-30,40,-20
	movo 7,434,232,121,-100,-20,40
	movo 0,,,,,,1000
	doit 220
	movo 3,20,70,30,10,5,13
	movo 4,50,70,20,-15,-2,18
	movo 5,30,30,40,8,-3,-20
	movo 6,22,33,66,-3,4,-2
	movo 7,43,23,12,-10,-2,4
	movo 0,,,,,,100
	doit 20
	setscene cosm1
	objoff 2
	objoff 3
	setcam 180,0,0,0,0,0
	objoff 1
	movc 180
	movo 0,,50
	doit 50
	objon 1
	setobj 1,0,0,270,-40,-7,-100
	movo 0,,100
	movof 1,,,,,200
	doit 110
	movo 0,,100
	movof 1,,,,,200
	movc 90,,,100,-20,340
	doit 110
	movo 0,,100
	movof 1,,,,,200
	movc ,,-30,,-70,150
	doit 110
	doit 20
	stoptime
	setshad
	bsr initzbuf
	bsr rendscene
	bsr copysfx
	starttime
	waitpos 4,x
	movo 0,,100
	movof 1,,,,,200
	movc -70,,30,,50
	doit 90
	movo 0,,50
	movof 1,50,50,,,100,,x
	doit 50
	objon 2
	setobj 2,90,0,0,0,0,500
	movo 2,,180,,,,200
	movo 0,,50
	movof 1,,20,,,100,,x
	movc -10,,,,50
	doit 50
	objon 3
	setobj 3,90,0,0,100,0,400
	movo 0,,100
	movof 1,,,,,200
	movo 2,,360,,,,400
	movo 3,,360,,,,400
	doit 90
	objoff 1
	objoff 2
	movo 3,,360,,,,400
	movc ,-180,,,,160
	movo 0,,100
	doit 90
	objoff 3
	movo 0,00,100,00
	movc ,-180
	fuckout 4
	doit 90
	fuckoff
	starsoff
	rts

intro:
	stoptime
	getiff unionpic
	wait 50
	fadein 2,0
	wait 100
	fadeout 2,0
	starttime
	setcam 0,0,0,0,0,0
	setscene prese
	setmode 0
	fuckin 2
	doit 150
	fuckoff
	movo 0,100,200,300,100
	doit 100
	movo 0,50,100,150,50
	fuckout 1
	doit 50
	fuckoff
	rts

mirrors:
	setmode 0
	setscene mirr1
	setcam 0,0,0,0,0,200
	setobj 1,0,0,0,0,0,170
	movo 1,100,300,200
	objoff 2
	fuckin 2
	setback oko
	decrtext oko,1
	waitpos 19,x
	doit 100
	fuckoff
	movc ,,,,,-150
	movo 1,50,150,100
	movos 1,-90,0,0,-90,0,110
	doit 50
	movo 1,50,150,100
	movos 1,0,0,110,90,0,110
	doit 50
	movo 1,50,150,100
	movos 1,90,0,0,90,0,-110
	doit 50
	movo 1,50,150,100
	movos 1,0,0,-110,-90,0,-110
	doit 50

	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,-90,0,0,-90,0,110
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,0,0,110,90,0,110
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,90,0,0,90,0,-110
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,0,0,-110,-90,0,-110
	doit 50
	objon 2
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,-90,0,0,-90,0,110
	movo 2,,,,90
	movl 0,,,,90
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,0,0,110,90,0,110
	movos 2,0,-90,0,-90,-90,0
	movls 0,0,-90,0,-90,-90,0
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,90,0,0,90,0,-110
	movos 2,-90,0,0,-90,90,0
	movls 0,-90,0,0,-90,90,0
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,0,0,-110,-90,0,-110
	movos 2,0,90,0,90,90,0
	movls 0,0,90,0,90,90,0
	doit 50
	movo 0,150,100,50
	movo 1,50,150,100
	movos 1,-90,0,0,-90,0,110
	movos 2,90,0,0,90,-90,0
	movls 0,90,0,0,90,-90,0
	doit 50
	movo 0,300,200,100,-300
	movo 1,100,300,200,300
	movos 1,0,0,110,90,0,110
	movos 2,0,-90,0,-90,-90,0
	movls 0,0,-90,0,-90,-90,0
	fuckout 4
	doit 100
	fuckoff
	backoff
	rts

love:
	setmode 1
	setcam 0,0,0,0,0,0
	setscene loves
	objoff 1
	objoff 0
	setobj 0,0,0,0,250,0,500
	setobj 1,0,90,0,-250,0,500
;	setbar $3f
	setback ask
	fuckin 1
	doit 40
	fuckoff
	objon 0
	movo 0,200,400,600,-500
	doit 230
	objoff 0
	objon 1
	movo 1,400,600,200,500
	doit 230
	objon 0
	movo 0,100,200,300,250
	movo 1,200,300,100,-250
	forcshad
	doit 120
	movo 0,200,400,600
	movo 1,400,600,200
	doit 230
	movo 0,100,200,300,250
	movo 1,200,300,100,-250
	doit 120
	fuckout 1
	doit 40
	fuckoff
	normdraw
;	baroff
	backoff
	rts

senjoy:
	getiff enjoy
	waitpos 53,x
	stoptime
	fadein 2,$fff
	decrtext scraper,2
	decrunch anstruct0+16,#earth1
	move.l #earth1,anstruct0+16
	starttime
	waitpos 54,x
	cmp.b #55,mt_songpos
	bge.b .skipwap
	waitpat 56,x
.skipwap
	stoptime
	fadeout 1,0
	starttime
	rts

morphing:
	setmode 1
	setflat
	setscene morps
	setbar %100111000
	setcam 0,0,0,0,0,0
	setobj 0,0,285,90,-300,0,1000
	movo 0,,,,300,,-700
	fuckin 2
	doit 50
	fuckoff
	doit 25
	movo 0,,-320
	doit 120
	movo 0,360,35,-90
	doit 120
	morph 5,4
	movo 0,160
	doit 120
	movo 0,160
	doit 120
	fuckout 1
	doit 35
	setshad
	baroff
	setplasm %111100000,$7f,7,$1ff,9,3,5,$20000,$40000
	fuckin 1
	doit 35
	movo 0,80
	doit 50
	fuckoff
	movo 0,100,200,300
	doit 200
	morph 5,16
	movo 0,100,200,300
	doit 200
	morph 5,17
	movo 0,200,100,300
	doit 200
	movo 0,100,50,150
	doit 100
	fuckout 4
	movo 0,100,50,150
	doit 100
	fuckoff
	plasmoff
	rts

initsarr:
	lea shadarr(a5),a0
	moveq #15,d7
	moveq #2,d0
.kazkup
	moveq #0,d1
	moveq #127,d6
.kazodc
	move.w d1,d2
	sub.w d0,d2
	bpl.b .miessi
	moveq #0,d2
.miessi
	move.w d2,(a0)+
	addq.w #1,d1
	dbf d6,.kazodc
	addq.w #2,d0
	dbf d7,.kazkup
	rts

initpsin:
	lea tabsin(a5),a0
	lea plasmsin(a5),a1
	move.w #1439,d7
.kazen
	move.w (a0)+,d0
	asr.w #8,d0
	asr.w #2,d0
	add.w #32,d0
	move.w d0,(a1)+
	dbf d7,.kazen
	rts

initgscr:
	lea getsarr,a0
	moveq #0,d0
	move.w #4095,d7
	moveq #7,d4
	moveq #7*8,d5
	move.w #7*8*8,d6
.kazkol
	move.w d0,d1
	move.w d0,d2
	move.w d0,d3
	lsr.w #1,d1
	lsr.w #2,d2
	lsr.w #3,d3
	and.w d4,d1
	and.w d5,d2
	and.w d6,d3
	or.w d2,d1
	or.w d3,d1
	lsl.w #7,d1
	move.w d1,(a0)+
	addq.w #1,d0
	dbf d7,.kazkol
	move.w #3*128,getsarr
	rts

getscreen:
	moveq #0,d4
	lsr.w #1,d0
	bcc.b .nonext
	moveq #1,d4
.nonext
	lsl.w #8,d0
	add.w d4,d0
	lsl.l #8,d0
	lea textures,a0
	add.l d0,a0
	move.l screen(a5),a1
	moveq #yclip,d7
	lea truepal+131072,a4
	push a5
	lea getsarr,a5
.kazlin
	moveq #xclip,d6
	move.l a0,a2
	move.l a1,a3
.kazpun
	move.w (a3)+,d0
	move.w 0(a4,d0.w*4),d0
	move.w 0(a5,d0.w*2),(a2)+
	dbf d6,.kazpun
	lea 512(a0),a0
	lea (xclip+1)*2(a1),a1
	dbf d7,.kazlin
	pop a5
	rts

mapit3:
	lsl.w #6,d0
	lea (a5,d0.w,objtab.w),a0
	move.l _surfaces(a0),a1
	move.l _points(a0),a2
	move.l _numsurfaces(a0),d7
	subq.w #1,d7
.kazsur
	move.w (a1),d6
	subq.w #1,d6
	lea 6(a1),a3
.kazpoi
	move.w (a3)+,d1
	move.l 0(a2,d1.w*2),d0
	move.l 4(a2,d1.w*2),d1
	sub.w d2,d0
	sub.w d3,d1
	muls.w #127,d0
	muls.w #127,d1
	divs.w d4,d0
	divs.w d5,d1
	lsl.w #8,d0
	lsl.w #8,d1
	move.w d0,(a3)+
	move.w d1,(a3)+
	dbf d6,.kazpoi
	move.w (a1),d0
	mulu #6,d0
	lea 6(a1,d0.w),a1
	dbf d7,.kazsur
	rts

mapit1:
	moveq #0,d4
	lsr.w #1,d1
	bcc.b .nonext
	moveq #1,d4
.nonext
	lsl.w #8,d1
	add.w d4,d1
	lsl.w #6,d0
	lea (a5,d0.w,objtab.w),a0
	move.l _surfaces(a0),a1
	move.w d3,d7
	subq.w #1,d7
	sub.l a3,a3
.kazwie
	move.w d2,d6
	subq.w #1,d6
	sub.l a2,a2
	move.l a3,d5
	mulu.w #$7f00,d5
	divu.w d3,d5
	move.w d5,a4
	addq.l #1,a3
	move.l a3,d5
	mulu.w #$7f00,d5
	divu.w d3,d5
.kazsur
	move.w d1,4(a1)
	move.w a4,6+4(a1)
	move.w a4,12+4(a1)
	move.w d5,18+4(a1)
	move.w d5,24+4(a1)
	move.l a2,d4
	mulu.w #$7f00,d4
	divu.w d2,d4
	move.w d4,6+2(a1)
	move.w d4,24+2(a1)
	addq.l #1,a2
	move.l a2,d4
	mulu.w #$7f00,d4
	divu.w d2,d4
	move.w d4,12+2(a1)
	move.w d4,18+2(a1)
	lea 5*6(a1),a1
	dbf d6,.kazsur
	dbf d7,.kazwie
	rts

mapit2:
	move.w d1,d5
	lea .maptex(pc),a0
	moveq #3,d6
.lickat
	move.w d5,d1
	moveq #0,d4
	lsr.w #1,d1
	bcc.b .nonext
	moveq #1,d4
.nonext
	lsl.w #8,d1
	add.w d4,d1
	move.w d1,(a0)+
	addq.w #1,d5
	dbf d6,.lickat
	lsl.w #6,d0
	lea (a5,d0.w,objtab.w),a0
	move.l _surfaces(a0),a1
	lsr.w #1,d2
	lsr.w #1,d3
	lea .maptex(pc),a6
	move.w d3,d7
	subq.w #1,d7
	move.w d3,a3
	bsr.b .kazwie
	addq.l #4,a6
	move.w d3,d7
	subq.w #1,d7
	move.w d3,a3
.kazwie
	move.l a3,d5
	mulu.w #$7f00,d5
	divu.w d3,d5
	move.w d5,a4
	subq.l #1,a3
	move.l a3,d5
	mulu.w #$7f00,d5
	divu.w d3,d5
	move.w d2,d6
	subq.w #1,d6
	move.w d2,a2
	move.w (a6),d1
	bsr.b .kazsur
	move.w d2,d6
	subq.w #1,d6
	move.w d2,a2
	move.w 2(a6),d1
	bsr.b .kazsur
	dbf d7,.kazwie
	rts
.kazsur
	move.w d1,4(a1)
	move.w a4,6+4(a1)
	move.w a4,12+4(a1)
	move.w d5,18+4(a1)
	move.w d5,24+4(a1)
	move.l a2,d4
	mulu.w #$7f00,d4
	divu.w d2,d4
	move.w d4,6+2(a1)
	move.w d4,24+2(a1)
	subq.l #1,a2
	move.l a2,d4
	mulu.w #$7f00,d4
	divu.w d2,d4
	move.w d4,12+2(a1)
	move.w d4,18+2(a1)
	lea 5*6(a1),a1
	dbf d6,.kazsur
	rts
.maptex	dc.l 0,0

morphinit:
	lea -4(a0),a6
	move.w (a6)+,d0
	lsl.w #6,d0
	move.w (a6)+,d1
	lsl.w #6,d1
	lea diffarr,a4
	move.l a4,(a6)+
	lea (a5,d0.w,objtab.w),a0
	lea (a5,d1.w,objtab.w),a1
	move.l _points(a0),a2
	move.l _points(a1),a3
	move.l _numpoints(a0),d7
	subq.w #1,d7
	moveq #12,d4
.licdif
	movem.l (a2)+,d0-d2
	sub.l (a3)+,d0
	sub.l (a3)+,d1
	sub.l (a3)+,d2
	movem.l d0-d2,(a4)
	add.w d4,a4
	dbf d7,.licdif
	move.l a4,(a6)+
	move.l _poivec(a0),a2
	move.l _poivec(a1),a3
	move.l _numpoints(a0),d7
	subq.w #1,d7
	moveq #12,d4
.licdip
	movem.l (a2)+,d0-d2
	sub.l (a3)+,d0
	sub.l (a3)+,d1
	sub.l (a3)+,d2
	movem.l d0-d2,(a4)
	add.w d4,a4
	dbf d7,.licdip
	move.l a4,(a6)+
	move.l _surfaces(a0),a2
	move.l _surfaces(a1),a3
	move.l _numsurfaces(a0),d7
	subq.w #1,d7
	moveq #14,d6
.licdic
	move.w 4(a2),d0
	move.w 4(a3),d3
	move.w d0,d1
	move.w d1,d2
	move.w d3,d4
	move.w d4,d5
	rol.w #4,d0
	rol.w #7,d1
	lsr.w #6,d2
	rol.w #4,d3
	rol.w #7,d4
	lsr.w #6,d5
	and.w d6,d0
	and.w d6,d1
	and.w d6,d2
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	sub.w d3,d0
	sub.w d4,d1
	sub.w d5,d2
	movem.w d0-d5,(a4)
	lea 12(a4),a4
	move.w (a2),d0
	mulu #6,d0
	lea 6(a2,d0.w),a2
	move.w (a3),d0
	mulu #6,d0
	lea 6(a3,d0.w),a3
	dbf d7,.licdic
	rts

runit:
	move.w d0,czas(a5)
	tst.w nument(a5)
	bne.b .jecoro
	move.w fracczas(a5),d0
	sub.w d0,czas(a5)
	bpl.b .wyczek
	move.w czas(a5),d0
	neg.w d0
	move.w d0,fracczas(a5)
	move.w #0,czas(a5)
	rts
.wyczek
	move.w czas(a5),fracczas(a5)
	move.w ttime(a5),fractime(a5)
	jsr insekr
	moveq #0,d1
	bsr initzbuf		;call initzbuf
        bsr rendscene		;call rendscene
	bsr copyscr		;call copyscr
	addq.w #1,fracou(a5)
	tst.w czas(a5)
	bne.b .wyczek
	move.w ttime(a5),d0
	sub.w fractime(a5),d0
	sub.w fracczas(a5),d0
	bpl.b .nodzid
	moveq #0,d0
.nodzid
	move.w d0,fracczas(a5)
	rts
.jecoro
	move.w d0,numrun(a5)
	move.l scene(a5),a0
	lea bufscene(a5),a1
.pecops
	rept 8
	move.l (a0)+,(a1)+
	endr
	tst.l (a0)
	bpl.b .pecops
	move.l lights(a5),a0
	lea buflights(a5),a1
.pecopl
	rept 8
	move.l (a0)+,(a1)+
	endr
	tst.l (a0)
	bpl.b .pecopl
	movem.l move_o(a5),d0-d2
	movem.l d0-d2,move_s(a5)
	movem.l ang_o(a5),d0-d2
	movem.l d0-d2,ang_s(a5)
	move.w fracczas(a5),d0
	sub.w d0,czas(a5)
	bpl.b .perun
	move.w #0,czas(a5)
.perun
	move.w czas(a5),fracczas(a5)
	move.w ttime(a5),fractime(a5)
	bsr.b .runone
	bsr insekr
	moveq #0,d1
	bsr initzbuf		;call initzbuf
        bsr rendscene		;call rendscene
        bsr copyscr		;call copyscr
	addq.w #1,fracou(a5)
	tst.w czas(a5)
	bne.b .perun
	bsr.b .runone
	move.w ttime(a5),d0
	sub.w fractime(a5),d0
	sub.w fracczas(a5),d0
	bpl.b .nodzir
	moveq #0,d0
.nodzir
	move.w d0,fracczas(a5)
	move.w #0,nument(a5)
	rts
.runone
	lea entries(a5),a0
	move.w nument(a5),d7
	subq.w #1,d7
	move.w numrun(a5),d6
	move.w d6,d5
	sub.w czas(a5),d5
	lea bufscene(a5),a1
	move.l scene(a5),a2
	lea buflights(a5),a3
	move.l lights(a5),a4
.eachen
	move.w (a0)+,d0
	move.l .sorten(pc,d0.w*4),a6
	jsr (a6)
	dbf d7,.eachen
	rts
.sorten	dc.l .movobj,.movfor,.movfou,.rotobj,.movspl,.movspd,.rotobs
	dc.l .movcam,.rotcam,.movcsp,.movlig,.rotlig,.movlsp,.movfoc
	dc.l .movfuc,.domorp

.domorp
	move.w (a0)+,d0
	lsl.w #6,d0
	move.w (a0)+,d1
	lsl.w #6,d1
	mpush a1-a4
	lea (a5,d0.w,objtab.w),a1
	lea (a5,d1.w,objtab.w),a2
	move.l _points(a1),a3
	move.l _points(a2),a4
	move.l _numpoints(a1),d4
	subq.w #1,d4
	move.l (a0)+,a6
	moveq #12,d3
	mpush d5-d6
	move.w d6,d2
	sub.w d5,d2
	move.w d2,d5
.morpoi
	movem.l (a6)+,d0-d2
	muls.w d5,d0
	muls.w d5,d1
	muls.w d5,d2
	divs.w d6,d0
	divs.w d6,d1
	divs.w d6,d2
	ext.l d0
	ext.l d1
	ext.l d2
	add.l (a4)+,d0
	add.l (a4)+,d1
	add.l (a4)+,d2
	movem.l d0-d2,(a3)
	add.w d3,a3
	dbf d4,.morpoi
	move.l (a0)+,a6
	move.l _poivec(a1),a3
	move.l _poivec(a2),a4
	move.l _numpoints(a1),d4
	subq.w #1,d4
.morpop
	movem.l (a6)+,d0-d2
	muls.w d5,d0
	muls.w d5,d1
	muls.w d5,d2
	divs.w d6,d0
	divs.w d6,d1
	divs.w d6,d2
	ext.l d0
	ext.l d1
	ext.l d2
	add.l (a4)+,d0
	add.l (a4)+,d1
	add.l (a4)+,d2
	movem.l d0-d2,(a3)
	add.w d3,a3
	dbf d4,.morpop
	move.l (a0)+,a6
	move.l _surfaces(a1),a3
	move.l _numsurfaces(a1),d4
	subq.w #1,d4
	moveq #14,d3
.morcol
	movem.w (a6)+,d0-d2
	muls.w d5,d0
	muls.w d5,d1
	muls.w d5,d2
	divs.w d6,d0
	divs.w d6,d1
	divs.w d6,d2
	add.w (a6)+,d0
	add.w (a6)+,d1
	add.w (a6)+,d2
	and.w d3,d0
	and.w d3,d1
	and.w d3,d2
	ror.w #4,d0
	ror.w #7,d1
	lsl.w #6,d2
	or.w d1,d0
	or.w d2,d0
	move.w d0,4(a3)
	move.w (a3),d0
	move.w d0,d1
	add.w d1,d1
	add.w d1,d0
	lea 6(a3,d0.w*2),a3
	dbf d4,.morcol
	mpop d5-d6
	mpop a1-a4
	lea 14(a0),a0
	rts

.movlsp
	move.w (a0)+,d0
	lsl.w #5,d0
	move.w d6,d4
	sub.w d5,d4
	; d5 - t, d6 - tm, d4 - tm-t
	lea bufobr,a6
	movem.l 16(a3,d0.w),d1-d3
	rept 2
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	movem.w d1-d3,(a6)
	movem.l 16(a3,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	add.l d1,d1
	add.l d2,d2
	add.l d3,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	movem.w d1-d3,6(a6)
	movem.l 16(a3,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	rept 2
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	ext.l d1
	ext.l d2
	ext.l d3
	movem.l d1-d3,16(a4,d0.w)
	addq.l #4,a0
	rts

.rotlig
	bsr.b .modrol
	lea 16(a0),a0
	bra.b .preplig

.movlig
	bsr.b .modrol
	movem.l (a0)+,d1-d3
.konmol
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	ext.l d1
	ext.l d2
	ext.l d3
	mpush d5-d6
	movem.l 16(a3,d0.w),d4-d6
	add.l d1,d4
	add.l d2,d5
	add.l d3,d6
	movem.l d4-d6,16(a4,d0.w)
	mpop d5-d6
	addq.l #4,a0
.preplig
	lea 4(a4,d0.w),a6
	movem.l (a6)+,d0-d2
	muls.w 2(a6),d0
	muls.w 6(a6),d1
	muls.w 10(a6),d2
	add.l d0,d2
	add.l d1,d2
	sub.l #dlsmooth*stdllen,d2
	move.l d2,12(a6)
	rts

.modrol
	move.w (a0)+,d0
	lsl.w #5,d0
	movem.l (a0)+,d1-d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	move.w #360,d4
	tst.w d1
	bpl.b .wlado1
.again1
	add.w d4,d1
	bmi.b .again1
.wlado1
	tst.w d2
	bpl.b .wlado2
.again2
	add.w d4,d2
	bmi.b .again2
.wlado2
	tst.w d3
	bpl.b .wlado3
.again3
	add.w d4,d3
	bmi.b .again3
.wlado3
	cmp.w d1,d4
	bhi.b .wlado4
	sub.w d4,d1
	bra.b .wlado3
.wlado4
	cmp.w d2,d4
	bhi.b .wlado5
	sub.w d4,d2
	bra.b .wlado4
.wlado5
	cmp.w d3,d4
	bhi.b .wlado6
	sub.w d4,d3
	bra.b .wlado5
.wlado6
	mpush d0-a5
	lea bufobr,a2
	movem.l d1-d3,(a2)
	lea 4(a3,d0.w),a0
	lea 4(a4,d0.w),a1
	moveq #1,d7
	bsr obrobl
	mpop d0-a5
	rts

.movcsp
	addq.l #2,a0
	move.w d6,d4
	sub.w d5,d4
	; d5 - t, d6 - tm, d4 - tm-t
	lea bufobr,a6
	movem.l move_s(a5),d1-d3
	rept 2
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	movem.w d1-d3,(a6)
	movem.l move_s(a5),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	add.l d1,d1
	add.l d2,d2
	add.l d3,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	movem.w d1-d3,6(a6)
	movem.l move_s(a5),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	rept 2
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	ext.l d1
	ext.l d2
	ext.l d3
	movem.l d1-d3,move_o(a5)
	addq.l #4,a0
	rts

.rotcam
	bsr.b .modroc
	lea 16(a0),a0
	rts

.modroc
	addq.l #2,a0
	movem.l (a0)+,d1-d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	mpush d5-d6
	movem.l ang_s(a5),d4-d6
	bsr obrkat
	movem.l d4-d6,ang_o(a5)
	mpop d5-d6
	rts

.movfuc
	bsr.b .modroc
	movem.l (a0)+,d1-d3
	mpush d0/d5-a5
	lea ang_s(a5),a2
	lea bufobr,a1
	movem.l d1-d3,(a1)
	move.l a1,a0
	moveq #1,d7
	bsr obrobl
	mpop d0/d5-a5
	movem.l bufobr,d1-d3
	bra.b .konmoc

.movfoc
	bsr.b .modroc
	movem.l (a0)+,d1-d3
	mpush d0/d5-a5
	lea ang_o(a5),a2
	lea bufobr,a1
	movem.l d1-d3,(a1)
	move.l a1,a0
	moveq #1,d7
	bsr obrobl
	mpop d0/d5-a5
	movem.l bufobr,d1-d3
	bra.b .konmoc

.movcam
	bsr.w .modroc
	movem.l (a0)+,d1-d3
.konmoc
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	ext.l d1
	ext.l d2
	ext.l d3
	mpush d5-d6
	movem.l move_s(a5),d4-d6
	add.l d1,d4
	add.l d2,d5
	add.l d3,d6
	movem.l d4-d6,move_o(a5)
	mpop d5-d6
	addq.l #4,a0
	rts

.movspd
	bsr.w .movspl
	lea -28(a0),a0
	lea bufobr,a6
	movem.l 16(a1,d0.w),d1-d3
	neg.w d4
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	movem.w d1-d3,(a6)
	neg.w d4
	sub.w d5,d4
	movem.l 16(a1,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	movem.w d1-d3,6(a6)
	movem.l 16(a1,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	lea -12(a6),a6
	movem.w d1-d3,(a6)
	muls.w d1,d1
	muls.w d2,d2
	muls.w d3,d3
	add.l d2,d1
	add.l d3,d1
	moveq #0,d2
	moveq #14,d3
.calsqr
	bset d3,d2
	move.w d2,d4
	mulu.w d4,d4
	cmp.l d4,d1
	bge.b .letitb
	bclr d3,d2
.letitb
	dbf d3,.calsqr
	movem.w (a6),d1/d3-d4
	muls.w #32767,d1
	move.l d2,8(a6)
	divs.l d2,d1
	bpl.b .wlazns
	neg.w d1
.wlazns
	push a1
	lea tabsin(a5),a1
	moveq #-1,d2
	moveq #90,d3
.arcsin
	addq.l #1,d2
	cmp.w (a1)+,d1
	dble d3,.arcsin
	move.l d2,8(a2,d0.w)
	move.w (a5,d2.w,tabsin+180.w),d2
	bne.b .mozdzi
	move.l #0,12(a2,d0.w)
	bra.b .gotall
.mozdzi
	move.l 8(a6),d3
	move.w 2(a6),d1
	muls.w #32767,d1
	divs.l d2,d1
	muls.w #32767,d1
	divs.l d3,d1
	move.w 4(a6),d4
	muls.w #32767,d4
	divs.l d2,d4
	muls.w #32767,d4
	divs.l d3,d4
	neg.l d4
	lea tabsin(a5),a1
	moveq #-1,d2
	move.w d2,a6
	move.l d4,d2
	bpl.b .jeplua
	neg.l d2
.jeplua
	moveq #90,d3
.arcsis
	addq.l #1,a6
	cmp.w (a1)+,d2
	dble d3,.arcsis
	move.l a6,d2
	tst.w d1
	bpl.b .cosdod
	tst.w d4
	bpl.b .sindod
	add.w #180,d2
	bra.b .pokonv
.sindod
	sub.w #180,d2
	neg.w d2
	bra.b .pokonv
.cosdod
	tst.w d4
	bpl.b .pokonv
	sub.w #360,d2
	neg.w d2
.pokonv
	move.l d2,12(a2,d0.w)
.gotall
	pop a1
	addq.l #4,a0
	rts

.movspl
	move.w (a0)+,d0
	lsl.w #5,d0
	move.w d6,d4
	sub.w d5,d4
	; d5 - t, d6 - tm, d4 - tm-t
	lea bufobr,a6
	movem.l 16(a1,d0.w),d1-d3
	rept 2
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	movem.w d1-d3,(a6)
	movem.l 16(a1,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	muls.w d4,d1
	muls.w d4,d2
	muls.w d4,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	add.l d1,d1
	add.l d2,d2
	add.l d3,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	movem.w d1-d3,6(a6)
	movem.l 16(a1,d0.w),d1-d3
	add.l (a0)+,d1
	add.l (a0)+,d2
	add.l (a0)+,d3
	rept 2
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	endr
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	add.w (a6)+,d1
	add.w (a6)+,d2
	add.w (a6)+,d3
	ext.l d1
	ext.l d2
	ext.l d3
	movem.l d1-d3,16(a2,d0.w)
	addq.l #4,a0
	rts

.movfou
	bsr.w .modrot
	movem.l (a0)+,d1-d3
	mpush d0/d5-a5
	lea 4(a2,d0.w),a2
	lea bufobr,a1
	movem.l d1-d3,(a1)
	move.l a1,a0
	moveq #1,d7
	bsr obrobl
	mpop d0/d5-a5
	movem.l bufobr,d1-d3
	bra.w .konmov

.movfor
	bsr.b .modrot
	movem.l (a0)+,d1-d3
	mpush d0/d5-a5
	lea 4(a1,d0.w),a2
	lea bufobr,a1
	movem.l d1-d3,(a1)
	move.l a1,a0
	moveq #1,d7
	bsr obrobl
	mpop d0/d5-a5
	movem.l bufobr,d1-d3
	bra.b .konmov

.rotobs
	move.w (a0)+,d0
	lsl.w #5,d0
	move.l (a0)+,d1
	muls.w d5,d1
	divs.w d6,d1
	mpush d5-d6
	push d0
	move.l 4(a1,d0.w),d4
	bsr obrkat
	pop d0
	move.l d4,4(a2,d0.w)
	mpop d5-d6
	lea 24(a0),a0
	rts

.rotobj
	bsr.b .modrot
	lea 16(a0),a0
	rts

.modrot
	move.w (a0)+,d0
	lsl.w #5,d0
	movem.l (a0)+,d1-d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	mpush d5-d6
	push d0
	movem.l 4(a1,d0.w),d4-d6
	bsr obrkat
	pop d0
	movem.l d4-d6,4(a2,d0.w)
	mpop d5-d6
	rts

.movobj
	bsr.b .modrot
	movem.l (a0)+,d1-d3
.konmov
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	divs.w d6,d1
	divs.w d6,d2
	divs.w d6,d3
	ext.l d1
	ext.l d2
	ext.l d3
	mpush d5-d6
	movem.l 16(a1,d0.w),d4-d6
	add.l d1,d4
	add.l d2,d5
	add.l d3,d6
	movem.l d4-d6,16(a2,d0.w)
	mpop d5-d6
	addq.l #4,a0
	rts

dofreeze:
	lea maizbuf,a0
	lea frezbuf,a1
	move.w #(yclip+1)*(xclip+1)/20,d7
	move.w #40,a6
.copyzb
	rept 2
	movem.l (a0)+,d0-d6/a2-a4
	movem.l d0-d6/a2-a4,(a1)
	add.w a6,a1
	endr
	dbf d7,.copyzb
	lea maiscr,a0
	lea frescr,a1
copback
	move.w #(yclip+1)*(xclip+1)/20,d7
	move.w #40,a6
.copysc
	movem.l (a0)+,d0-d6/a2-a4
	movem.l d0-d6/a2-a4,(a1)
	add.w a6,a1
	dbf d7,.copysc
	rts

copysfx:
	move.l screen(a5),a0
	lea truepal+131072,a4
	move.l screen(a5),a0
	move.l aekr(a5),a1
	move.l ekr(a5),a3
	lea 18(a1),a1
	lea 18(a3),a3
	moveq #60,d6
.kazkol
	move.l a1,a2
	move.w #$fff,d0
	moveq #31,d5
.wypbi1
	move.w d0,(a2)
	addq.l #4,a2
	dbf d5,.wypbi1
	addq.l #4,a2
	moveq #31,d5
.wypbi2
	move.w d0,(a2)
	addq.l #4,a2
	dbf d5,.wypbi2
	addq.l #4,a2
	moveq #25,d5
.wypbi3
	move.w d0,(a2)
	addq.l #4,a2
	dbf d5,.wypbi3
	addq.l #4,a2
	moveq #25,d5
.wypbi4
	move.w d0,(a2)
	addq.l #4,a2
	dbf d5,.wypbi4
	move.w #2,czas(a5)
.odczek
	tst.w czas(a5)
	bne.b .odczek
	move.l a1,a2
	move.l a3,a6
	moveq #15,d5
.kazwor
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	move.w 4(a2),4(a6)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	move.w (a2),(a6)
	addq.l #8,a2
	addq.l #8,a6
	dbf d5,.kazwor
	addq.l #4,a2
	addq.l #4,a6
	moveq #15,d5
.kazwoq
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	move.w 4(a2),4(a6)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	move.w (a2),(a6)
	addq.l #8,a2
	addq.l #8,a6
	dbf d5,.kazwoq
	addq.l #4,a2
	addq.l #4,a6
	moveq #12,d5
.kazwoe
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	move.w 4(a2),4(a6)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	move.w (a2),(a6)
	addq.l #8,a2
	addq.l #8,a6
	dbf d5,.kazwoe
	addq.l #4,a2
	addq.l #4,a6
	moveq #12,d5
.kazwol
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	move.w 4(a2),4(a6)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	move.w (a2),(a6)
	addq.l #8,a2
	addq.l #8,a6
	dbf d5,.kazwol
	lea linlen(a1),a1
	lea linlen(a3),a3
	dbf d6,.kazkol
	rts

copyscr:
	tst.w isfuck(a5)
	beq.b .nofuck
	move.l screen(a5),a0
	move.w #(yclip+1)*(xclip+1)-1,d7
	move.w fadfaz(a5),d1
	cmp.w #16,d1
	beq.b .nofuck
	moveq #$7f,d2
	moveq #$7f,d3
	not.w d3
.pefad
	move.w (a0),d0
	move.w d0,d4
	and.w d2,d4
	mulu.w d1,d4
	lsr.w #4,d4
	and.w d3,d0
	or.w d4,d0
	move.w d0,(a0)+
	dbf d7,.pefad
.nofuck
	tst.w trueflag(a5)
	beq.w normcop
	lea truepal+131072,a4
	move.l screen(a5),a0
	lea 29*2(a0),a0
	move.l ekr(a5),a1
	lea 18(a1),a1
	moveq #60,d6
.kazkol
	move.l a1,a2
	moveq #15,d5
.kazwor
	move.l (a0)+,d0
	move.l 0(a4,d0.w*4),d1
	move.w d1,4+33*4(a2)
	swap d1
	move.w d1,4(a2)
	swap d0
	move.l 0(a4,d0.w*4),d1
	move.w d1,33*4(a2)
	swap d1
	move.w d1,(a2)
	addq.l #8,a2
	dbf d5,.kazwor
	lea 34*4(a2),a2
	moveq #12,d5
.kazwoe
	move.l (a0)+,d0
	move.l 0(a4,d0.w*4),d1
	move.w d1,4+27*4(a2)
	swap d1
	move.w d1,4(a2)
	swap d0
	move.l 0(a4,d0.w*4),d1
	move.w d1,27*4(a2)
	swap d1
	move.w d1,(a2)
	addq.l #8,a2
	dbf d5,.kazwoe
	lea linlen(a1),a1
	lea 29*2*2(a0),a0
	dbf d6,.kazkol
	ifnd ondisk
.pause
	btst #2,$dff016
	beq.b .pause
	endif
        btst #6,$bfe001		;cmp al,27
        beq.w exit		;jnz @@petla
	rts
normcop
	lea truepal+131072,a4
	move.l screen(a5),a0
	move.l ekr(a5),a1
	lea 18(a1),a1
	moveq #60,d6
.kazkol
	move.l a1,a2
	moveq #15,d5
.kazwor
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	addq.l #8,a2
	dbf d5,.kazwor
	addq.l #4,a2
	moveq #15,d5
.kazwoq
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	addq.l #8,a2
	dbf d5,.kazwoq
	addq.l #4,a2
	moveq #12,d5
.kazwoe
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	addq.l #8,a2
	dbf d5,.kazwoe
	addq.l #4,a2
	moveq #12,d5
.kazwol
	move.l (a0)+,d0
	move.w 0(a4,d0.w*4),4(a2)
	swap d0
	move.w 0(a4,d0.w*4),(a2)
	addq.l #8,a2
	dbf d5,.kazwol
	lea linlen(a1),a1
	dbf d6,.kazkol
	ifnd ondisk
.pause
	btst #2,$dff016
	beq.b .pause
	endif
	btst #6,$bfe001		;cmp al,27
	beq.w exit		;jnz @@petla
	rts

initzbuf:
	tst.w frezflag(a5)
	beq.b .nofrezb
	move.l zbuffer(a5),a1
	lea frezbuf,a0
	move.w #(yclip+1)*(xclip+1)/20,d7
	move.w #40,a6
.copyzb
	rept 2
	movem.l (a0)+,d0-d6/a2-a4
	movem.l d0-d6/a2-a4,(a1)
	add.w a6,a1
	endr
	dbf d7,.copyzb
	move.l screen(a5),a1
	lea frescr,a0
	move.w #(yclip+1)*(xclip+1)/20,d7
	move.w #40,a6
.copysc
	movem.l (a0)+,d0-d6/a2-a4
	movem.l d0-d6/a2-a4,(a1)
	add.w a6,a1
	dbf d7,.copysc
	rts
.nofrezb
	push d1
	move.l zbuffer(a5),a0		;mov edi,zbuffer
	move.l #2147483647,d0		;mov eax,2147483647
	move.l d0,d1
	move.l d1,d2
	move.l d2,d3
	move.l d3,d4
	move.l d4,d5
	move.l d5,d6
	move.l d6,a2
	move.l d6,a3
	move.l d6,a4
	move.l #(yclip+1)*(xclip+1)/20,d7	;mov ecx,320*200
	move.w #80,a6
.wypzbuf			        ;cld
	movem.l d0-d6/a2-a4,(a0)			;mov edi,screen
	movem.l d0-d6/a2-a4,40(a0)
	add.w a6,a0
	dbf d7,.wypzbuf
	move.l screen(a5),a0
	move.w #((yclip+1)*(xclip+1)/20),d7
	pop d0
	tst.l d0
	bne.w .domirr
	tst.w shadflag(a5)
	beq.b .noshad
	moveq #yclip,d7
	moveq #$7f,d0
	move.w d0,d1
	not.w d1
	move.w shadsped(a5),d4
	subq.w #1,d4
	lsl.w #8,d4
	lea (a5,d4.w,(shadarr).w),a1
.kaslis
	moveq #xclip,d6
.kaspus
	move.w (a0),d2
	move.w d2,d3
	and.w d0,d2
	and.w d1,d3
	or.w 0(a1,d2.w*2),d3
	move.w d3,(a0)+
	dbf d6,.kaspus
	dbf d7,.kaslis
	rts
.noshad
	tst.w plasmflag(a5)
	beq.w .noplasm
	lea plasmsin(a5),a1
	move.w ttime(a5),d0
	move.w d0,d1
	and.w plasmp1(a5),d0
	mulu.w #360,d0
	move.w plasmp2(a5),d2
	lsr.l d2,d0
	lea 0(a1,d0.w*2),a2
	and.w plasmp3(a5),d1
	mulu.w #360,d1
	move.w plasmp4(a5),d2
	lsr.l d2,d1
	lea 0(a1,d1.w*2),a3
	move.w plasmcol(a5),d2
	lsl.w #7,d2
	moveq #yclip,d7
	move.w (a5,d0.w*2,tabsin.w),d3
	move.w (a5,d1.w*2,tabsin.w),d4
	muls.w plasmp5(a5),d3
	muls.w plasmp6(a5),d4
	asr.l #2,d3
	asr.l #2,d4
	add.l plasmp7(a5),d3
	add.l plasmp8(a5),d4
	move.l d3,a4
	move.l d4,a6
	moveq #0,d3
.kaplin
	moveq #xclip,d6
	move.w 0(a2,d3.w*2),d0
	swap d3
	add.l a4,d3
	swap d3
	add.w d2,d0
	move.l a3,a1
	moveq #0,d4
.kappun
	move.w 0(a1,d4.w*2),d1
	swap d4
	add.l a6,d4
	swap d4
	add.w d0,d1
	move.w d1,(a0)+
	dbf d6,.kappun
	dbf d7,.kaplin
	rts
.noplasm
	tst.w barflag(a5)
	bne.b .makbar
	tst.l background(a5)
	beq.w .domirr
	move.l a0,a1
	move.l background(a5),a0
	bra.w copback
.makbar
	move.l ascene(a5),d1
	beq.b .nochec
	cmp.l scene(a5),d1
	bne.w .domirr
.nochec
	tst.b barflag+1(a5)
	beq.w .normbar
	move.l move_o+4(a5),d0
	neg.l d0
	lsl.l #7,d0
	divs.l #1000,d0
	add.l #ycenter,d0
	bpl.b .rysgor
	moveq #0,d0
	bra.b .porygo
.rysgor
	moveq #0,d1
	move.w barcol(a5),d1
	lsl.w #7,d1
	cmp.w #yclip,d0
	ble.b .sure
	moveq #yclip,d0
.sure
	move.w d0,d7
	addq.w #1,d0
	move.l #120*65536,d2
	divu.l d0,d2
	addq.w #4,d1
	swap d1
.perygo
	moveq #xclip,d6
	swap d1
.kazpug
	move.w d1,(a0)+
	dbf d6,.kazpug
	swap d1
	add.l d2,d1
	dbf d7,.perygo
.porygo
	moveq #yclip,d7
	sub.w d0,d7
	bpl.b .jecory
	rts
.jecory
	move.w d7,d0
	addq.w #1,d0
	moveq #0,d1
	move.w bascol(a5),d1
	lsl.w #7,d1
	move.l #120*65536,d2
	divu.l d0,d2
	addq.w #4,d1
	swap d1
.peryse
	moveq #xclip,d6
	swap d1
.kazpus
	move.w d1,(a0)+
	dbf d6,.kazpus
	swap d1
	add.l d2,d1
	dbf d7,.peryse
	rts
.normbar
	move.w barcol(a5),d0
	lsl.w #7,d0
	addq.w #4,d0
	moveq #yclip,d7
.kazlib
	moveq #xclip,d6
.kazpub
	move.w d0,(a0)+
	dbf d6,.kazpub
	addq.w #2,d0
	dbf d7,.kazlib
	rts
.domirr
	move.l d0,d1
	move.l d1,d2
	move.l d2,d3
	move.l d3,d4
	move.l d4,d5
	move.l d5,d6
	move.l d6,a2
	move.l d6,a3
	move.l d6,a4
	move.w #40,a6
.wypscr				        ;rep stosd
	movem.l d0-d6/a2-a4,(a0)
	add.w a6,a0
	dbf d7,.wypscr
	tst.w starsflag(a5)
	beq.b .nostars
	bsr drawstars
.nostars
        rts				;ret

initanim:
	move.l 16(a0),a1
	lea textures,a2
	moveq #0,d0
	move.w d0,decrrep(a5)
	move.w d0,decrflag(a5)
	move.w (a0),d0
	moveq #0,d1
	lsr.w #1,d0
	bcc.b .noniep
	move.w #256,d1
.noniep
	swap d0
	add.l d1,d0
	add.l d0,a2
	moveq #127,d6
.kazlin
	moveq #127,d5
.kazkol
	getcrdata
	move.w d0,(a2)+
	dbf d5,.kazkol
	lea 256(a2),a2
	dbf d6,.kazlin
	move.l a1,12(a0)
	move.w #0,6(a0)
	rts

preplights:
	move.l lights(a5),a0
	move.l #0,numlights(a5)
	move.l #dlsmooth*stdllen,d6
	addq.l #4,a0
.liccon
	movem.l (a0)+,d0-d5
	muls.w d0,d3
	muls.w d1,d4
	muls.w d2,d5
	add.l d3,d5
	add.l d4,d5
	sub.l d6,d5
	move.l d5,(a0)+
	addq.l #1,numlights(a5)
	tst.l (a0)+
	bpl.b .liccon
	rts

initwave:
	lea objtab(a5),a0
	move.w waveobj(a5),d0
	lsl.w #6,d0
	add.w d0,a0
	lea diffarr,a1
	move.l _points(a0),a2
	move.l _numpoints(a0),d7
	subq.w #1,d7
	moveq #12,d3
.coppoi
	movem.l (a2)+,d0-d2
	movem.l d0-d2,(a1)
	add.w d3,a1
	dbf d7,.coppoi
	move.w ttime(a5),wavetime(a5)
	rts

initrend:
	move.l #maipoi,newpoi(a5)
	move.l #maivec,vector(a5)
	move.l #maicol,colpoi(a5)
	move.l #mainew,newvec(a5)
	move.l #maizbuf,zbuffer(a5)
	move.l #maiscr,screen(a5)
	rts

rendscene:
	tst.l extproc(a5)
	beq.b .noproc
	move.l extproc(a5),a0
	jsr (a0)
.noproc
	tst.l ascene(a5)
	beq.b .noalts
	push scene(a5)
	push lights(a5)
	movem.l move_o(a5),d0-d2
	movem.l ang_o(a5),d3-d5
	movem.l d0-d5,-(a7)
	moveq #0,d0
	moveq #0,d1
	moveq #0,d2
	movem.l d0-d2,move_o(a5)
	movem.l d0-d2,ang_o(a5)
	move.l ascene(a5),scene(a5)
	move.l alights(a5),lights(a5)
	bsr.b .noalts
	gettext 0
	moveq #0,d1
	bsr initzbuf
	movem.l (a7)+,d0-d5
	movem.l d0-d2,move_o(a5)
	movem.l d3-d5,ang_o(a5)
	pop lights(a5)
	pop scene(a5)
.noalts
	tst.w waveflag(a5)
	beq.b .nowave
	lea objtab(a5),a0
	move.w waveobj(a5),d0
	lsl.w #6,d0
	add.w d0,a0
	move.l _points(a0),a1
	move.l _numpoints(a0),d7
	subq.w #1,d7
	lea diffarr,a2
	move.w ttime(a5),d6
	sub.w wavetime(a5),d6
	move.w d6,d5
	cmp.w #128,d5
	ble.b .wlaamp
	move.w #128,d5
.wlaamp
	lsr.w #2,d5
	and.w #$3f,d6
	mulu #360,d6
	lsr.l #6,d6
	lea (a5,d6.w*2,tabsin.w),a3
	moveq #12,d4
	move.w #200,d3
.kazpun
	movem.l (a2)+,d0-d2
	add.w d3,d0
;	lsr.w #2,d0
	move.w 0(a3,d0.w*2),d0
	muls.w d5,d0
	add.l d0,d0
	swap d0
	add.w d0,d1
	add.w d0,d2
	movem.l d1-d2,4(a1)
	add.w d4,a1
	dbf d7,.kazpun
.nowave
	move.l numanims(a5),d7
	beq.w .noanim
	subq.w #1,d7
	lea arranims(a5),a6
.peroba
	move.l (a6)+,d0
	beq.w .thisno
	move.l d0,a0
	move.w ttime(a5),d0
	sub.w 8(a0),d0
	beq.w .thisno
	cmp.w 4(a0),d0
	ble.w .thisno
	move.w ttime(a5),8(a0)
	addq.w #1,6(a0)
	move.w 6(a0),d0
	cmp.w 2(a0),d0
	ble.b .nofirf
	bsr initanim
	bra.b .thisno
.nofirf
	move.l 12(a0),a1
	lea textures,a2
	moveq #0,d0
	move.w (a0),d0
	moveq #0,d1
	lsr.w #1,d0
	bcc.b .noniep
	move.w #256,d1
.noniep
	swap d0
	add.l d1,d0
	add.l d0,a2
	moveq #127,d6
.kazlin
	moveq #127,d5
.kazkol
	getcrdata
	tst.w d0
	bpl.b .nopowt
	neg.w d0
.zlicz
	addq.l #2,a2
	subq.w #1,d0
	beq.b .wyjzli
	dbf d5,.zlicz
	lea 256(a2),a2
	moveq #127,d5
	dbf d6,.zlicz
	bra.b .jupode
.nopowt
	lsl.w #4,d0
	move.w d0,(a2)+
.wyjzli
	dbf d5,.kazkol
	lea 256(a2),a2
	dbf d6,.kazlin
.jupode
	move.l a1,12(a0)
.thisno
	dbf d7,.peroba
.noanim
	lea poilights(a5),a1
	move.l lights(a5),a0
	move.l numlights(a5),d7
	subq.w #1,d7
	movem.l move_o(a5),d1-d3
	addq.l #4,a0
.getlig
	movem.l (a0)+,d4-d6
	movem.l d4-d6,(a1)
	movem.l (a0)+,d4-d6
	sub.l d1,d4
	sub.l d2,d5
	sub.l d3,d6
	movem.l d4-d6,12(a1)
	lea 24(a1),a1
	addq.l #8,a0
	dbf d7,.getlig
	lea poilights(a5),a0
	move.l a0,a1
	lea ang_o(a5),a2
	move.l numlights(a5),d7
	add.l d7,d7
	bsr obrobl

rendmirror:
	move.l scene(a5),a0		;mov ebp,offset scene
	move.l (a0),d0
	tst.w mirflag(a5)
	bne.b .perym
	tst.w cienflag(a5)
	bne.b .perym
.perys
	move.w 28(a0),d7
	bmi.b .noryto
	lsl.w #6,d0			;shl eax,6
	movem.l (a5,d0.w,objtab.w),d0-d6
	movem.l d0-d7,numcovers(a5)

	movem.l 4(a0),d0-d5
	movem.l d0-d2,ang(a5)
	movem.l move_o(a5),d0-d2
	sub.l d0,d3
	sub.l d1,d4
	sub.l d2,d5
	movem.l d3-d5,move(a5)
        				;lodsd
	push a0				;push ebp
	bsr rendobj			;call rendobj
	pop a0				;pop ebp
.noryto
	lea 32(a0),a0			;add ebp,32
	move.l (a0),d0			;cmp dword ptr [ebp],0
	bpl.s .perys			;jge @@perys
	rts				;ret
.perym
	move.w 28(a0),d7
	bmi.b .noryts
	tst.b 31(a0)
	bne.b .noryts
	lsl.w #6,d0			;shl eax,6
	movem.l (a5,d0.w,objtab.w),d0-d6
	movem.l d0-d7,numcovers(a5)

	movem.l 4(a0),d0-d5
	movem.l d0-d2,ang(a5)
	movem.l move_o(a5),d0-d2
	sub.l d0,d3
	sub.l d1,d4
	sub.l d2,d5
	movem.l d3-d5,move(a5)
        				;lodsd
	push a0				;push ebp
	bsr rendobj			;call rendobj
	pop a0				;pop ebp
.noryts
	lea 32(a0),a0			;add ebp,32
	move.l (a0),d0			;cmp dword ptr [ebp],0
	bpl.s .perym			;jge @@perys
	rts				;ret

	align 4,4
	; rodzaj.w+moc.w,kierx,kiery,kierz,x,y,z,bufor
prese_l	dc.l 9,0,0,0,0,0,0,0
	dc.l -1
prese	dc.l 37,0,135,0,0,0,180,0
	dc.l -1
intel_l	dc.l $00008,0,0,0,0,0,0,0
	dc.l -1
intel	dc.l 22,0,315,0,0,0,200,0
	dc.l -1
shock_l	dc.l $00009,0,0,0,0,0,0,0
	dc.l -1
shock	dc.l 25,0,0,0,0,0,256,$10000
	dc.l 25,180,0,0,0,0,-256,$10000
	dc.l 25,0,0,0,-256,0,512,$10000
	dc.l 25,0,0,0,256,0,512,$10000
	dc.l 25,90,0,0,-128,0,384,$10000
	dc.l 25,270,0,0,128,0,384,$10000
	dc.l 25,270,0,0,-384,0,128,$10000
	dc.l 25,270,0,0,-384,0,384,$10000
	dc.l 25,90,0,0,384,0,128,$10000
	dc.l 25,90,0,0,384,0,384,$10000
	dc.l 25,225,0,0,-256,0,-128,$10000
	dc.l 25,135,0,0,256,0,-128,$10000
	dc.l -1
mirr2_l	dc.l $00008,0,0,0,0,0,0,0
	dc.l -1
mirr2	dc.l 26,0,0,0,0,0,1020,$10000
	dc.l 20,0,0,0,0,0,120,$10001
	dc.l -1
tunel_l	dc.l $00009,0,0,0,0,0,0,0
	dc.l -1
tunel	dc.l 20,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l 21,0,0,0,0,0,0,$10000
	dc.l -1
union_l	dc.l $00008,0,0,0,0,0,0,0
	dc.l -1
union	dc.l 15,0,0,0,0,0,0,0
	dc.l 19,0,0,0,0,0,570,1
	dc.l -1
loves_l	dc.l 8,0,0,0,0,0,0,0
	dc.l -1
loves	dc.l 6,0,0,0,0,0,500,0
	dc.l 11,0,0,0,0,0,0,0
	dc.l -1
mirr1_l	dc.l $0000a,0,0,0,0,0,300,0
	dc.l $00005,0,0,0,0,0,0,0
	dc.l $00005,0,0,0,0,0,600,0
	dc.l -1
mirr1	dc.l 7,0,0,0,0,0,300,1
	dc.l 8,0,0,0,90,0,300,0
	dc.l 18,0,0,0,0,0,300,$10000
	dc.l -1
morps_l	dc.l 7,0,0,0,0,0,0,0
	dc.l -1
morps	dc.l 5,0,0,0,0,0,0,0
	dc.l -1
cosm2_l	dc.l 10,0,0,0,800,0,0,0
	dc.l -1
cosm2	dc.l 2,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l 10,0,0,0,0,0,0,0
	dc.l -1
cosm1_l	dc.l 10,0,0,0,800,0,0,0
	dc.l -1
cosm1	dc.l 1,0,0,90,0,0,1000,0
	dc.l 2,0,0,0,0,0,200,0
	dc.l 9,0,0,0,0,0,0,0
	dc.l 9,0,0,0,0,0,0,0
	dc.l -1
ncity_l	dc.l $000a,stdllen,0,0,0,0,0,0
	dc.l $000a,stdllen,0,0,-250,-140,300,0
	dc.l -1
ncity	dc.l 12,0,0,0,100,0,150,0
	dc.l 13,0,0,0,-400,0,300,0
	dc.l 13,0,0,0,-200,0,400,0
	dc.l 13,0,0,0,0,0,350,0
	dc.l 13,0,0,0,-150,0,200,0
	dc.l 13,0,0,0,-400,0,120,0
	dc.l 12,0,0,0,-200,0,0,0
	dc.l -1
room_l	dc.l 8,0,0,0,200,-100,700,0
	dc.l -1
room	dc.l 23,0,0,0,0,0,500,0
	dc.l 24,0,0,0,200,-50,700,$10000
	dc.l -1
stret_l	dc.l 7,0,0,0,-150,-84,450,0
	dc.l 7,0,0,0,-150,-84,350,0
	dc.l 1,stdllen,0,0,300,-30,400,0
	dc.l -1
stret	dc.l 27,0,0,0,-150,-34,450,$10000
	dc.l 27,0,0,0,-150,-34,350,$10000
	dc.l 34,180,0,0,300,6,400,0
	dc.l 36,180,0,0,300,6,400,$10000
	dc.l 28,90,0,0,0,0,500,0
	dc.l 29,90,0,0,0,0,300,0
	dc.l 30,90,0,0,-300,0,500,0
	dc.l 31,90,0,0,-300,0,300,0
	dc.l 32,0,0,0,-600,0,400,0
	dc.l -1
shads_l	dc.l 8,0,0,0,100,-100,200,0
	dc.l 4,0,0,0,0,0,0,0
	dc.l -1
shads	dc.l 18,0,0,0,100,-100,200,$10001
	dc.l 14,0,0,90,-200,0,230,0
	dc.l 40,0,0,0,10,0,200,0
	dc.l 40,0,0,0,60,0,300,0
	dc.l 40,0,0,0,-80,0,260,0
	dc.l 35,0,0,90,0,75,200,1
	dc.l -1
bells_l	dc.l 8,0,0,0,0,0,0,0
	dc.l -1
bells	dc.l 33,0,0,0,150,0,200,0
	dc.l -1
glas_l	dc.l 8,0,0,0,0,0,0,0
	dc.l -1
glas	dc.l 8,0,0,0,0,0,100,$2010000
	dc.l -1
rips_l	dc.l 8,0,0,0,0,0,-100,0
	dc.l 8,0,0,0,300,0,200,0
	dc.l -1
rips	dc.l 43,270,0,0,0,0,200,0
	dc.l 42,0,0,0,-30,-9,100,0
	dc.l 42,50,0,0,-80,-9,20,0
	dc.l 42,100,0,0,50,-9,50,0
	dc.l 42,150,0,0,10,-9,-50,0
	dc.l 41,0,0,0,-10,-1,60,0
	dc.l -1
posws_l	dc.l 8,0,0,0,100,0,0,0
	dc.l -1
posws	dc.l 39,0,0,0,0,0,400,0
	dc.l -1
sphs_l	dc.l 8,0,0,0,100,0,1000,0
	dc.l -1
sphs	dc.l 44,0,0,0,0,0,0,0
	dc.l 45,0,0,0,0,0,0,0
	dc.l 46,0,0,0,0,0,0,0
	dc.l 47,0,0,0,0,0,0,0
	dc.l 48,0,0,0,0,0,0,0
	dc.l -1
chaos_l	dc.l 9,0,0,0,0,0,0,0
	dc.l -1
chaos	dc.l 38,0,0,0,-250,0,520,0
	dc.l -1

rendobj:

cbase   equ 0
ilrys   equ 4
xf      equ 8
yf      equ 12
zf      equ 16
cf      equ 20
txf     equ 24
tyf     equ 26
xn      equ 28
yn      equ 32
zn      equ 36
cn      equ 40
txn     equ 44
tyn     equ 46
xfc     equ 48
yfc     equ 52
zfc     equ 56
cfc     equ 60
xfe     equ 64
yfe     equ 68
txfc    equ 72
tyfc    equ 74
xnc     equ 76
ync     equ 80
znc     equ 84
cnc     equ 88
xne     equ 92
yne     equ 96
txnc    equ 100
tync    equ 102
xd      equ 104
yd      equ 108
zd      equ 112
cd      equ 116
xde     equ 120
yde     equ 124
txd     equ 128
tyd     equ 130
miny    equ 132
maxy    equ 136
drx     equ 140
drz     equ 144
drc     equ 148
ldir    equ 152
ofs     equ 156
ilpun   equ 160
xlc     equ 164
ylc     equ 168
zlc     equ 172
clc     equ 176
xle     equ 180
yle     equ 184
txl     equ 188
tyl     equ 190
bufrys  equ 192

	move.l points(a5),a0		;mov esi,points
	lea bufobr,a1			;mov edi,bufobr
	move.l numpoints(a5),d7		;mov ecx,numpoints
	lea ang(a5),a2			;mov ebp,offset ang
	bsr supobl			;call supobl
	lea bufobr,a0			;mov esi,bufobr
	move.l newpoi(a5),a1		;mov edi,newpoi
        move.l numpoints(a5),d7		;mov ecx,numpoints
	lea ang_o(a5),a2		;mov ebp,offset ang_o
	bsr obrobl			;call obrobl

	move.l poivec(a5),a0		;mov esi,poivec
	lea bufobr,a1			;mov edi,bufobr
	move.l numpoints(a5),d7		;mov ecx,numpoints
	lea ang(a5),a2			;mov ebp,offset ang
	bsr obrobl			;call obrobl
	lea bufobr,a0			;mov esi,bufobr
	move.l newvec(a5),a1		;mov edi,newvec
	move.l numpoints(a5),d7		;mov ecx,numpoints
	lea ang_o(a5),a2		;mov ebp,offset ang_o
	bsr obrobl			;call obrobl

	move.l colpoi(a5),a3
	move.l numpoints(a5),d7
	subq.l #1,d7
	moveq #0,d0
	moveq #12,d1
.kascop
	move.l d0,(a3)
	add.l d1,a3
	dbf d7,.kascop
	tst.b reserved+3(a5)
	bne.w indlight
	push a5
	lea poilights(a5),a6
	move.l lights(a5),a5
.kazligh
	move.l numpoints0,d7		;mov ebp,numpoints
	subq.w #1,d7
	move.l newpoi0,a0		;mov esi,newpoi
	move.l newvec0,a1		;mov edi,vispoi
	move.l colpoi0,a3
	move.l (a5),d0
	tst.w (a5)
	beq.w .nodirl
.calvid
	movem.l (a6),d3-d4/d6
	muls.w 2(a0),d3
	muls.w 6(a0),d4
	muls.w 10(a0),d6
	add.l d3,d6
	add.l d4,d6
	sub.l 28(a5),d6
	bpl.b .licnor
	lea 12(a0),a0
	bra.b .nominud
.licnor
	lsr.l #stdllog,d6
	cmp.l #2*dlsmooth,d6
	ble.b .noodgo
	move.l #2*dlsmooth,d6
.noodgo
	movem.l 12(a6),d3-d5
	sub.l (a0)+,d3
	move.w d3,d2
	muls.w d2,d2			;imul eax
	move.l d2,d1			;mov ebx,eax
	sub.l (a0)+,d4
	move.w d4,d2
	muls.w d2,d2			;imul eax
	add.l d2,d1			;add ebx,eax
	sub.l (a0)+,d5
	move.w d5,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	muls.w 2(a1),d3
	muls.w 6(a1),d4
	muls.w 10(a1),d5
	add.l d3,d4
	add.l d4,d5
	lsl.l d0,d5
	rol.l #8,d5
	move.b d5,d4
	extb.l d4
	divs.l d1,d4:d5
	tst.l d5			;add eax,ebx
	bmi.b .nominud			;jge @@nominus
	cmp.l #65535,d5
	ble.b .wporzo
	moveq #0,d5
	not.w d5
.wporzo
	mulu.l d6,d5
	lsr.l #dlsmlog+1,d5
	add.l d5,(a3)
.nominud
	lea 12(a3),a3
	lea 12(a1),a1
	dbf d7,.calvid			;dec ebp
	lea 24(a6),a6
	bra.b .nextlig
.nodirl
	lea 12(a6),a6
.calvip
	movem.l (a6),d3-d5
	sub.l (a0)+,d3
	move.l d3,d2
	muls.w d2,d2			;imul eax
	move.l d2,d1			;mov ebx,eax
	sub.l (a0)+,d4
	move.l d4,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	sub.l (a0)+,d5
	move.l d5,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	muls.w 2(a1),d3
	muls.w 6(a1),d4
	muls.w 10(a1),d5
	add.l d3,d4
	add.l d4,d5
	lsl.l d0,d5
	rol.l #8,d5
	move.b d5,d4
	extb.l d4
	divs.l d1,d4:d5
	tst.l d5			;add eax,ebx
	bmi.b .nominus			;jge @@nominus
	add.l d5,(a3)
.nominus
	lea 12(a3),a3
	lea 12(a1),a1
	dbf d7,.calvip			;dec ebp
	lea 12(a6),a6
.nextlig
	lea 32(a5),a5
	tst.l (a5)
	bpl.w .kazligh
	pop a5 				;jnz @@calvip
	bra.w gotlight
indlight
	push a5
	lea poilights(a5),a6
	move.l lights(a5),a5
.kazligh
	move.l numpoints0,d7		;mov ebp,numpoints
	subq.w #1,d7
	move.l newpoi0,a0		;mov esi,newpoi
	move.l newvec0,a1		;mov edi,vispoi
	move.l colpoi0,a3
	move.l (a5),d0
	tst.w (a5)
	beq.w .nodirl
.calvid
	movem.l (a6),d3-d4/d6
	muls.w 2(a0),d3
	muls.w 6(a0),d4
	muls.w 10(a0),d6
	add.l d3,d6
	add.l d4,d6
	sub.l 28(a5),d6
	bpl.b .licnor
	lea 12(a0),a0
	bra.b .nominud
.licnor
	lsr.l #stdllog,d6
	cmp.l #2*dlsmooth,d6
	ble.b .noodgo
	move.l #2*dlsmooth,d6
.noodgo
	movem.l 12(a6),d3-d5
	sub.l (a0)+,d3
	move.w d3,d2
        muls.w d2,d2			;imul eax
        move.l d2,d1			;mov ebx,eax
	sub.l (a0)+,d4
	move.w d4,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	sub.l (a0)+,d5
	move.w d5,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	muls.w 2(a1),d3
	muls.w 6(a1),d4
	muls.w 10(a1),d5
	add.l d3,d4
	add.l d4,d5
	lsl.l d0,d5
	rol.l #8,d5
	move.b d5,d4
	extb.l d4
	divs.l d1,d4:d5
	tst.l d5			;add eax,ebx
	bpl.b .beznom			;jge @@nominus
	neg.l d5
.beznom
	cmp.l #65535,d5
	ble.b .wporzo
	moveq #0,d5
	not.w d5
.wporzo
	mulu.l d6,d5
	lsr.l #dlsmlog+1,d5
	add.l d5,(a3)
.nominud
	lea 12(a3),a3
	lea 12(a1),a1
	dbf d7,.calvid			;dec ebp
	lea 24(a6),a6
	bra.b .nextlig
.nodirl
	lea 12(a6),a6
.calvip
	movem.l (a6),d3-d5
	sub.l (a0)+,d3
	move.w d3,d2
        muls.w d2,d2			;imul eax
        move.l d2,d1			;mov ebx,eax
	sub.l (a0)+,d4
	move.w d4,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	sub.l (a0)+,d5
	move.w d5,d2
	muls.w d2,d2			;imul eax
        add.l d2,d1			;add ebx,eax
	muls.w 2(a1),d3
	muls.w 6(a1),d4
	muls.w 10(a1),d5
	add.l d3,d4
	add.l d4,d5
	lsl.l d0,d5
	rol.l #8,d5
	move.b d5,d4
	extb.l d4
	divs.l d1,d4:d5
	tst.l d5			;add eax,ebx
	bpl.b .nominus			;jge @@nominus
	neg.l d5
.nominus
	add.l d5,(a3)
	lea 12(a3),a3
	lea 12(a1),a1
	dbf d7,.calvip			;dec ebp
	lea 12(a6),a6
.nextlig
	lea 32(a5),a5
	tst.l (a5)
	bpl.w .kazligh
	pop a5 				;jnz @@calvip
gotlight
	tst.w cienflag(a5)
	beq.w .noshadow
	move.l newpoi(a5),a0
	move.l numpoints(a5),d7
	move.w #12,a1
	subq.w #1,d7
	move.l lights(a5),a2
	lea 16(a2),a2
.ciepun
	movem.l (a0),d0-d2
	move.l d0,d3
	move.l d1,d4
	move.l d2,d6
	sub.l (a2),d3
	sub.l 4(a2),d4
	sub.l 8(a2),d6
	move.l d3,a3
	move.l d4,a4
	move.l d6,a6
	muls.w shad_a(a5),d3
	muls.w shad_b(a5),d4
	muls.w shad_c(a5),d6
	add.l d3,d6
	add.l d4,d6
	beq.b .okupa
	muls.w shad_a(a5),d0
	muls.w shad_b(a5),d1
	muls.w shad_c(a5),d2
	add.l d2,d0
	add.l d1,d0
	move.l shad_d(a5),d5
	sub.l d0,d5
	rol.l #8,d5
	move.b d5,d4
	extb.l d4
	divs.l d6,d4:d5
	move.l a3,d0
	move.l a4,d1
	move.l a6,d2
	muls.l d5,d0
	muls.l d5,d1
	muls.l d5,d2
	asr.l #8,d0
	asr.l #8,d1
	asr.l #8,d2
	add.l (a0),d0
	add.l 4(a0),d1
	add.l 8(a0),d2
.okupa
	movem.l d0-d2,(a0)
	add.l a1,a0
	dbf d7,.ciepun
	bra.b .gotcols
.noshadow

	move.l #65535,d6
	move.l colpoi(a5),a3
	move.l numpoints(a5),d7
	subq.l #1,d7
	moveq #12,d1
.dopako
	move.l (a3),d5
	cmp.l d6,d5			;cmp eax,65535
	ble.b .wzakr			;jle @@wzakr
	move.l d6,d5			;mov eax,65535
.wzakr
	lsl.l #7,d5			;shr eax,3
	move.l d5,(a3)
	add.l d1,a3
	dbf d7,.dopako
.gotcols
	tst.w mirflag(a5)
	beq.w .nomirror
	move.l newpoi(a5),a0
	move.l numpoints(a5),d7
	move.w #12,a1
	subq.w #1,d7
	move.l mir_n(a5),d0
	asr.l #8,d0
	tst.l d0
	bne.b .makmir
	moveq #1,d0
.makmir
	movem.l (a0),d1-d3
	move.l d1,d4
	move.l d2,d5
	move.l d3,d6
	muls.w mir_a(a5),d4
	muls.w mir_b(a5),d5
	muls.w mir_c(a5),d6
	add.l d6,d4
	add.l d5,d4
	sub.l mir_d(a5),d4
	asr.l #8,d4
	move.l d4,d5
	move.w mir_a(a5),d6
	ext.l d6
	muls.l d6,d5
	divs.l d0,d5
	add.l d5,d5
	sub.l d5,d1
	move.l d4,d5
	move.w mir_b(a5),d6
	ext.l d6
	muls.l d6,d5
	divs.l d0,d5
	add.l d5,d5
	sub.l d5,d2
	move.w mir_c(a5),d6
	ext.l d6
	muls.l d6,d4
	divs.l d0,d4
	add.l d4,d4
	sub.l d4,d3
	movem.l d1-d3,(a0)
	add.l a1,a0
	dbf d7,.makmir
.nomirror

	move.l numsurfaces(a5),a0	;mov ecx,numsurfaces
	move.l vector(a5),a1		;mov edi,vector
	move.l surfaces(a5),a2		;mov ebp,surfaces
	move.l newpoi(a5),a3		;mov ebx,newpoi
.kazsur
	move.w (a2),d0
	move.w (a5,d0.w*2,tabsur.w),d0
	move.w 6(a2),d1
	lea 0(a3,d1.w*2),a6
	movem.l 0(a3,d1.w*2),d2-d4
	move.w 6(a2,d0.w*2),d1
	movem.l 0(a3,d1.w*2),d5-d7
	move.w 6(a2,d0.w*4),d1
	movem.l 0(a3,d1.w*2),d0-d1/a4
	sub.l d2,d5
	sub.l d0,d2
	sub.l d3,d6
	sub.l d1,d3
	sub.l d4,d7
	sub.l a4,d4
	move.l d2,d0
	move.l d3,d1
	muls.w d6,d0
	muls.w d5,d1
	sub.l d1,d0
	asr.l #2,d0
	move.l 8(a6),d1
	asr.l #2,d1
	muls.w d1,d0
	muls.w d7,d3
	muls.w d4,d6
	sub.l d6,d3
	asr.l #2,d3
	move.l (a6)+,d1
	asr.l #2,d1
	muls.w d1,d3
	add.l d3,d0
	muls.w d5,d4
	muls.w d7,d2
	sub.l d2,d4
	asr.l #2,d4
	move.l (a6),d1
	asr.l #2,d1
	muls.w d1,d4
	add.l d4,d0
        				;pop ebx
	move.l d0,(a1)+			;stosd
	move.w (a2),d0			;movzx eax,word ptr [ebp]
	move.w d0,d1			;lea eax,[eax*2+eax]
	add.w d1,d1
	add.w d1,d0
	lea 6(a2,d0.w*2),a2		;lea ebp,[ebp+eax*2+6]
	subq.l #1,a0
	move.l a0,d0
	bne.w .kazsur			;loop @@kazsur

	push a5
	move.l numsurfaces(a5),d7	;mov ecx,numsurfaces
	subq.w #1,d7
	move.l vector(a5),a0		;mov esi,vector
	lea dvars(pc),a6		;mov ebp,offset dvars
	move.l surfaces(a5),a4		;mov edi,surfaces
	tst.w mirflag(a5)
	bne.w .rysmir
	tst.b reserved+2(a5)
	bne.b .rysall
	tst.w cienflag(a5)
	beq.b .ryspla
	move.l #0,cbase(a6)
.ryscie
	tst.l (a0)+			;cmp dword ptr [esi],0
	bpl.b .noryc			;jge @@norys
	push a0				;push esi
	push d7				;push ecx
	bsr drblack
	pop d7				;pop ecx
	pop a0				;pop esi
.noryc
        				;add esi,4
	move.w (a4),d0			;movzx eax,word ptr [edi]
	move.w d0,d1
	add.w d1,d1
	add.w d1,d0			;lea eax,[eax*2+eax]
	lea 6(a4,d0.w*2),a4		;lea edi,[edi+eax*2+6]
	dbf d7,.ryscie			;loop @@ryspla
	pop a5
	rts				;ret
.rysall
	push d7				;push ecx
	move.w 2(a4),d0
	move.l tabdraw(pc,d0.w*4),a0
	jsr (a0)
	pop d7				;pop ecx
.noryal
        				;add esi,4
	move.w (a4),d0			;movzx eax,word ptr [edi]
	move.w d0,d1
	add.w d1,d1
	add.w d1,d0			;lea eax,[eax*2+eax]
	lea 6(a4,d0.w*2),a4		;lea edi,[edi+eax*2+6]
	dbf d7,.rysall			;loop @@ryspla
	pop a5
	rts				;ret
.ryspla
	tst.l (a0)+			;cmp dword ptr [esi],0
	bpl.b .norys			;jge @@norys
	push a0				;push esi
	push d7				;push ecx
	move.w 2(a4),d0
	move.l tabdraw(pc,d0.w*4),a0
	jsr (a0)
	pop d7				;pop ecx
	pop a0				;pop esi
.norys
        				;add esi,4
	move.w (a4),d0			;movzx eax,word ptr [edi]
	move.w d0,d1
	add.w d1,d1
	add.w d1,d0			;lea eax,[eax*2+eax]
	lea 6(a4,d0.w*2),a4		;lea edi,[edi+eax*2+6]
	dbf d7,.ryspla			;loop @@ryspla
	pop a5
	rts				;ret
.rysmir
	tst.l (a0)+			;cmp dword ptr [esi],0
	bmi.b .norym			;jge @@norys
	push a0				;push esi
	push d7				;push ecx
	move.w 2(a4),d0
	move.l tabdraw(pc,d0.w*4),a0
	jsr (a0)
	pop d7				;pop ecx
	pop a0				;pop esi
.norym
        				;add esi,4
	move.w (a4),d0			;movzx eax,word ptr [edi]
	move.w d0,d1
	add.w d1,d1
	add.w d1,d0			;lea eax,[eax*2+eax]
	lea 6(a4,d0.w*2),a4		;lea edi,[edi+eax*2+6]
	dbf d7,.rysmir			;loop @@ryspla
	pop a5
	rts				;ret
tabdraw	dc.l drtext,drtexf,drshad,drflat,drmirr,drcien

drcien:
	lea vars,a5
	tst.w cienflag(a5)
	beq.b .spoko
	cmp.l shad_id(a5),a4
	bne.w drflat
	rts
.spoko
	move.l a4,shad_id(a5)
	move.l newpoi(a5),a3		;mov ebx,newpoi
	move.w (a4),d0
	move.w (a5,d0.w*2,tabsur.w),d0
	move.w 6(a4),d1
	lea 0(a3,d1.w*2),a6
	movem.l 0(a3,d1.w*2),d2-d4
	move.w 6(a4,d0.w*2),d1
	movem.l 0(a3,d1.w*2),d5-d7
	move.w 6(a4,d0.w*4),d1
	movem.l 0(a3,d1.w*2),d0-d1/a2
	sub.l d2,d5
	sub.l d0,d2
	sub.l d3,d6
	sub.l d1,d3
	sub.l d4,d7
	sub.l a2,d4
	move.l d2,d0
	move.l d3,d1
	muls.w d6,d0
	muls.w d5,d1
	sub.l d1,d0
;	neg.l d0
	asr.l #2,d0
	move.w d0,shad_c(a5)
	muls.w d7,d3
	muls.w d4,d6
	sub.l d6,d3
;	neg.l d3
	asr.l #2,d3
	move.w d3,shad_a(a5)
	muls.w d5,d4
	muls.w d7,d2
	sub.l d2,d4
;	neg.l d4
	asr.l #2,d4
	move.w d4,shad_b(a5)
	move.w shad_a(a5),d0
	muls.w 2(a6),d0
	move.w shad_b(a5),d1
	muls.w 6(a6),d1
	move.w shad_c(a5),d2
	muls.w 10(a6),d2
	add.l d1,d0
	add.l d2,d0
	move.l d0,shad_d(a5)
	move.l #mirpoi,newpoi(a5)
	move.l #mirvec,vector(a5)
	move.l #mircol,colpoi(a5)
	move.l #mirnew,newvec(a5)
	move.l #mirzbuf,zbuffer(a5)
	move.l #mirscr,screen(a5)
	move.w 4(a4),d1
	swap d1
	move.w 4(a4),d1
	bsr initzbuf
	movem.l numcovers(a5),d0-d7
	movem.l d0-d7,mirbuf(a5)
	st cienflag(a5)
	bsr rendmirror
	lea vars,a5
	bsr initrend
	sf cienflag(a5)
	movem.l mirbuf(a5),d0-d7
	movem.l d0-d7,numcovers(a5)

	move.l shad_id(a5),a4
	lea dvars,a6
	move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
	moveq #0,d0
	move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
	move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
	move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
	move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
	move.w (a4),d0			;movzx eax,word ptr [edi]
	subq.w #1,d0			;dec eax
	move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
	addq.l #6,a4			;add edi,6
	move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
	move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;add edi,6
	move.l newpoi0,a3		;mov esi,newpoi
	move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
	move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
	move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
.pedraw
	bsr .moddraw			;call @@moddraw
	subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
	bne.b .pedraw			;jnz @@pedraw
	move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
        bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi

.kondraw
	move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
	sub.w miny(a6),d7		;sub ecx,[ebp+miny]
	ble.w .nodraw			;jle @@nodraw
	push a4				;push edi
	move.l zbuffer0,a0		;mov esi,zbuffer
	move.l screen0,a1		;mov edi,screen
	lea mirscr,a2
	move.w miny(a6),d0		;mov eax,[ebp+miny]
	move.w d0,d1			;mov ebx,eax
	lsl.l #5,d0			;shl eax,5
	mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
	lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	add.l d1,a2
        lea (a6,d0.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
.perys
	mpush d7-a2			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
	bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
	lea 0(a2,d3.w*2),a2
	sub.w d3,d4			;sub ecx,ebx
	ble.w .strange			;jl @@strange
	move.w d4,d7			;inc ecx
	addq.w #1,d4			;mov ebx,ecx
	move.l 12(a6),d5		;mov eax,[ebp+12]
	sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
	divs.w d4,d5			;idiv ebx
	ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
	lea 0(a2,d4.w*2),a2
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
        				;jmp short @@pepun
.pepun
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .dalej			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
	move.w (a2)+,(a1)+		;mov [edi],eax
	add.l d5,a3
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
	addq.l #2,a2
	dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a2			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
	lea (xclip+1)*2(a2),a2
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
	lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;push ebp
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
	clipif .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
	clipif .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.w .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.w .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.w .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.w .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a1,a0
.nqrig1

        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xfe(a6),a1			;lea edi,[ebp+xfe]
        tst.l (a0)			;cmp dword ptr [esi],0
        bmi.b .isfir			;jl @@isfir
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .musdra			;jnz @@musdra
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .docopy			;jz @@docopy
.musdra
        bsr .drawit			;call @@drawit
        bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 4				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .peput
	push d0
	move.l d3,d0
	subq.w #1,d0
.pecli
        add.l d5,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
        dbf d0,.pecli			;loop @@peput
	pop d0
.peput
	move.l a3,(a2)			;mov [edi],eax
	move.l d4,8(a2)			;mov [edi+8],ebx
	add.l d5,a3			;add eax,[ebp+drx]
	add.l d6,d4			;add ebx,[ebp+drz]
	add.l d1,a2			;add edi,1
				;@@modme2:
	dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

drmirr:
	lea vars,a5
	tst.w mirflag(a5)
	beq.b .spoko
	cmp.l mir_id(a5),a4
	bne.w drflat
	rts
.spoko
	move.l a4,mir_id(a5)
	move.l newpoi(a5),a3		;mov ebx,newpoi
	move.w (a4),d0
	move.w (a5,d0.w*2,tabsur.w),d0
	move.w 6(a4),d1
	lea 0(a3,d1.w*2),a6
	movem.l 0(a3,d1.w*2),d2-d4
	move.w 6(a4,d0.w*2),d1
	movem.l 0(a3,d1.w*2),d5-d7
	move.w 6(a4,d0.w*4),d1
	movem.l 0(a3,d1.w*2),d0-d1/a2
	sub.l d2,d5
	sub.l d0,d2
	sub.l d3,d6
	sub.l d1,d3
	sub.l d4,d7
	sub.l a2,d4
	move.l d2,d0
	move.l d3,d1
	muls.w d6,d0
	muls.w d5,d1
	sub.l d1,d0
;	neg.l d0
	asr.l #2,d0
	move.w d0,mir_c(a5)
	muls.w d0,d0
	muls.w d7,d3
	muls.w d4,d6
	sub.l d6,d3
;	neg.l d3
	asr.l #2,d3
	move.w d3,mir_a(a5)
	muls.w d3,d3
	add.l d3,d0
	muls.w d5,d4
	muls.w d7,d2
	sub.l d2,d4
;	neg.l d4
	asr.l #2,d4
	move.w d4,mir_b(a5)
	muls.w d4,d4
	add.l d4,d0
	move.l d0,mir_n(a5)
	move.w mir_a(a5),d0
	muls.w 2(a6),d0
	move.w mir_b(a5),d1
	muls.w 6(a6),d1
	move.w mir_c(a5),d2
	muls.w 10(a6),d2
	add.l d1,d0
	add.l d2,d0
	move.l d0,mir_d(a5)
	move.l #mirpoi,newpoi(a5)
	move.l #mirvec,vector(a5)
	move.l #mircol,colpoi(a5)
	move.l #mirnew,newvec(a5)
	move.l #mirzbuf,zbuffer(a5)
	move.l #mirscr,screen(a5)
	move.w 4(a4),d1
	swap d1
	move.w 4(a4),d1
	bsr initzbuf
	movem.l numcovers(a5),d0-d7
	movem.l d0-d7,mirbuf(a5)
	st mirflag(a5)
	bsr rendmirror
	lea vars,a5
	bsr initrend
	sf mirflag(a5)
	movem.l mirbuf(a5),d0-d7
	movem.l d0-d7,numcovers(a5)

	move.l mir_id(a5),a4
	lea dvars,a6
	move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
	moveq #0,d0
	move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
	move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
	move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
	move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
	move.w (a4),d0			;movzx eax,word ptr [edi]
	subq.w #1,d0			;dec eax
	move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
	addq.l #6,a4			;add edi,6
	move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
	move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;add edi,6
	move.l newpoi0,a3		;mov esi,newpoi
	move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
	move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
	move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
.pedraw
        bsr .moddraw			;call @@moddraw
        subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
	bne.b .pedraw			;jnz @@pedraw
        move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
        bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi

.kondraw
	move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
	sub.w miny(a6),d7		;sub ecx,[ebp+miny]
	ble.w .nodraw			;jle @@nodraw
	push a4				;push edi
	move.l zbuffer0,a0		;mov esi,zbuffer
	move.l screen0,a1		;mov edi,screen
	lea mirscr,a2
	move.w miny(a6),d0		;mov eax,[ebp+miny]
	move.w d0,d1			;mov ebx,eax
	lsl.l #5,d0			;shl eax,5
	mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
	lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	add.l d1,a2
        lea (a6,d0.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
.perys
	mpush d7-a2			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
	bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
	lea 0(a2,d3.w*2),a2
	sub.w d3,d4			;sub ecx,ebx
	ble.w .strange			;jl @@strange
	move.w d4,d7			;inc ecx
	addq.w #1,d4			;mov ebx,ecx
	move.l 12(a6),d5		;mov eax,[ebp+12]
	sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
	divs.w d4,d5			;idiv ebx
	ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
	lea 0(a2,d4.w*2),a2
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
        				;jmp short @@pepun
.pepun
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .dalej			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
	move.w (a2)+,(a1)+		;mov [edi],eax
	add.l d5,a3
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
	addq.l #2,a2
	dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a2			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
	lea (xclip+1)*2(a2),a2
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
	lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;push ebp
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
	clipif .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
	clipif .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.w .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.w .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.w .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.w .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a1,a0
.nqrig1

        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xfe(a6),a1			;lea edi,[ebp+xfe]
        tst.l (a0)			;cmp dword ptr [esi],0
        bmi.b .isfir			;jl @@isfir
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .musdra			;jnz @@musdra
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .docopy			;jz @@docopy
.musdra
        bsr .drawit			;call @@drawit
        bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 4				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .peput
	push d0
	move.l d3,d0
	subq.w #1,d0
.pecli
        add.l d5,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
        dbf d0,.pecli			;loop @@peput
	pop d0
.peput
	move.l a3,(a2)			;mov [edi],eax
	move.l d4,8(a2)			;mov [edi+8],ebx
	add.l d5,a3			;add eax,[ebp+drx]
	add.l d6,d4			;add ebx,[ebp+drz]
	add.l d1,a2			;add edi,1
				;@@modme2:
	dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

drtext:
	moveq #0,d0
	move.w 4(a4),d0
	lsl.l #8,d0
	add.l #textures,d0
	move.l d0,cbase(a6)

	move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
	moveq #0,d0
	move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
	move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
	move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
	move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
	move.w (a4),d0			;movzx eax,word ptr [edi]
	subq.w #1,d0			;dec eax
	move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
	addq.l #6,a4			;add edi,6
	move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
	move.w (a4)+,d0			;movzx ebx,word ptr [edi]
	move.l (a4)+,txf(a6)		;mov eax,[edi+2]
        				;mov [ebp+txf],eax
        				;add edi,6
	move.l newpoi0,a3		;mov esi,newpoi
	move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
	move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
	move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
	move.l colpoi0,a2		;mov esi,colpoi
	move.l 0(a2,d0.l*2),cf(a6)	;mov eax,[esi+ebx*2]
					;mov [ebp+cf],eax
.pedraw
        bsr .moddraw			;call @@moddraw
        subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
	bne.b .pedraw			;jnz @@pedraw
        move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
        bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi

        ;get two points
        ;clipline
        ;if line in
        ;  if first point!=prev last drawed point draw that line
        ;  last drawed point=last point
        ;  draw line

.kondraw
        move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
        sub.w miny(a6),d7		;sub ecx,[ebp+miny]
	ble.w .nodraw			;jle @@nodraw
        push a4				;push edi
	move.l zbuffer0,a0		;mov esi,zbuffer
	move.l screen0,a1		;mov edi,screen
        move.w miny(a6),d0		;mov eax,[ebp+miny]
        move.w d0,d1			;mov ebx,eax
        lsl.l #5,d0			;shl eax,5
        mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
        lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	move.l cbase(a6),a2
        lea (a6,d0.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
	move.b reserved0+2,d0
	bne.w .perytr
.perys
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strange			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 28(a6),d3		;movzx eax,word ptr [ebp+28]
        sub.w 24(a6),d3			;movzx edx,word ptr [ebp+24]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 30(a6),d2		;movzx eax,word ptr [ebp+30]
        sub.w 26(a6),d2			;movzx edx,word ptr [ebp+26]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 20(a6),d6		;mov eax,[ebp+20]
        sub.l 16(a6),d6			;sub eax,[ebp+16]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 16(a6),a4		;mov ebx,[ebp+16]
        move.l 24(a6),d2		;mov ebp,[ebp+24]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 24(a6),d3		;movzx eax,word ptr [ebp+24]
        sub.w 28(a6),d3			;movzx edx,word ptr [ebp+28]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 26(a6),d2		;movzx eax,word ptr [ebp+26]
        sub.w 30(a6),d2			;movzx edx,word ptr [ebp+30]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 16(a6),d6		;mov eax,[ebp+16]
        sub.l 20(a6),d6			;sub eax,[ebp+20]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 20(a6),a4		;mov ebx,[ebp+20]
        move.l 28(a6),d2		;mov ebp,[ebp+28]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        				;jmp short @@pepun
.pepun
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .dalej			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
	move.l d2,d1			;mov eax,ebp
	lsr.w #8,d1			;shr eax,8
	rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
        swap d0
        add.w 0(a2,d1.w*2),d0		;add eax,ebx
        move.w d0,(a1)+			;mov [edi],eax
	add.l d5,a3
	add.l d6,a4
	add.l d3,d2
	and.l d4,d2
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        add.l d6,a4		;add ebx,11111111H
				;@@modme5:
        add.l d3,d2		;add ebp,11111111H
        and.l d4,d2		;and ebp,7fff7fffH
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
        dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.perytr
	ext.w d0
	lea transarr0,a4
	move.w -2(a4,d0.w*2),d0
	move.w d0,.modsu1
	move.w d0,.modsu2
.perygl
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrog			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strangg			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 28(a6),d3		;movzx eax,word ptr [ebp+28]
        sub.w 24(a6),d3			;movzx edx,word ptr [ebp+24]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 30(a6),d2		;movzx eax,word ptr [ebp+30]
        sub.w 26(a6),d2			;movzx edx,word ptr [ebp+26]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 20(a6),d6		;mov eax,[ebp+20]
        sub.l 16(a6),d6			;sub eax,[ebp+16]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 16(a6),a4		;mov ebx,[ebp+16]
        move.l 24(a6),d2		;mov ebp,[ebp+24]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        bra.b .pepug			;jmp short @@pepun
.odwrog
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strangg			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 24(a6),d3		;movzx eax,word ptr [ebp+24]
        sub.w 28(a6),d3			;movzx edx,word ptr [ebp+28]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 26(a6),d2		;movzx eax,word ptr [ebp+26]
        sub.w 30(a6),d2			;movzx edx,word ptr [ebp+30]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 16(a6),d6		;mov eax,[ebp+16]
        sub.l 20(a6),d6			;sub eax,[ebp+20]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 20(a6),a4		;mov ebx,[ebp+20]
        move.l 28(a6),d2		;mov ebp,[ebp+28]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        				;jmp short @@pepun
.pepug
	move.l d5,.modme1+2
	move.l d5,.modme5+2
	move.l d6,.modme2+2
	move.l d6,.modme6+2
	move.l d3,.modme3+2
	move.l d3,.modme7+2
	move.l d4,.modme4+2
	move.l d4,.modme8+2
	push a5
	lea colbyts,a5
	move.w #$e0,d6
	clearc
.pewlas
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .daleg			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
	move.l d2,d1			;mov eax,ebp
	lsr.w #8,d1			;shr eax,8
	rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
        swap d0
	add.w 0(a2,d1.w*2),d0		;add eax,ebx
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsl.l #1,d0
.modsu1	lsr.b #1,d0
	lsr.l #4,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
.modme1	add.l #0,a3
.modme2	add.l #0,a4
.modme3	add.l #0,d2
.modme4	and.l #0,d2
	dbf d7,.pewlas
	bra.b .straneg
.daleg
	move.l d2,d1			;mov eax,ebp
	lsr.w #8,d1			;shr eax,8
	rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
	swap d0
.modsu2	lsr.b #1,d0
	add.w 0(a2,d1.w*2),d0		;add eax,ebx
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsr.w #3,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
				;@@modme3:
.modme5	add.l #0,a3		;add edx,11111111H
				;@@modme4:
.modme6	add.l #0,a4		;add ebx,11111111H
				;@@modme5:
.modme7	add.l #0,d2		;add ebp,11111111H
.modme8	and.l #0,d2		;and ebp,7fff7fffH
        addq.l #4,a0		;add esi,4
        dbf d7,.pewlas			;loop @@pepun
.straneg
	pop a5
.strangg
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perygl			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4)+,d0			;movzx ebx,word ptr [edi]
        move.l (a4)+,txn(a6)		;mov eax,[edi+2]
        				;mov [ebp+txn],eax
        				;add edi,6
        				;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zn],eax
        				;mov esi,colpoi
        move.l 0(a2,d0.l*2),cn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+cn],eax

        				;push edi
        				;push ebp
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
        clipit .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
        clipit .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.w .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxt .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.w .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxt .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.w .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxt .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.w .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxt .skipit,a1,a0
.nqrig1

	lea xle(a6),a0			;lea esi,[ebp+xle]
	lea xfe(a6),a1			;lea edi,[ebp+xfe]
	tst.l (a0)			;cmp dword ptr [esi],0
	bmi.b .isfir			;jl @@isfir
	move.l (a0),d0			;mov eax,[esi]
	cmp.l (a1),d0			;cmp eax,[edi]
	bne.b .musdra			;jnz @@musdra
	move.l 4(a0),d0			;mov eax,[esi+4]
	cmp.l 4(a1),d0			;cmp eax,[edi+4]
	beq.b .docopy			;jz @@docopy
.musdra
	bsr .drawit			;call @@drawit
	bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 7				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 7				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 5				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.w 8(a1),d2			;movzx eax,word ptr [edi+8]
        sub.w 8(a0),d2			;movzx edx,word ptr [esi+8]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d0,d2			;idiv ebx
        				;mov word ptr @@modme2+2,ax
        move.w 10(a1),d3		;movzx eax,word ptr [edi+10]
        sub.w 10(a0),d3			;movzx edx,word ptr [esi+10]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d0,d3			;idiv ebx
        swap d2				;mov word ptr @@modme2+4,ax
	move.w d3,d2
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -4(a1),d7		;mov eax,[edi-4]
        sub.l -4(a0),d7			;sub eax,[esi-4]
        asr.l #7,d7			;cdq
        divs.w d0,d7			;idiv ebx
        ext.l d7			;mov [ebp+drc],eax
	lsl.l #7,d7
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        move.l -4(a0),a4		;mov edx,[esi-4]
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .noscli
	push d0
	move.l d3,d0
	subq.w #1,d0
	move.l 8(a0),d3
	move.l d5,a0
	move.l #$7fff7fff,d5
.pecli
        add.l a0,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
        add.l d7,a4			;add edx,[ebp+drc]
				;@@modme1:
        add.l d2,d3			;add esi,11111111H
        and.l d5,d3			;and esi,7fff7fffH
        dbf d0,.pecli			;loop @@peput
	pop d0
	bra.b .peput
.noscli
        move.l 8(a0),d3			;mov esi,[esi+8]
	move.l d5,a0
	move.l #$7fff7fff,d5
.peput
	move.l a3,(a2)			;mov [edi],eax
	move.l d4,8(a2)			;mov [edi+8],ebx
	move.l a4,16(a2)		;mov [edi+16],edx
	move.l d3,24(a2)		;mov [edi+24],esi
	add.l a0,a3			;add eax,[ebp+drx]
	add.l d6,d4			;add ebx,[ebp+drz]
	add.l d7,a4			;add edx,[ebp+drc]
				;@@modme1:
	add.l d1,a2			;add edi,1
				;@@modme2:
	add.l d2,d3			;add esi,11111111H
	and.l d5,d3			;and esi,7fff7fffH
	dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
        move.l -4(a1),16(a2)		;mov eax,[esi-4]
        				;mov [edi+16],eax
        move.l d3,24(a2)		;mov eax,[esi+8]
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

drtexf:
	moveq #0,d0
	move.w 4(a4),d0
	lsl.l #8,d0
	add.l #textures,d0
	move.l d0,cbase(a6)
	move.w (a4),d1
	lsr.w #1,d1
	move.w d1,d2
	add.w d2,d2
	add.w d2,d1
	move.w 6(a4,d1.w*2),d1
	move.w 6(a4),d0
	move.l colpoi0,a3
	move.l 0(a3,d0.w*2),d0
	add.l 0(a3,d1.w*2),d0
	lsr.l #1,d0
	swap d0
	move.w d0,maxy+2(a6)

        move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
        moveq #0,d0
        move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
        move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
        move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
        move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
        move.w (a4),d0			;movzx eax,word ptr [edi]
        subq.w #1,d0			;dec eax
        move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
        addq.l #6,a4			;add edi,6
        move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
        move.w (a4)+,d0			;movzx ebx,word ptr [edi]
        move.l (a4)+,txf(a6)		;mov eax,[edi+2]
        				;mov [ebp+txf],eax
        				;add edi,6
	move.l newpoi0,a3		;mov esi,newpoi
        move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
        move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
        move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
.pedraw
        bsr .moddraw			;call @@moddraw
        subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
        bne.b .pedraw			;jnz @@pedraw
        move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
        bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi

.kondraw
        move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
        sub.w miny(a6),d7		;sub ecx,[ebp+miny]
        ble.w .nodraw			;jle @@nodraw
        push a4				;push edi
        move.l zbuffer0,a0			;mov esi,zbuffer
        move.l screen0,a1			;mov edi,screen
        move.w miny(a6),d0		;mov eax,[ebp+miny]
        move.w d0,d1			;mov ebx,eax
        lsl.l #5,d0			;shl eax,5
        mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
        lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	move.l cbase(a6),a2
	move.w maxy+2(a6),a4
        lea (a6,d0.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
	move.b reserved0+2,d0
	bne.w .perytr
.perys
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strange			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 28(a6),d3		;movzx eax,word ptr [ebp+28]
        sub.w 24(a6),d3			;movzx edx,word ptr [ebp+24]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 30(a6),d2		;movzx eax,word ptr [ebp+30]
        sub.w 26(a6),d2			;movzx edx,word ptr [ebp+26]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 24(a6),d2		;mov ebp,[ebp+24]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 24(a6),d3		;movzx eax,word ptr [ebp+24]
        sub.w 28(a6),d3			;movzx edx,word ptr [ebp+28]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 26(a6),d2		;movzx eax,word ptr [ebp+26]
        sub.w 30(a6),d2			;movzx edx,word ptr [ebp+30]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 28(a6),d2		;mov ebp,[ebp+28]
					;shl ebx,16
	move.l #$7fff7fff,d4
        				;jmp short @@pepun
.pepun
        cmp.l (a0),a3			;cmp edx,[esi]
        bge.b .dalej			;jg @@dalej
        move.l a3,(a0)+			;mov [esi],edx
        move.l d2,d1			;mov eax,ebp
        lsr.w #8,d1			;shr eax,8
        rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
        add.w 0(a2,d1.w*2),d0		;add eax,ebx
        move.w d0,(a1)+			;mov [edi],eax
	add.l d5,a3
	add.l d3,d2
	and.l d4,d2
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        add.l d3,d2		;add ebp,11111111H
        and.l d4,d2		;and ebp,7fff7fffH
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
        dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.perytr
	ext.w d0
	lea transarr0,a3
	move.w -2(a3,d0.w*2),d0
	move.w d0,.modsu1
	move.w d0,.modsu2
.perygl
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrog			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strangg			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 28(a6),d3		;movzx eax,word ptr [ebp+28]
        sub.w 24(a6),d3			;movzx edx,word ptr [ebp+24]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 30(a6),d2		;movzx eax,word ptr [ebp+30]
        sub.w 26(a6),d2			;movzx edx,word ptr [ebp+26]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 24(a6),d2		;mov ebp,[ebp+24]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        bra.b .pepug			;jmp short @@pepun
.odwrog
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strangg			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.w 24(a6),d3		;movzx eax,word ptr [ebp+24]
        sub.w 28(a6),d3			;movzx edx,word ptr [ebp+28]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d4,d3			;idiv ebx
        swap d3				;mov word ptr @@modme5+2,ax
        move.w 26(a6),d2		;movzx eax,word ptr [ebp+26]
        sub.w 30(a6),d2			;movzx edx,word ptr [ebp+30]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d4,d2			;idiv ebx
        move.w d2,d3			;mov word ptr @@modme5+4,ax
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 28(a6),d2		;mov ebp,[ebp+28]
        				;shl ebx,16
	move.l #$7fff7fff,d4
        				;jmp short @@pepun
.pepug
	move.l d5,.modme1+2
	move.l d5,.modme5+2
	move.l d3,.modme3+2
	move.l d3,.modme7+2
	move.l d4,.modme4+2
	move.l d4,.modme8+2
	push a5
	lea colbyts,a5
	move.w #$e0,d6
	clearc
.pewlas
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .daleg			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
	move.l d2,d1			;mov eax,ebp
	lsr.w #8,d1			;shr eax,8
	rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
	add.w 0(a2,d1.w*2),d0		;add eax,ebx
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsl.l #1,d0
.modsu1	lsr.b #1,d0
	lsr.l #4,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
.modme1	add.l #0,a3
.modme3	add.l #0,d2
.modme4	and.l #0,d2
	dbf d7,.pewlas
	bra.b .straneg
.daleg
	move.l d2,d1			;mov eax,ebp
	lsr.w #8,d1			;shr eax,8
	rol.l #8,d1			;shl ax,9
        				;shr eax,7
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
.modsu2	lsr.b #1,d0
	add.w 0(a2,d1.w*2),d0		;add eax,ebx
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsr.w #3,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
				;@@modme3:
.modme5	add.l #0,a3		;add edx,11111111H
				;@@modme4:
.modme7	add.l #0,d2		;add ebp,11111111H
.modme8	and.l #0,d2		;and ebp,7fff7fffH
        addq.l #4,a0		;add esi,4
        dbf d7,.pewlas			;loop @@pepun
.straneg
	pop a5
.strangg
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perygl			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4)+,d0			;movzx ebx,word ptr [edi]
        move.l (a4)+,txn(a6)		;mov eax,[edi+2]
        				;mov [ebp+txn],eax
        				;add edi,6
        				;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zn],eax
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
        clipir .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
        clipir .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.w .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxr .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.w .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxr .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.w .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxr .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.w .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxr .skipit,a1,a0
.nqrig1

        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xfe(a6),a1			;lea edi,[ebp+xfe]
        tst.l (a0)			;cmp dword ptr [esi],0
        bmi.b .isfir			;jl @@isfir
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .musdra			;jnz @@musdra
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .docopy			;jz @@docopy
.musdra
        bsr .drawit			;call @@drawit
        bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 7				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 7				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 5				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.w 8(a1),d2			;movzx eax,word ptr [edi+8]
        sub.w 8(a0),d2			;movzx edx,word ptr [esi+8]
        				;sub eax,edx
        ext.l d2			;cdq
        divs d0,d2			;idiv ebx
        				;mov word ptr @@modme2+2,ax
        move.w 10(a1),d3		;movzx eax,word ptr [edi+10]
        sub.w 10(a0),d3			;movzx edx,word ptr [esi+10]
        				;sub eax,edx
        ext.l d3			;cdq
        divs d0,d3			;idiv ebx
        swap d2				;mov word ptr @@modme2+4,ax
	move.w d3,d2
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .noscli
	push d0
	move.l d3,d0
	subq.w #1,d0
	move.l 8(a0),d3
	move.l d5,a0
	move.l #$7fff7fff,d5
.pecli
        add.l a0,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
				;@@modme1:
        add.l d2,d3			;add esi,11111111H
        and.l d5,d3			;and esi,7fff7fffH
        dbf d0,.pecli			;loop @@peput
	pop d0
	bra.b .peput
.noscli
        move.l 8(a0),d3			;mov esi,[esi+8]
	move.l d5,a0
	move.l #$7fff7fff,d5
.peput
        move.l a3,(a2)			;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],ebx
        move.l d3,24(a2)		;mov [edi+24],esi
        add.l a0,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
				;@@modme1:
        add.l d1,a2			;add edi,1
				;@@modme2:
        add.l d2,d3			;add esi,11111111H
        and.l d5,d3			;and esi,7fff7fffH
        dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
        move.l d3,24(a2)		;mov eax,[esi+8]
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

drshad:
        move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
        moveq #0,d0
        move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
        move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
        move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
        move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
        move.w (a4),d0			;movzx eax,word ptr [edi]
        subq.w #1,d0			;dec eax
        move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
        addq.l #6,a4			;add edi,6
        move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
        move.w (a4),d0			;movzx ebx,word ptr [edi]
        addq.l #6,a4			;mov [ebp+txf],eax
        				;add edi,6
        move.l newpoi0,a3		;mov esi,newpoi
        move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
        move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
        move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
        move.l colpoi0,a2		;mov esi,colpoi
        move.l 0(a2,d0.l*2),cf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+cf],eax
.pedraw
	bsr .moddraw			;call @@moddraw
        subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
        bne.b .pedraw			;jnz @@pedraw
        move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
	bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi
.kondraw
        move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
        sub.w miny(a6),d7		;sub ecx,[ebp+miny]
        ble.w .nodraw			;jle @@nodraw
        push a4				;push edi
        move.l zbuffer0,a0			;mov esi,zbuffer
        move.l screen0,a1			;mov edi,screen
        move.w miny(a6),d0		;mov eax,[ebp+miny]
        move.w d0,d1			;mov ebx,eax
        lsl.l #5,d0			;shl eax,5
        mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
        lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	moveq #0,d4
	move.w 4(a4),d4
	swap d4
	move.l d4,a2
        lea (a6,d0.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
	move.b reserved0+2,d0
	bne.w .perytr
.perys
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strange			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 20(a6),d6		;mov eax,[ebp+20]
        sub.l 16(a6),d6			;sub eax,[ebp+16]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 16(a6),a4		;mov ebx,[ebp+16]
	add.l a2,a4
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 16(a6),d6		;mov eax,[ebp+16]
        sub.l 20(a6),d6			;sub eax,[ebp+20]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 20(a6),a4		;mov ebx,[ebp+20]
        add.l a2,a4			;jmp short @@pepun
.pepun
        cmp.l (a0),a3			;cmp edx,[esi]
        bge.b .dalej			;jg @@dalej
        move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
        move.l a4,d0			;mov eax,[eax+11111111H]
        swap d0
        move.w d0,(a1)+			;mov [edi],eax
	add.l d5,a3
	add.l d6,a4
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        add.l d6,a4		;add ebx,11111111H
				;@@modme5:
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
        dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.perytr
	ext.w d0
	lea transarr0,a4
	move.w -2(a4,d0.w*2),d0
	move.w d0,.modsu1
	move.w d0,.modsu2
.perygl
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrog			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strangg			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 20(a6),d6		;mov eax,[ebp+20]
        sub.l 16(a6),d6			;sub eax,[ebp+16]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 8(a6),a3			;mov edx,[ebp+8]
        move.l 16(a6),a4		;mov ebx,[ebp+16]
	add.l a2,a4
        bra.b .pepug			;jmp short @@pepun
.odwrog
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strangg			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 16(a6),d6		;mov eax,[ebp+16]
        sub.l 20(a6),d6			;sub eax,[ebp+20]
        asr.l #7,d6			;cdq
        divs.w d4,d6			;idiv ebx
        ext.l d6			;mov dword ptr @@modme4+2,eax
        lsl.l #7,d6			;push ebp
        move.l 12(a6),a3		;mov edx,[ebp+12]
        move.l 20(a6),a4		;mov ebx,[ebp+20]
	add.l a2,a4			;jmp short @@pepun
.pepug
	move.l d5,.modme1+2
	move.l d5,.modme5+2
	move.l d6,.modme2+2
	move.l d6,.modme6+2
	push a5
	lea colbyts,a5
	move.w #$e0,d6
	clearc
.pewlas
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .daleg			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
	move.l a4,d0			;mov eax,[eax+11111111H]
	swap d0
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsl.l #1,d0
.modsu1	lsr.b #1,d0
	lsr.l #4,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
.modme1	add.l #0,a3
.modme2	add.l #0,a4
	dbf d7,.pewlas
	bra.b .straneg
.daleg
	move.l a4,d0			;mov eax,[eax+11111111H]
	swap d0
.modsu2	lsr.b #1,d0
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsr.w #3,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
				;@@modme3:
.modme5	add.l #0,a3		;add edx,11111111H
				;@@modme4:
.modme6	add.l #0,a4		;add ebx,11111111H
        addq.l #4,a0		;add esi,4
        dbf d7,.pewlas			;loop @@pepun
.straneg
	pop a5
.strangg
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perygl			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zn],eax
        				;mov esi,colpoi
        move.l 0(a2,d0.l*2),cn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+cn],eax

        				;push edi
        				;push ebp
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
        clipig .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
        clipig .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.b .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxg .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.b .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxg .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.b .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxg .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.b .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxg .skipit,a1,a0
.nqrig1

        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xfe(a6),a1			;lea edi,[ebp+xfe]
        tst.l (a0)			;cmp dword ptr [esi],0
        bmi.b .isfir			;jl @@isfir
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .musdra			;jnz @@musdra
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .docopy			;jz @@docopy
.musdra
        bsr .drawit			;call @@drawit
        bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 4				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -4(a1),d7		;mov eax,[edi-4]
        sub.l -4(a0),d7			;sub eax,[esi-4]
        asr.l #7,d7			;cdq
        divs.w d0,d7			;idiv ebx
        ext.l d7			;mov [ebp+drc],eax
	lsl.l #7,d7
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        move.l -4(a0),a4		;mov edx,[esi-4]
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .peput
	push d0
	move.l d3,d0
	subq.w #1,d0
.pecli
        add.l d5,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
        add.l d7,a4			;add edx,[ebp+drc]
				;@@modme1:
        dbf d0,.pecli			;loop @@peput
	pop d0
.peput
        move.l a3,(a2)			;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],ebx
        move.l a4,16(a2)		;mov [edi+16],edx
        add.l d5,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
        add.l d7,a4			;add edx,[ebp+drc]
				;@@modme1:
        add.l d1,a2			;add edi,1
				;@@modme2:
        dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
        move.l -4(a1),16(a2)		;mov eax,[esi-4]
        				;mov [edi+16],eax
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

drflat:
	move.w (a4),d1
	lsr.w #1,d1
	move.w d1,d2
	add.w d2,d2
	add.w d2,d1
	move.w 6(a4,d1.w*2),d1
	move.w 6(a4),d0
	move.l colpoi0,a3
	move.l 0(a3,d0.w*2),d0
	add.l 0(a3,d1.w*2),d0
	lsr.l #1,d0
	swap d0
	add.w 4(a4),d0
	move.l d0,cbase(a6)
drblack
	move.w #yclip,miny(a6)		;mov dword ptr [ebp+miny],199
        moveq #0,d0
        move.w d0,maxy(a6)		;mov dword ptr [ebp+maxy],0
        move.w #4,ofs(a6)		;mov dword ptr [ebp+ofs],4
        move.w d0,ldir(a6)		;mov dword ptr [ebp+ldir],0
        move.l #-1,xle(a6)		;mov dword ptr [ebp+xle],-1
        move.w (a4),d0			;movzx eax,word ptr [edi]
        subq.w #1,d0			;dec eax
        move.l d0,ilrys(a6)		;mov [ebp+ilrys],eax
        addq.l #6,a4			;add edi,6
        move.l a4,ilpun(a6)		;mov [ebp+ilpun],edi
        move.w (a4),d0			;movzx ebx,word ptr [edi]
        addq.l #6,a4			;mov [ebp+txf],eax
        				;add edi,6
        move.l newpoi0,a3		;mov esi,newpoi
        move.l 0(a3,d0.l*2),xf(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xf],eax
        move.l 4(a3,d0.l*2),yf(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yf],eax
        move.l 8(a3,d0.l*2),zf(a6)	;mov eax,[esi+ebx*2+8]
        				;mov [ebp+zf],eax
.pedraw
        bsr .moddraw			;call @@moddraw
        subq.l #1,ilrys(a6)		;dec dword ptr [ebp+ilrys]
        bne.b .pedraw			;jnz @@pedraw
        move.l ilpun(a6),a4		;mov edi,[ebp+ilpun]
        bsr .moddraw			;call @@moddraw
        lea -12(a4),a4			;sub edi,12
        				;push edi
        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xde(a6),a1			;lea edi,[ebp+xde]
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .muskon			;jnz @@muskon
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .noconc			;jz @@noconc
.muskon
        bsr .drawit			;call @@drawit
.noconc
        				;pop edi
.kondraw
        move.w maxy(a6),d7		;mov ecx,[ebp+maxy]
        sub.w miny(a6),d7		;sub ecx,[ebp+miny]
        ble.w .nodraw			;jle @@nodraw
        push a4				;push edi
        move.l zbuffer0,a0			;mov esi,zbuffer
        move.l screen0,a1			;mov edi,screen
        move.w miny(a6),d2		;mov eax,[ebp+miny]
        move.w d2,d1			;mov ebx,eax
        lsl.l #5,d2			;shl eax,5
        mulu #(xclip+1)*2,d1		;lea eax,[eax*4+eax]
        				;add eax,eax
        lea 0(a0,d1.l*2),a0		;lea esi,[esi+eax*4]
	add.l d1,a1			;lea edi,[edi+eax*4]
	move.l cbase(a6),d0
        lea (a6,d2.w,bufrys.w),a6	;lea ebp,[ebp+ebx+bufrys]
	subq.l #1,d7
	move.b reserved0+2,d1
	bne.w .perytr
.perys
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrot			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strange			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        bra.b .pepun			;jmp short @@pepun
.odwrot
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strange			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
.pepun
        cmp.l (a0),a3			;cmp edx,[esi]
        bge.b .dalej			;jg @@dalej
        move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
        move.w d0,(a1)+			;mov [edi],eax
	add.l d5,a3
	dbf d7,.pepun
	bra.b .strange
.dalej
				;@@modme3:
        add.l d5,a3		;add edx,11111111H
				;@@modme4:
        addq.l #4,a0		;add esi,4
        addq.l #2,a1		;add edi,4
        dbf d7,.pepun			;loop @@pepun
        				;pop ebp
.strange
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perys			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
.nodraw
        rts				;ret

.perytr
	ext.w d1
	lea transarr0,a4
	move.w -2(a4,d1.w*2),d1
	move.w d1,.modsu1
	move.w d1,.modsu2
	move.w d0,a4
.perygl
        mpush d7-a1			;push ecx
        				;push esi
        				;push edi
        move.w 5(a6),d4			;mov ecx,[ebp+4]
        move.w 1(a6),d3			;mov ebx,[ebp]
        cmp.w d4,d3			;cmp ebx,ecx
        bge.b .odwrog			;jg @@odwrot
        lea 0(a0,d3.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d3.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        ble.w .strangg			;jl @@strange
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 12(a6),d5		;mov eax,[ebp+12]
        sub.l 8(a6),d5			;sub eax,[ebp+8]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 8(a6),a3			;mov edx,[ebp+8]
        bra.b .pepug			;jmp short @@pepun
.odwrog
        lea 0(a0,d4.w*4),a0		;lea esi,[esi+ebx*4]
        lea 0(a1,d4.w*2),a1		;lea edi,[edi+ebx*4]
        sub.w d3,d4			;sub ecx,ebx
        bge.w .strangg			;jl @@strange
	neg.w d4
        move.w d4,d7			;inc ecx
        addq.w #1,d4			;mov ebx,ecx
        move.l 8(a6),d5			;mov eax,[ebp+8]
        sub.l 12(a6),d5			;sub eax,[ebp+12]
        				;cdq
        divs.w d4,d5			;idiv ebx
        ext.l d5			;mov dword ptr @@modme3+2,eax
        move.l 12(a6),a3		;mov edx,[ebp+12]
.pepug
	move.l d5,.modme1+2
	move.l d5,.modme5+2
	push a5
	lea colbyts,a5
	move.w #$e0,d6
	clearc
.pewlas
	cmp.l (a0),a3			;cmp edx,[esi]
	bge.b .daleg			;jg @@dalej
	move.l a3,(a0)+			;mov [esi],edx
				;@@modme6:
	move.l a4,d0			;mov eax,[eax+11111111H]
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsl.l #1,d0
.modsu1	lsr.b #1,d0
	lsr.l #4,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
.modme1	add.l #0,a3
	dbf d7,.pewlas
	bra.b .straneg
.daleg
	move.l a4,d0			;mov eax,[eax+11111111H]
.modsu2	lsr.b #1,d0
	lsr.w #3,d0
	move.b 0(a5,d0.w*4),d3
	move.b 1(a5,d0.w*4),d4
	move.b 2(a5,d0.w*4),d5
	move.w (a1),d0
	lsr.w #3,d0
	add.b 0(a5,d0.w*4),d3
	scs d1
	or.b d1,d3
	add.b 1(a5,d0.w*4),d4
	scs d1
	or.b d1,d4
	add.b 2(a5,d0.w*4),d5
	scs d1
	or.b d1,d5
	and.w d6,d3
	and.w d6,d4
	and.w d6,d5
	lsl.w #8,d3
	lsl.w #5,d4
	lsl.w #2,d5
	add.w d5,d4
	add.w d4,d3
	or.w #$7f,d3
	move.w d3,(a1)+			;mov [edi],eax
				;@@modme3:
.modme5	add.l #0,a3		;add edx,11111111H
        addq.l #4,a0		;add esi,4
        dbf d7,.pewlas			;loop @@pepun
.straneg
	pop a5
.strangg
        lea 32(a6),a6			;add ebp,32
        				;pop edi
        				;pop esi
        mpop d7-a1			;pop ecx
        lea (xclip+1)*4(a0),a0		;add edi,320*4
        lea (xclip+1)*2(a1),a1		;add esi,320*4
        				;dec ecx
        dbf d7,.perygl			;jz @@konrys
        				;jmp @@perys
        pop a4				;pop edi
        lea dvars(pc),a6		;mov ebp,offset dvars
        rts				;ret

.moddraw
	moveq #0,d0
        move.w (a4),d0			;movzx ebx,word ptr [edi]
	addq.l #6,a4			;mov esi,newpoi
        move.l 0(a3,d0.l*2),xn(a6)	;mov eax,[esi+ebx*2]
        				;mov [ebp+xn],eax
        move.l 4(a3,d0.l*2),yn(a6)	;mov eax,[esi+ebx*2+4]
        				;mov [ebp+yn],eax
        move.l 8(a3,d0.l*2),zn(a6)	;mov eax,[esi+ebx*2+8]
        				;push ebp
        lea xf(a6),a0			;lea esi,[ebp+xf]
        lea xn(a6),a1			;lea edi,[ebp+xn]
        lea xfc(a6),a5			;lea ebp,[ebp+xfc]
        clipif .skipit			;jc @@skipit
        				;pop ebp
        				;push ebp
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xfc(a6),a1			;lea edi,[ebp+xfc]
        lea xnc(a6),a5			;lea ebp,[ebp+xnc]
        clipif .skipit			;jc @@skipit
        				;pop ebp
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        tst.l (a0)			;cmp dword ptr [esi],0
        bge.b .nolef1			;jge @@nolef1
        tst.l (a1)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a0,a1
.nolef1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [esi],xclip*256
        ble.b .norig1			;jle @@norig1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a0,a1
.norig1
        tst.l (a1)			;cmp dword ptr [esi],0
        bge.b .nqlef1			;jge @@nolef1
        tst.l (a0)			;cmp dword ptr [edi],0
        blt.w .skipit			;jge @@cllef1
        moveq #0,d3			;xor ecx,ecx
        clipxf .skipit,a1,a0
.nqlef1
        cmp.l #xclip*256,(a1)		;cmp dword ptr [esi],xclip*256
        ble.b .nqrig1			;jle @@norig1
        cmp.l #xclip*256,(a0)		;cmp dword ptr [edi],xclip*256
        bgt.w .skipit			;jg @@outher
        move.l #xclip*256,d3		;mov ecx,xclip*256
        clipxf .skipit,a1,a0
.nqrig1

        lea xle(a6),a0			;lea esi,[ebp+xle]
        lea xfe(a6),a1			;lea edi,[ebp+xfe]
        tst.l (a0)			;cmp dword ptr [esi],0
        bmi.b .isfir			;jl @@isfir
        move.l (a0),d0			;mov eax,[esi]
        cmp.l (a1),d0			;cmp eax,[edi]
        bne.b .musdra			;jnz @@musdra
        move.l 4(a0),d0			;mov eax,[esi+4]
        cmp.l 4(a1),d0			;cmp eax,[edi+4]
        beq.b .docopy			;jz @@docopy
.musdra
        bsr .drawit			;call @@drawit
        bra.b .docopy			;jmp short @@docopy
.isfir
        lea xfc(a6),a0			;lea esi,[ebp+xfc]
        lea xd(a6),a1			;lea edi,[ebp+xd]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
.docopy
        lea xnc(a6),a0			;lea esi,[ebp+xnc]
        lea xlc(a6),a1			;lea edi,[ebp+xlc]
        				;cld
        rept 6				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;movsd
        				;movsd
        lea xfe(a6),a0			;lea esi,[ebp+xfe]
        lea xne(a6),a1			;lea edi,[ebp+xne]
        bsr .drawit			;call @@drawit
        				;jmp short @@daleq
.skipit
        				;pop ebp
				;.daleq
        lea xn(a6),a0			;lea esi,[ebp+xn]
        lea xf(a6),a1			;lea edi,[ebp+xf]
        				;cld
        rept 3				;movsd
        move.l (a0)+,(a1)+		;movsd
        endr				;movsd
        				;movsd
        				;movsd
        				;pop edi
        rts				;ret

.drawit
        moveq #32,d1			;mov ebx,32
        move.l 4(a1),d0			;mov eax,[edi+4]
        sub.l 4(a0),d0			;sub eax,[esi+4]
        bne.s .modraw			;jnz @@modraw
        rts				;ret
.modraw
        bpl.b .wlakie			;jg @@wlakie
        neg.l d0			;neg ebx
        neg.l d1			;neg eax
.wlakie
        cmp.w ldir(a6),d1		;cmp ebx,[ebp+ldir]
        beq.b .nochan			;jz @@nochan
        move.w d1,ldir(a6)		;mov [ebp+ldir],ebx
        eor.w #4,ofs(a6)		;xor dword ptr [ebp+ofs],4
.nochan
        mpush a2-a4			;mov ecx,eax
        				;mov ebx,eax
        move.l (a1),d5			;mov eax,[edi]
        sub.l (a0),d5			;sub eax,[esi]
        				;cdq
        divs d0,d5			;idiv ebx
        ext.l d5			;mov [ebp+drx],eax
        move.l -8(a1),d6		;mov eax,[edi-8]
        move.l -8(a0),d4		;mov edx,[esi-8]
        sub.l d4,d6			;sub eax,edx
        lsl.l #8,d6			;shl eax,8
        				;cdq
        divs.w d0,d6			;idiv ebx
        ext.l d6			;mov [ebp+drz],eax
	moveq #yclip,d3
	move.l 4(a1),d4
	bpl.b .nocydd
	add.l d4,d0
	ble.w .dummy
	bra.b .nocydg
.nocydd
	cmp.l d3,d4
	ble.b .nocydg
	sub.l d3,d4
	sub.l d4,d0
	ble.w .dummy
.nocydg
        move.l 4(a0),d4			;mov eax,[esi+4]
	bpl.b .noclyg
	neg.l d4
	sub.l d4,d0
	move.l d4,d3
	moveq #0,d4
	bra.b .noclyd
.noclyg
	cmp.l d3,d4
	ble.b .noclyq
	sub.l d3,d4
	sub.l d4,d0
	move.l d4,d3
	moveq #yclip,d4
	bra.b .noclyd
.noclyq
	moveq #0,d3
.noclyd
        cmp.w miny(a6),d4		;cmp eax,[ebp+miny]
        bge.b .nomin			;jge @@nomin
        move.w d4,miny(a6)		;mov [ebp+miny],eax
.nomin
        cmp.w maxy(a6),d4		;cmp eax,[ebp+maxy]
        ble.b .nomax			;jle @@nomax
        move.w d4,maxy(a6)		;mov [ebp+maxy],eax
.nomax
        lsl.l #5,d4			;shl eax,5
        				;push edi
        lea (a6,d4.l,bufrys.w),a2	;lea edi,[ebp+eax+bufrys]
        add.w ofs(a6),a2		;add edi,[ebp+ofs]
        move.l (a0),a3			;mov eax,[esi]
        move.l -8(a0),d4		;mov ebx,[esi-8]
        lsl.l #8,d4			;shl ebx,8
        				;mov edx,[ebp+ldir]
        				;mov byte ptr @@modme1+2,dl
        subq.w #1,d0			;jmp short @@peput
	bmi.b .dummy
	tst.l d3
	beq.b .peput
	push d0
	move.l d3,d0
	subq.w #1,d0
.pecli
        add.l d5,a3			;add eax,[ebp+drx]
	add.l d6,d4
				;@@modme1:
        dbf d0,.pecli			;loop @@peput
	pop d0
.peput
        move.l a3,(a2)			;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],ebx
        add.l d5,a3			;add eax,[ebp+drx]
        add.l d6,d4			;add ebx,[ebp+drz]
				;@@modme1:
        add.l d1,a2			;add edi,1
				;@@modme2:
        dbf d0,.peput			;loop @@peput
        				;pop esi
        move.l a3,(a2)			;mov eax,[esi]
        				;mov [edi],eax
        move.l d4,8(a2)			;mov [edi+8],eax
.dummy
        mpop a2-a4			;mov [edi+24],eax
.skipyt
        rts				;ret

	align 4,4			;Align 4
dvars  blk.l 1500,0

obrkat:
	move.w #360,d0
	add.w d1,d4
	bpl.b .wlado1
.again1
	add.w d0,d4
	bmi.b .again1
.wlado1
	add.w d2,d5
	bpl.b .wlado2
.again2
	add.w d0,d5
	bmi.b .again2
.wlado2
	add.w d3,d6
	bpl.b .wlado3
.again3
	add.w d0,d6
	bmi.b .again3
.wlado3
	cmp.w d4,d0
	bhi.b .wlado4
	sub.w d0,d4
	bra.b .wlado3
.wlado4
	cmp.w d5,d0
	bhi.b .wlado5
	sub.w d0,d5
	bra.b .wlado4
.wlado5
	cmp.w d6,d0
	bhi.b .wlado6
	sub.w d0,d6
	bra.b .wlado5
.wlado6
	rts

prepobj:
	lea objects,a0		;mov esi,offset objects
	lea objtab(a5),a1	;mov edi,offset objtab
	move.w #0,numobjects(a5)
.kazobj
	move.l (a0),a0
	lea 24(a0),a2
	move.l a2,object(a5)	;mov object,esi
	push a1			;push edi
	move.w 24(a0),d0
	lea 2+24(a0,d0.w*4),a1
	move.w (a1)+,d7
	move.l a0,a2
	mpush d0-a6
	move.l a1,a0
	bsr obrobl
	mpop d0-a6
	lea 12(a0),a0
	movem.l (a0)+,d1-d3
	move.w -2(a1),d0
	subq.w #1,d0
.scalpo
	movem.l (a1),d4-d6
	muls.l d1,d4
	muls.l d2,d5
	muls.l d3,d6
	asr.l #8,d4
	asr.l #8,d5
	asr.l #8,d6
	movem.l d4-d6,(a1)
	lea 12(a1),a1
	dbf d0,.scalpo
	bsr .preppod		;call @@preppod
	tst.l d0
        bne.s .notmem		;jnc @@notmem
        pop a1			;pop edi
        			;pop esi
	rts			;ret
.notmem
	pop a1			;pop edi
	move.l nextobj(a5),a0
	lea numcovers(a5),a2	;mov esi,offset numcovers
	moveq #15,d0		;mov ecx,16
.pecopy			        ;cld
	move.l (a2)+,(a1)+	;rep movsd
	dbf d0,.pecopy
	addq.w #1,numobjects(a5)
	tst.l (a0)		;cmp byte ptr [esi],0
	bpl.s .kazobj		;jge @@kazobj
	moveq #-1,d0		;clc
	rts			;ret
.preppod
        move.l object(a5),a0		;mov edx,object
	moveq #0,d0
	move.w (a0)+,d0			;movzx eax,word ptr [edx]
;	ror.w #8,d0
	move.l d0,numcovers(a5)		;mov numcovers,eax
        				;add edx,2
        move.l a0,covers(a5)		;mov covers,edx
        subq.w #1,d0			;shl eax,2
.peswap1				;add edx,eax
	move.w 2(a0),d1
;	ror.w #8,d1
	move.w d1,d2
	move.w d2,d3
	and.w #$e00,d1
	lsl.w #1,d2
	and.w #$1c0,d2
	lsl.w #2,d3
	and.w #$038,d3
	add.w d3,d1
	add.w d2,d1
	move.w d1,2(a0)
	addq.l #4,a0
	dbf d0,.peswap1
	move.w (a0)+,d0			;movzx eax,word ptr [edx]
;	ror.w #8,d0
        move.l d0,numpoints(a5)		;mov numpoints,eax
        				;add edx,2
        move.l a0,points(a5)		;mov points,edx
        mulu #3,d0			;lea eax,[eax*2+eax]
        subq.w #1,d0			;shl eax,2
.peswap2       				;add edx,eax
	move.l (a0),d1
;	ror.w #8,d1
;	swap d1
;	ror.w #8,d1
	move.l d1,(a0)+
	dbf d0,.peswap2
	moveq #0,d7
        move.w (a0)+,d7			;move.w movzx eax,word ptr [edx]
        move.l d7,numsurfaces(a5)	;mov numsurfaces,eax
        				;add edx,2
        move.l a0,surfaces(a5)		;mov surfaces,edx
	subq.w #1,d7
.peswap3
	move.w (a0),d1
;	ror.w #8,d1
	move.w d1,(a0)+
	subq.w #1,d1
        move.w 2(a0),d0			;movzx eax,word ptr [edi+4]
        				;cmp eax,0
        beq.b .wlapro			;jz short @@wlapro
	tst.w (a0)
	bpl.b .tzshad
	move.w #1,(a0)+
	bra.b .litext
.tzshad
        move.w #0,(a0)+			;call drtext
.litext
	moveq #0,d2
	move.w (a0),d2
	subq.l #1,d2			;dec eax
	moveq #0,d3
	lsr.w #1,d2
	bcc.b .nonext
	moveq #1,d3
.nonext
        lsl.l #8,d2			;shl eax,16
	add.l d3,d2
	move.w d2,(a0)+
        bra.b .jupory			;jmp short @@jupory
.wlapro
	move.w (a0),d3
	bpl.b .norsha
	move.w #3,(a0)+
	neg.w d3
	move.l covers(a5),a2
	move.w 2(a2,d3.w*4),d3
	lsl.w #4,d3
	move.w d3,(a0)+
	bra.b .jupory
.norsha
	move.w #2,(a0)+
	move.l covers(a5),a2
	move.w 2(a2,d3.w*4),d0
	lsl.w #4,d0
	move.w d0,(a0)+
.jupory
.peswap4
	rept 3
	move.w (a0),d2
;	ror.w #8,d2
	move.w d2,(a0)+
	endr
	dbf d1,.peswap4
	dbf d7,.peswap3
	move.l a0,nextobj(a5)

        move.l numpoints(a5),d0		;mov eax,numpoints
        mulu #12,d0			;mov ebx,12
        				;mul ebx
	alloc poivec(a5),d0		;alloc poivec,eax
;	move.l numpoints(a5),d0		;mov eax,numpoints
;	mulu #12,d0			;mov ebx,12
        				;mul ebx
;	alloc phong(a5),d0		;alloc phong,eax

	lea bufobr,a0			;mov edi,survec
	move.l surfaces(a5),a1		;mov esi,surfaces
	move.l points(a5),a2		;mov ebp,points
	move.l numsurfaces(a5),d7	;mov ecx,numsurfaces
	subq.w #1,d7
.kazsur
        moveq #0,d0			;movzx eax,word ptr [esi]
        move.w (a1),d0			;xor edx,edx
        divu #3,d0			;mov ebx,3
        				;div ebx
        mulu #3,d0			;lea ebx,[eax*2+eax]
        				;push edi
        lea .bufvec(pc),a3		;mov edi,offset @@bufvec
	moveq #0,d1
        move.w 6(a1),d1			;movzx edx,word ptr [esi+6]
        move.l 0(a2,d1.l*2),(a3)	;mov eax,[ebp+edx*2]
        				;mov [edi],eax
        move.l 4(a2,d1.l*2),4(a3)	;mov eax,[ebp+edx*2+4]
        				;mov [edi+4],eax
        move.l 8(a2,d1.l*2),8(a3)	;mov eax,[ebp+edx*2+8]
        				;mov [edi+8],eax
        move.w 6(a1,d0.w*2),d1		;movzx edx,word ptr [esi+ebx*2+6]
        move.l 0(a2,d1.l*2),12(a3)	;mov eax,[ebp+edx*2]
        				;mov [edi+12],eax
        move.l 4(a2,d1.l*2),16(a3)	;mov eax,[ebp+edx*2+4]
        				;mov [edi+16],eax
        move.l 8(a2,d1.l*2),20(a3)	;mov eax,[ebp+edx*2+8]
        				;mov [edi+20],eax
        move.w 6(a1,d0.w*4),d1		;movzx edx,word ptr [esi+ebx*4+6]
        move.l 0(a2,d1.l*2),24(a3)	;mov eax,[ebp+edx*2]
        				;mov [edi+24],eax
        move.l 4(a2,d1.l*2),28(a3)	;mov eax,[ebp+edx*2+4]
        				;mov [edi+28],eax
        move.l 8(a2,d1.l*2),32(a3)	;mov eax,[ebp+edx*2+8]
        				;mov [edi+32],eax
        move.l 12(a3),d1		;mov eax,[edi+12]
        sub.l d1,24(a3)			;sub [edi+24],eax
        move.l 16(a3),d1		;mov eax,[edi+16]
        sub.l d1,28(a3)			;sub [edi+28],eax
        move.l 20(a3),d1		;mov eax,[edi+20]
        sub.l d1,32(a3)			;sub [edi+32],eax
        move.l (a3),d1			;mov eax,[edi]
        sub.l d1,12(a3)			;sub [edi+12],eax
        move.l 4(a3),d1			;mov eax,[edi+4]
        sub.l d1,16(a3)			;sub [edi+16],eax
        move.l 8(a3),d1			;mov eax,[edi+8]
        sub.l d1,20(a3)			;sub [edi+20],eax

        move.l 16(a3),d1		;mov eax,[edi+16]
        muls.l 32(a3),d1		;imul eax,dword ptr [edi+32]
        move.l d1,d2			;mov edx,eax
        move.l 20(a3),d1		;mov eax,[edi+20]
        muls.l 28(a3),d1		;imul eax,dword ptr [edi+28]
        sub.l d1,d2			;sub edx,eax
        move.l d2,(a3)			;mov [edi],edx
        move.l 24(a3),d1		;mov eax,[edi+24]
        muls.l 20(a3),d1		;imul eax,dword ptr [edi+20]
        move.l d1,d2			;mov edx,eax
        move.l 12(a3),d1		;mov eax,[edi+12]
        muls.l 32(a3),d1		;imul eax,dword ptr [edi+32]
        sub.l d1,d2			;sub edx,eax
        move.l d2,4(a3)			;mov [edi+4],edx
        move.l 12(a3),d1		;mov eax,[edi+12]
        muls.l 28(a3),d1		;imul eax,dword ptr [edi+28]
        move.l d1,d2			;mov edx,eax
        move.l 24(a3),d1		;mov eax,[edi+24]
        muls.l 16(a3),d1		;imul eax,dword ptr [edi+16]
        sub.l d1,d2			;sub edx,eax
        move.l d2,8(a3)			;mov [edi+8],edx
        				;push ecx
        move.l (a3),d2			;mov eax,[edi]
        muls.l d2,d3:d2			;imul eax
        move.l d2,d4			;mov ebx,eax
        move.l d3,d5			;mov ecx,edx
        move.l 4(a3),d2			;mov eax,[edi+4]
        muls.l d2,d3:d2			;imul eax
        add.l d2,d4			;add ebx,eax
        addx.l d3,d5			;adc ecx,edx
        move.l 8(a3),d2			;mov eax,[edi+8]
        muls.l d2,d3:d2			;imul eax
        add.l d2,d4			;add ebx,eax
        addx.l d3,d5			;adc ecx,edx
        				;push esi
        				;push edi
        				;shld ecx,ebx,2
               				;shl ebx,2
        moveq #0,d1			;mov edi,ecx
        				;mov esi,ebx
        moveq #29,d6			;mov ecx,30
        				;xor ebx,ebx
.calsqr
        bset d6,d1			;bts ebx,ecx
        move.l d1,d2			;mov eax,ebx
        muls.l d2,d3:d2			;imul eax
        cmp.l d5,d3			;cmp edx,edi
        bhi.s .kasbit			;jg @@kasbit
        cmp.l d4,d2			;cmp eax,esi
        bls.s .tooles			;jb @@tooles
.kasbit
        bclr d6,d1			;btr ebx,ecx
.tooles
        dbf d6,.calsqr			;loop @@calsqr
        tst.l d1			;shr ebx,1
        bne.b .nozedd			;pop edi
        moveq #1,d1			;pop esi
.nozedd        				;pop ecx
        				;mov eax,esi
        				;mov esi,edi
        				;pop edi
        				;push eax
        rept 3
        move.l (a3)+,d2			;lodsd
        rol.l #8,d2			;cdq
	move.b d2,d3		      	;shld edx,eax,8
        extb.l d3			;shl eax,8
        divs.l d1,d3:d2			;idiv ebx
        move.l d2,(a0)+			;stosd
        endr
        				;pop esi
        move.w (a1),d0			;movzx eax,word ptr [esi]
        mulu #3,d0			;lea eax,[eax*2+eax]
        lea 6(a1,d0.l*2),a1		;lea esi,[esi+eax*2+6]
        dbf d7,.kazsur			;dec ecx
        				;jz @@jukon
	moveq #0,d7			;xor ecx,ecx
	move.l poivec(a5),a0		;mov edi,poivec
;	move.l phong(a5),a1		;mov ebp,phong
	move.l numpoints(a5),d6		;mov edx,numpoints
	subq.l #1,d6
.kazpoi
        				;push edx
        				;push edi
        				;push ebp
        lea .bufvec(pc),a3		;mov edi,offset @@bufvec
        moveq #0,d0			;xor eax,eax
        rept 5				;mov [edi],eax
        move.l d0,(a3)+			;mov [edi+4],eax
        endr				;mov [edi+8],eax
        lea -20(a3),a3			;mov [edi+12],eax
        				;mov [edi+16],eax
	push a0
        move.l numsurfaces(a5),d5	;mov edx,numsurfaces
	subq.w #1,d5
	move.l surfaces(a5),a4		;mov ebp,surfaces
	lea bufobr,a6			;mov esi,survec
	move.l covers(a5),a0
.eachs
        				;push edx
        move.w (a4)+,d4			;movzx ebx,word ptr [ebp]
	subq.w #1,d4
        move.w (a4),d3			;movzx edx,word ptr [ebp+2]
        addq.l #4,a4			;add ebp,6
.eachp
        cmp.w (a4),d7			;cmp cx,[ebp]
        bne.s .norow			;jnz @@norow
        addq.l #1,12(a3)		;inc dword ptr [edi+12]
        move.l (a6),d0			;mov eax,[esi]
        add.l d0,(a3)			;add [edi],eax
        move.l 4(a6),d0			;mov eax,[esi+4]
        add.l d0,4(a3)			;add [edi+4],eax
        move.l 8(a6),d0			;mov eax,[esi+8]
        add.l d0,8(a3)			;add [edi+8],eax
        moveq #0,d0			;mov eax,covers
        move.w 0(a0,d3.w*4),d0		;movzx eax,word ptr [eax+edx*4]
        add.l d0,16(a3)			;add [edi+16],eax
.norow
        addq.l #6,a4			;add ebp,6
        				;dec ebx
        dbf d4,.eachp			;jnz @@eachp
        				;pop edx
        lea 12(a6),a6			;add esi,12
        dbf d5,.eachs			;dec edx
        				;jnz @@eachs
	pop a0      			;pop ebp
        				;pop edi
        				;mov esi,offset @@bufvec
        move.l 12(a3),d1		;mov ebx,[esi+12]
        move.l 16(a3),d2		;mov eax,[esi+16]
		;cdq - tu jest phong
;	lsl.l #8,d2			;shl eax,8
;	divs d1,d2			;idiv ebx
;	move.l d2,(a1)			;mov [ebp],eax
;	lea 12(a1),a1			;add ebp,12

        push d6				;push ecx
        move.l (a3),d2			;mov eax,[esi]
        muls.l d2,d3:d2			;imul eax
        move.l d2,d4			;mov ebx,eax
        move.l d3,d5			;mov ecx,edx
        move.l 4(a3),d2			;mov eax,[esi+4]
        muls.l d2,d3:d2			;imul eax
        add.l d2,d4			;add ebx,eax
        addx.l d3,d5			;adc ecx,edx
        move.l 8(a3),d2			;mov eax,[esi+8]
        muls.l d2,d3:d2			;imul eax
        add.l d2,d4			;add ebx,eax
        addx.l d3,d5			;adc ecx,edx
        				;push esi
        				;push edi
        				;shld ecx,ebx,2
        				;shl ebx,2
        				;mov edi,ecx
        				;mov esi,ebx
        moveq #29,d6			;mov ecx,30
        moveq #0,d1			;xor ebx,ebx
.calsqp
        bset d6,d1			;bts ebx,ecx
        move.l d1,d2			;mov eax,ebx
        muls.l d2,d3:d2			;imul eax
        cmp.l d5,d3			;cmp edx,edi
        bhi.s .kasbip			;jg @@kasbip
        cmp.l d4,d2			;cmp eax,esi
        bls.s .toolep			;jb @@toolep
.kasbip
        bclr d6,d1			;btr ebx,ecx
.toolep
        dbf d6,.calsqp			;loop @@calsqp
        				;shr ebx,1
        				;pop edi
        				;pop esi
	tst.l d1
	bne.b .ddddd
	moveq #1,d1
.ddddd
	rept 3
	move.l (a3)+,d2			;lodsd
	rol.l #8,d2			;cdq
	move.b d2,d3			;shld edx,eax,8
	extb.l d3			;shl eax,8
	divs.l d1,d3:d2			;idiv ebx
	move.l d2,(a0)+			;stosd
	endr

        				;pop ecx
        addq.l #6,d7			;add ecx,6
        pop d6				;pop edx
        dbf d6,.kazpoi			;dec edx
        				;jnz @@kazpoi
        moveq #-1,d0			;clc
	rts				;ret
.bufvec blk.l 10,0

malloc:
	cmp.l freem(a5),d0
	bhi.b .jefrem
	move.l memad(a5),d1
	add.l d0,memad(a5)
	sub.l d0,freem(a5)
	move.l d1,d0
	rts
.jefrem
	moveq #0,d0
	rts

supobl:
	movem.l (a2),d3-d5
	push d7
	move.w (a5,d3.w*2,tabsin.w),d0
	move.w (a5,d4.w*2,tabsin.w),d1
	move.w (a5,d5.w*2,tabsin.w),d2
	move.w (a5,d3.w*2,tabsin+180.w),d3
	move.w (a5,d4.w*2,tabsin+180.w),d4
	move.w (a5,d5.w*2,tabsin+180.w),d5
	lea .tymcz(pc),a3
	move.w d3,d6
	mnoz d4,d6
	move.w d6,(a3)+
	move.w d1,(a3)+
	move.w d0,d6
	mnoz d4,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d1,d6
	mnoz d5,d6
	move.w d0,d7
	mnoz d2,d7
	add.w d7,d6
	neg.w d6
	move.w d6,(a3)+
	move.w d4,d6
	mnoz d5,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d2,d6
	move.w d0,d7
	mnoz d1,d7
	mnoz d5,d7
	sub.w d7,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d1,d6
	mnoz d2,d6
	move.w d0,d7
	mnoz d5,d7
	sub.w d7,d6
	move.w d6,(a3)+
	move.w d4,d6
	mnoz d2,d6
	neg.w d6
	move.w d6,(a3)+
	move.w d0,d6
	mnoz d1,d6
	mnoz d2,d6
	move.w d3,d7
	mnoz d5,d7
	add.w d7,d6
	move.w d6,(a3)
	lea -16(a3),a3
	pop d7
	movem.l -12(a2),a2/a4/a6
	subq.w #1,d7
.slicz
	movem.l (a0)+,d0-d2
	move.w d0,d3
	move.w d1,d4
	move.w d2,d5
	muls (a3),d3
	muls 2(a3),d4
	muls 4(a3),d5
	add.l d4,d3
	add.l d5,d3
	add.l d3,d3
	swap d3
	ext.l d3
	add.l a2,d3
	move.l d3,(a1)+
	move.w d0,d3
	move.w d1,d4
	move.w d2,d5
	muls 6(a3),d3
	muls 8(a3),d4
	muls 10(a3),d5
	add.l d4,d3
	add.l d5,d3
	add.l d3,d3
	swap d3
	ext.l d3
	add.l a4,d3
	move.l d3,(a1)+
	muls 12(a3),d0
	muls 14(a3),d1
	muls 16(a3),d2
	add.l d1,d0
	add.l d2,d0
	add.l d0,d0
	swap d0
	ext.l d0
	add.l a6,d0
	move.l d0,(a1)+
	dbf d7,.slicz
	rts
.tymcz	blk.l 10,0

obrobl:
	movem.l (a2),d3-d5
	push d7
	move.w (a5,d3.w*2,tabsin.w),d0
	move.w (a5,d4.w*2,tabsin.w),d1
	move.w (a5,d5.w*2,tabsin.w),d2
	move.w (a5,d3.w*2,tabsin+180.w),d3
	move.w (a5,d4.w*2,tabsin+180.w),d4
	move.w (a5,d5.w*2,tabsin+180.w),d5
	lea .tymcz(pc),a3
	move.w d3,d6
	mnoz d4,d6
	move.w d6,(a3)+
	move.w d1,(a3)+
	move.w d0,d6
	mnoz d4,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d1,d6
	mnoz d5,d6
	move.w d0,d7
	mnoz d2,d7
	add.w d7,d6
	neg.w d6
	move.w d6,(a3)+
	move.w d4,d6
	mnoz d5,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d2,d6
	move.w d0,d7
	mnoz d1,d7
	mnoz d5,d7
	sub.w d7,d6
	move.w d6,(a3)+
	move.w d3,d6
	mnoz d1,d6
	mnoz d2,d6
	move.w d0,d7
	mnoz d5,d7
	sub.w d7,d6
	move.w d6,(a3)+
	move.w d4,d6
	mnoz d2,d6
	neg.w d6
	move.w d6,(a3)+
	move.w d0,d6
	mnoz d1,d6
	mnoz d2,d6
	move.w d3,d7
	mnoz d5,d7
	add.w d7,d6
	move.w d6,(a3)
	lea -16(a3),a3
	pop d7
	subq.w #1,d7
.slicz
	movem.l (a0)+,d0-d2
	move.w d0,d3
	move.w d1,d4
	move.w d2,d5
	muls (a3),d3
	muls 2(a3),d4
	muls 4(a3),d5
	add.l d4,d3
	add.l d5,d3
	add.l d3,d3
	swap d3
	ext.l d3
	move.l d3,(a1)+
	move.w d0,d3
	move.w d1,d4
	move.w d2,d5
	muls 6(a3),d3
	muls 8(a3),d4
	muls 10(a3),d5
	add.l d4,d3
	add.l d5,d3
	add.l d3,d3
	swap d3
	ext.l d3
	move.l d3,(a1)+
	muls 12(a3),d0
	muls 14(a3),d1
	muls 16(a3),d2
	add.l d1,d0
	add.l d2,d0
	add.l d0,d0
	swap d0
	ext.l d0
	move.l d0,(a1)+
	dbf d7,.slicz
	rts
.tymcz	blk.l 10,0

maktpal:
	lea truepal+131072,a1
	move.w #511,d7
.kazkol
	moveq #127,d6
	moveq #6,d1
.kazsha
	move.w d7,d2
	lsr.w #1,d2
	and.w #$e0,d2
	mulu d1,d2
	move.w d7,d3
	lsl.w #2,d3
	and.w #$e0,d3
	mulu d1,d3
	move.w d7,d4
	lsl.w #5,d4
	and.w #$e0,d4
	mulu d1,d4
	move.w d2,d5
	lsr.w #4,d5
	and.w #$f00,d5
	move.w d3,d0
	lsr.w #8,d0
	and.w #$f0,d0
	add.w d0,d5
	move.w d4,d0
	rol.w #4,d0
	and.w #15,d0
	add.w d0,d5
	move.w d7,d0
	lsl.w #7,d0
	add.w d6,d0
	eor.w #127,d0
	move.w d5,0(a1,d0.w*4)		;add edi,3
	and.w #$f00,d2
	lsr.w #4,d3
	and.w #$f0,d3
	add.w d3,d2
	lsr.w #8,d4
	and.w #15,d4
	add.w d4,d2
	move.w d2,2(a1,d0.w*4)
	addq.w #2,d1
	dbf d6,.kazsha
	dbf d7,.kazkol
	rts

dofuckout:
	tst.w .owndel
	beq.b .ojeze
	subq.w #1,.owndel
	rts
.ojeze
	push a5
	lea vars,a5
	move.w fadop(a5),.owndel
	subq.w #1,fadfaz(a5)
	bne.b .jeznok
	move.l #0,inter(a5)
.jeznok
	pop a5
	rts
.owndel	dc.w 0

dofuckin:
	tst.w .owndel
	beq.b .ojeze
	subq.w #1,.owndel
	rts
.ojeze
	push a5
	lea vars,a5
	move.w fadop(a5),.owndel
	addq.w #1,fadfaz(a5)
	cmp.w #16,fadfaz(a5)
	bne.b .jeznok
	move.l #0,inter(a5)
.jeznok
	pop a5
	rts
.owndel	dc.w 0

initstars:
	lea starsarr,a0
	move.w #maxstars-1,d7
	move.w #$baca,d0
.genwsp
	rept 3
	muls.w #$adaf,d0
	add.w #$1234,d0
	ror.w #5,d0
	move.w d0,d1
	and.w #$1ffe,d1
	sub.w #4095,d1
	ext.l d1
	move.l d1,(a0)+
	endr
	dbf d7,.genwsp
	rts

drawstars:
	lea starsarr,a0
	lea bufobr,a1
	movem.l move_o(a5),d4-d6
	move.w #maxstars-1,d7
	move.w #12,a2
.przess
	movem.l (a0)+,d1-d3
	sub.l d4,d1
	sub.l d5,d2
	sub.l d6,d3
	movem.l d1-d3,(a1)
	add.w a2,a1
	dbf d7,.przess
	lea bufobr,a1
	move.l a1,a0
	lea ang_o(a5),a2
	move.w #maxstars-1,d7
	bsr obrobl
	move.l screen(a5),a1
	move.l zbuffer(a5),a2
	lea bufobr,a0
	move.w #maxstars-1,d7
	move.l #zclip,d6
	move.w #xclip+1,d4
	move.w #yclip+1,d5
	move.l #16383*256,d3
.kazstar
	movem.l (a0)+,d0-d2
	cmp.l d6,d2
	ble.b .nodraw
	lsl.l #7,d0
	divs.w d2,d0			;idiv ebx
        add.w #xcenter,d0		;add eax,xcenter*256
	bmi.b .nodraw
	cmp.w d4,d0
	bge.b .nodraw
	lsl.l #7,d1
	divs.w d2,d1
	add.w #ycenter,d1
	bmi.b .nodraw
	cmp.w d5,d1
	bge.b .nodraw
	mulu.w d4,d1
	add.w d0,d1
	lsl.l #8,d2
	move.l d2,0(a2,d1.w*4)
	cmp.l d3,d2
	ble.b .wzakz
	move.l d3,d2
.wzakz
	swap d2
	not.w d2
	move.w d2,0(a1,d1.w*2)
.nodraw
	dbf d7,.kazstar
	rts

depakiff:
	cmp.l #'FORM',(a0)+
	beq.b .nofori
.frajer
	rts
.nofori
	addq.l #4,a0
	cmp.l #'ILBM',(a0)+
	bne.b .frajer
.glopel
	move.l (a0)+,d0
	cmp.l #'BMHD',d0
	beq.w .getpar
	cmp.l #'CMAP',d0
	beq.w .getcol
	cmp.l #'CCRT',d0
	beq.s .ignoru
	cmp.l #'CRNG',d0
	beq.s .ignoru
	cmp.l #'GRAB',d0
	beq.s .ignoru
	cmp.l #'DEST',d0
	beq.s .ignoru
	cmp.l #'SPRT',d0
	beq.s .ignoru
	cmp.l #'DPPS',d0
	beq.s .ignoru
	cmp.l #'DPAN',d0
	beq.s .ignoru
	cmp.l #'CAMG',d0
	beq.w .ignoru
	cmp.l #'BODY',d0
	beq.w .calyob
	cmp.l #`ANNO`,d0
	beq.s .ignoru
	cmp.l #`ASDG`,d0
	beq.s .ignoru
	cmp.l #`DPI `,d0
	beq.s .ignoru
	cmp.l #`DPXT`,d0
	beq.s .ignoru
	bra.w .frajer
.ignoru
	move.l (a0)+,d0
	add.l d0,a0
	bra.w .glopel
.getpar
	move.l (a0)+,d0
	move.l a0,a1
	add.l d0,a0
	move.b 10(a1),.kompre
	cmp.w #320,(a1)
	bne.w .frajer
	move.w 2(a1),d0
	cmp.w #183,d0
	ble.b .wlawys
	move.w #183,d0
.wlawys
	move.w d0,.korely
	moveq #0,d2
	move.b 8(a1),d2
	move.w .copmod-2(pc,d2.w*2),modei+2
	move.w d2,.ilkol
	subq.w #1,d2
	mulu #40,d2
	subq.w #8,d2
	move.w d2,moduloi+2
	move.w d2,moduloi+6
	bra.w .glopel
.copmod	dc.w $1201,$2201,$3201,$4201,$5201,$6201,$7201,$211
.kompre	dc.w 0
.korely	dc.w 0
.ilkol	dc.w 0
.getcol
	move.l (a0)+,d0
	move.l a0,a1
	add.l d0,a0
	lea iffpal,a2
	move.w #255,d0
	moveq #0,d1
.pegepa
	move.b (a1)+,(a2)+
	move.b (a1)+,(a2)+
	move.b (a1)+,(a2)+
	dbf d0,.pegepa
	bra.w .glopel
.calyob
	move.l (a0)+,d0
	lea iffbuf,a1
	move.w .korely(pc),d7
	subq.w #1,d7
	moveq #40,d5
	tst.w .kompre
	beq.b .simply
.kazlin
	move.w .ilkol(pc),d6
	subq.w #1,d6
.kazpla
	moveq #0,d3
.peglod
	cmp.w d3,d5
	ble.b .poodko
	btst #7,(a0)
	beq.b .bezkom
	cmp.b #128,(a0)
	bne.b .pegloq
	addq.l #1,a0
	bra.b .peglod
.pegloq
	moveq #0,d2
	move.b (a0)+,d2
	sub.w #257,d2
	neg.w d2
	add.w d2,d3
	subq.w #1,d2
	move.b (a0)+,d1
	trans d1,(a1)+,d2,b
	bra.b .peglod
.bezkom
	moveq #0,d4
	move.b (a0)+,d4
	move.w d4,d2
	trans (a0)+,(a1)+,d4,b
	addq.w #1,d2
	add.w d2,d3
	bra.b .peglod
.poodko
	dbf d6,.kazpla
	dbf d7,.kazlin
	bra.b .inspoi
.simply
	move.w .ilkol(pc),d6
	subq.w #1,d6
.simpla
	move.w d5,d4
	subq.w #1,d4
	trans (a0)+,(a1)+,d4,b
	dbf d6,.simpla
	dbf d7,.simply
.inspoi
	lea adekri+2,a0
	move.l #iffbuf,d0
	moveq #40,d1
	moveq #7,d2
.kazbit
	move.w d0,4(a0)
	swap d0
	move.w d0,(a0)
	swap d0
	add.l d1,d0
	addq.l #8,a0
	dbf d2,.kazbit
	rts

dofadeout:
	wait 1
	move.l #coperi,$dff080
	wait 1
	move.w d1,d2
	move.w d2,d3
	and.w #$f00,d1
	and.w #$f0,d2
	and.w #15,d3
	lsr.w #4,d1
	lsl.w #4,d3
	move.w d1,a1
	move.w d2,a2
	move.w d3,a3
	moveq #63,d7
	moveq #1,d5
.kazfaz
	lea iffpal,a0
	lea $dff180,a4
	swap d7
	move.w #7,d7
	move.w #$22,d6
.kazblo
	moveq #31,d4
	move.l a4,a6
.kazkol
	moveq #0,d1
	moveq #0,d2
	moveq #0,d3
	move.b (a0),d1
	move.b 1(a0),d2
	move.b 2(a0),d3
	sub.w a1,d1
	sub.w a2,d2
	sub.w a3,d3
	neg.w d1
	neg.w d2
	neg.w d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	asr.w #6,d1
	asr.w #6,d2
	asr.w #6,d3
	add.b (a0)+,d1
	add.b (a0)+,d2
	add.b (a0)+,d3
	move.w d6,$dff106
	mpush d1-d3
	lsl.w #4,d1
	move.b d2,d1
	and.w #$ff0,d1
	lsr.w #4,d3
	and.w #15,d3
	or.w d3,d1
	move.w d1,(a6)
	move.w d6,d1
	or.w #$200,d1
	move.w d1,$dff106
	mpop d1-d3
	lsl.w #8,d1
	lsl.b #4,d2
	move.b d2,d1
	and.w #$ff0,d1
	and.w #15,d3
	or.w d3,d1
	move.w d1,(a6)+
	dbf d4,.kazkol
	add.w #$2000,d6
	dbf d7,.kazblo
	swap d7
	addq.w #1,d5
	move.w d0,czas(a5)
.wyczf
	btst #6,$bfe001
	beq.l exit
	tst.w czas(a5)
	bne.b .wyczf
	dbf d7,.kazfaz
	rts

dofadein:
	wait 1
	move.l #coperi,$dff080
	wait 1
	move.w d1,d2
	move.w d2,d3
	and.w #$f00,d1
	and.w #$f0,d2
	and.w #15,d3
	lsr.w #4,d1
	lsl.w #4,d3
	move.w d1,a1
	move.w d2,a2
	move.w d3,a3
	moveq #63,d7
	moveq #1,d5
.kazfaz
	lea iffpal,a0
	lea $dff180,a4
	swap d7
	move.w #7,d7
	move.w #$22,d6
.kazblo
	moveq #31,d4
	move.l a4,a6
.kazkol
	moveq #0,d1
	moveq #0,d2
	moveq #0,d3
	move.b (a0)+,d1
	move.b (a0)+,d2
	move.b (a0)+,d3
	sub.w a1,d1
	sub.w a2,d2
	sub.w a3,d3
	muls.w d5,d1
	muls.w d5,d2
	muls.w d5,d3
	asr.w #6,d1
	asr.w #6,d2
	asr.w #6,d3
	add.w a1,d1
	add.w a2,d2
	add.w a3,d3
	move.w d6,$dff106
	mpush d1-d3
	lsl.w #4,d1
	move.b d2,d1
	and.w #$ff0,d1
	lsr.w #4,d3
	and.w #15,d3
	or.w d3,d1
	move.w d1,(a6)
	move.w d6,d1
	or.w #$200,d1
	move.w d1,$dff106
	mpop d1-d3
	lsl.w #8,d1
	lsl.b #4,d2
	move.b d2,d1
	and.w #$ff0,d1
	and.w #15,d3
	or.w d3,d1
	move.w d1,(a6)+
	dbf d4,.kazkol
	add.w #$2000,d6
	dbf d7,.kazblo
	swap d7
	addq.w #1,d5
	move.w d0,czas(a5)
.wyczf
	btst #6,$bfe001
	beq.l exit
	tst.w czas(a5)
	bne.b .wyczf
	dbf d7,.kazfaz
	rts

showit:
	lea iffpal,a0
	lea $dff180,a1
	moveq #7,d7
	move.w #$22,d0
	wait 1
	move.l #coperi,$dff080
	wait 1
.kazblo
	moveq #31,d6
	move.w d0,$dff106
	move.l a1,a2
.kazkol
	moveq #0,d1
	move.b (a0)+,d1
	lsl.w #4,d1
	move.b (a0)+,d1
	move.b (a0)+,d2
	lsr.b #4,d2
	and.w #$ff0,d1
	or.b d2,d1
	move.w d1,(a2)+
	dbf d6,.kazkol
	add.w #$2000,d0
	dbf d7,.kazblo
	rts
iffpal	blk.l 192,0

maktex:
	lea textures,a0			;mov edi,textures
	moveq #numtextures/2,d7
	subq.w #1,d7
.mixmem
	lea truepal,a2
	move.l a0,a1
	move.w #8191,d6
.kopfir
	move.l (a1)+,(a2)+
	dbf d6,.kopfir
	move.l a0,a1
	add.l #32768,a1
	lea 256(a0),a2
	moveq #127,d6
.kazli1
	moveq #63,d5
.kazlo1
	move.l (a1)+,(a2)+
	dbf d5,.kazlo1
	lea 256(a2),a2
	dbf d6,.kazli1
	lea truepal,a1
	move.l a0,a2
	moveq #127,d6
.kazli2
	moveq #63,d5
.kazlo2
	move.l (a1)+,(a2)+
	dbf d5,.kazlo2
	lea 256(a2),a2
	dbf d6,.kazli2
	add.l #65536,a0
	dbf d7,.mixmem
	rts				;ret

clrscr:
	moveq #0,d0
	move.l ekr(a5),a1
	lea 18(a1),a1
	moveq #60,d7
.pelin
	move.l a1,a0
	moveq #2,d6
.pekas
	move.w d0,(a0)
	move.w d0,4(a0)
	move.w d0,8(a0)
	move.w d0,12(a0)
	move.w d0,16(a0)
	move.w d0,20(a0)
	move.w d0,24(a0)
	move.w d0,28(a0)
	move.w d0,32(a0)
	move.w d0,36(a0)
	move.w d0,40(a0)
	move.w d0,44(a0)
	move.w d0,48(a0)
	move.w d0,52(a0)
	move.w d0,56(a0)
	move.w d0,60(a0)
	move.w d0,64(a0)
	move.w d0,68(a0)
	move.w d0,72(a0)
	move.w d0,76(a0)
	move.w d0,80(a0)
	move.w d0,84(a0)
	move.w d0,88(a0)
	move.w d0,92(a0)
	move.w d0,96(a0)
	move.w d0,100(a0)
	move.w d0,104(a0)
	move.w d0,108(a0)
	move.w d0,112(a0)
	move.w d0,116(a0)
	move.w d0,120(a0)
	move.w d0,124(a0)
	lea 132(a0),a0
	dbf d6,.pekas
	move.w d0,(a0)
	move.w d0,4(a0)
	move.w d0,8(a0)
	move.w d0,12(a0)
	move.w d0,16(a0)
	move.w d0,20(a0)
	move.w d0,24(a0)
	move.w d0,28(a0)
	move.w d0,32(a0)
	move.w d0,36(a0)
	move.w d0,40(a0)
	move.w d0,44(a0)
	move.w d0,48(a0)
	move.w d0,52(a0)
	move.w d0,56(a0)
	move.w d0,60(a0)
	move.w d0,64(a0)
	move.w d0,68(a0)
	move.w d0,72(a0)
	move.w d0,76(a0)
	lea linlen(a1),a1
	dbf d7,.pelin
	rts

makmir:
	lea inslin1,a0
	lea inslin2,a1
	moveq #59,d7
	moveq #$28+30,d0
.peins
	move.b d0,(a0)
	move.b d0,(a1)
	addq.b #3,d0
	lea linlen(a0),a0
	lea linlen(a1),a1
	dbf d7,.peins
	lea dispbuf,a0
	moveq #2,d4
	moveq #0,d5
.kazlin
	moveq #0,d0
	move.l (a5,d5.l*4,tabmir.w),d1
	moveq #115,d7
.putkol
	moveq #7,d6
	move.l a0,a1
.kazpla
	moveq #0,d3
	btst d6,d0
	beq.s .mabzer
	not.l d3
.mabzer
	bfins d3,(a1){d1:3}
	lea 48(a1),a1
	dbf d6,.kazpla
	addq.w #1,d0
	cmp.w #90,d0
	bne.b .noprzes
	addq.w #6,d0
.noprzes
	addq.w #3,d1
	dbf d7,.putkol
	lea 48*8(a0),a0
	addq.l #1,d5
	dbf d4,.kazlin
	moveq #2,d4
.kazliq
	move.l (a5,d5.l*4,tabmir.w),d1
	moveq #115,d7
	move.w #128,d0
.putkoq
	moveq #7,d6
	move.l a0,a1
.kazplq
	moveq #0,d3
	btst d6,d0
	beq.s .mabzeq
	not.l d3
.mabzeq
	bfins d3,(a1){d1:3}
	lea 48(a1),a1
	dbf d6,.kazplq
	addq.w #1,d0
	cmp.w #90+128,d0
	bne.b .noprzeq
	addq.w #6,d0
.noprzeq
	addq.w #3,d1
	dbf d7,.putkoq
	lea 48*8(a0),a0
	addq.l #1,d5
	dbf d4,.kazliq
	lea dispbuf,a0
	bsr .speli1
	lea dispbuf+48*8*2,a0
	bsr .speli1
	lea dispbuf+48*8*4,a0
	bsr .speli2
;	lea dispbuf,a0
;	move.l #$55555555,d0
;	moveq #5,d7
;.kazlk
;	moveq #12*8-1,d6
;.kazlo
;	and.l d0,(a0)+
;	dbf d6,.kazlo
;	not.l d0
;	dbf d7,.kazlk
	move.l #dispbuf,d1
	lea adekr1+2,a0
	lea adekr2+2,a1
	moveq #7,d7
.inspla
	move.w d1,4(a0)
	move.w d1,4(a1)
	swap d1
	move.w d1,(a0)
	move.w d1,(a1)
	swap d1
	add.l #48,d1
	addq.l #8,a0
	addq.l #8,a1
	dbf d7,.inspla
	rts
.speli2
	moveq #0,d0
	moveq #0,d1
	moveq #115,d7
.pespeq
	move.l d0,d2
	subq.w #1,d2
	bpl.s .mozeq1
	moveq #0,d2
.mozeq1
	add.w #128,d2
	bsr .pplot
	move.l d0,d2
	addq.w #1,d1
	add.w #128,d2
	bsr .pplot
	move.l d0,d2
	addq.w #1,d2
	cmp.w #115,d2
	ble.s .mozeq2
	moveq #115,d2
.mozeq2
	addq.w #1,d1
	add.w #128,d2
	bsr .pplot
	addq.w #1,d0
	addq.w #1,d1
	dbf d7,.pespeq
	rts
.speli1
	moveq #0,d0
	moveq #0,d1
	moveq #115,d7
.pespel
	move.l d0,d2
	subq.w #1,d2
	bpl.s .mozeb1
	moveq #0,d2
.mozeb1
	bsr .pplot
	move.l d0,d2
	addq.w #1,d1
	bsr .pplot
	move.l d0,d2
	addq.w #1,d2
	cmp.w #115,d2
	ble.s .mozeb2
	moveq #115,d2
.mozeb2
	addq.w #1,d1
	bsr .pplot
	addq.w #1,d0
	addq.w #1,d1
	dbf d7,.pespel
	rts
.pplot
	push d2
	cmp.w #128,d2
	bge.b .osobn
	cmp.w #89,d2
	ble.b .wporzp
	addq.w #6,d2
	bra.b .wporzp
.osobn
	cmp.w #89+128,d2
	ble.b .wporzp
	addq.w #6,d2
.wporzp
	moveq #7,d6
	move.l a0,a1
.plotp
	moveq #0,d3
	btst d6,d2
	beq.s .dobwyp
	not.l d3
.dobwyp
	bfins d3,(a1){d1:1}
	lea 48(a1),a1
	dbf d6,.plotp
	pop d2
	rts

insekr:
	move.w oldtime(a5),d0
.czenak
	cmp.w ttime(a5),d0
	beq.b .czenak
	move.w ttime(a5),oldtime(a5)
	lea ekr1,a1
	lea ekr2,a2
	lea coper1,a3
	lea coper2,a4
	tst.w .flag
	beq.s .notcha
	exg a1,a2
	exg a3,a4
.notcha
	not.w .flag
	move.l a1,aekr(a5)
	move.l a2,ekr(a5)
	move.l a3,$dff080
	rts
.flag	dc.w 0

initcop:
	lea copdata,a0
	lea inslin1,a1
	lea inslin2,a2
	moveq #29,d7
.kazlin
	move.w #linlen/2-1,d6
	move.l a0,a3
.kazlon
	move.l (a3)+,d0
	move.l d0,(a1)+
	move.l d0,(a2)+
	dbf d6,.kazlon
	dbf d7,.kazlin
	rts

setgmode:
	wait 1
	move.l #dumcop,$dff080
	moveq #0,d0
	lea ekr1+18,a2
	lea ekr2+18,a3
	moveq #60,d6
.kazlic
	move.l a2,a0
	move.l a3,a1
	moveq #15,d7
.wypze1
	move.w d0,(a0)
	move.w d0,(a1)
	move.w d0,4(a0)
	move.w d0,4(a1)
	addq.l #8,a0
	addq.l #8,a1
	dbf d7,.wypze1
	addq.l #4,a0
	addq.l #4,a1
	moveq #15,d7
.wypze2
	move.w d0,(a0)
	move.w d0,(a1)
	move.w d0,4(a0)
	move.w d0,4(a1)
	addq.l #8,a0
	addq.l #8,a1
	dbf d7,.wypze2
	addq.l #4,a0
	addq.l #4,a1
	moveq #12,d7
.wypze3
	move.w d0,(a0)
	move.w d0,(a1)
	move.w d0,4(a0)
	move.w d0,4(a1)
	addq.l #8,a0
	addq.l #8,a1
	dbf d7,.wypze3
	addq.l #4,a0
	addq.l #4,a1
	moveq #12,d7
.wypze4
	move.w d0,(a0)
	move.w d0,(a1)
	move.w d0,4(a0)
	move.w d0,4(a1)
	addq.l #8,a0
	addq.l #8,a1
	dbf d7,.wypze4
	lea linlen(a2),a2
	lea linlen(a3),a3
	dbf d6,.kazlic
	wait 1
	lea data12,a0
	tst.w trueflag(a5)
	beq.b .wlamod
	lea data24,a0
.wlamod
	lea coper1+14,a1
	lea coper2+14,a2
	move.w (a0),(a1)
	move.w (a0)+,(a2)
	move.w (a0),4(a1)
	move.w (a0)+,4(a2)
	move.w (a0),8(a1)
	move.w (a0)+,8(a2)
	move.w (a0),12(a1)
	move.w (a0)+,12(a2)
	move.w (a0),16(a1)
	move.w (a0)+,16(a2)
	move.w (a0)+,d6
	move.w #48*7-8,d0
	add.w d6,d0
	move.w #-48*8*5-56,d1
	add.w d6,d1
	lea ekr1,a1
	lea ekr2,a2
	lea 10(a0),a3
	move.w (a3),36*4+2(a1)
	move.w (a3)+,36*4+2(a2)
	move.w (a3),69*4+2(a1)
	move.w (a3)+,69*4+2(a2)
	move.w (a3),96*4+2(a1)
	move.w (a3)+,96*4+2(a2)
	lea linlen(a1),a1
	lea linlen(a2),a2
	moveq #29,d7
.kazlin
	move.l a0,a3
	move.w d0,10(a1)
	move.w d0,10(a2)
	move.w d0,14(a1)
	move.w d0,14(a2)
	move.w (a3),6(a1)
	move.w (a3)+,6(a2)
	move.w (a3),36*4+2(a1)
	move.w (a3)+,36*4+2(a2)
	move.w (a3),69*4+2(a1)
	move.w (a3)+,69*4+2(a2)
	move.w (a3),96*4+2(a1)
	move.w (a3)+,96*4+2(a2)
	lea linlen(a1),a1
	lea linlen(a2),a2
	move.w d0,-2(a1)
	move.w d0,-2(a2)
	move.w d0,-6(a1)
	move.w d0,-6(a2)
	move.w d0,10(a1)
	move.w d0,10(a2)
	move.w d0,14(a1)
	move.w d0,14(a2)
	move.w (a3),6(a1)
	move.w (a3)+,6(a2)
	move.w (a3),36*4+2(a1)
	move.w (a3)+,36*4+2(a2)
	move.w (a3),69*4+2(a1)
	move.w (a3)+,69*4+2(a2)
	move.w (a3),96*4+2(a1)
	move.w (a3)+,96*4+2(a2)
	lea linlen(a1),a1
	lea linlen(a2),a2
	move.w d1,-2(a1)
	move.w d1,-2(a2)
	move.w d1,-6(a1)
	move.w d1,-6(a2)
	dbf d7,.kazlin
	move.w d0,6(a1)
	move.w d0,6(a2)
	move.w d0,10(a1)
	move.w d0,10(a2)
	rts
data12	dc.w $3871,$fec7,$18,$d0,$88aa,0
	dc.w $8022,$a022,$c022,$e022,$22,$2022,$4022,$6022
data24	dc.w $3877,$fe6e,$58,$90,0,32
	dc.w $8022,$8222,$a022,$a222,$22,$222,$2022,$2222

	align 4,4
copdata	dc.w $2b01,-2,$106,$8022,$108,48*7-8,$10a,48*7-8
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$a022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$c022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $106,$e022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $108,48*7-8,$10a,48*7-8
	dc.w $2801,-2,$106,$22,$108,48*7-8,$10a,48*7-8
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$2022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$4022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $106,$6022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $108,-48*8*5-56,$10a,-48*8*5-56

dopicin:
	moveq #31,d7
	moveq #1,d6
	moveq #$7f,d5
	move.w d5,d4
	not.w d4
	move.l #ekr1,ekr(a5)
.pedofa
	lea picbuf,a0
	lea maiscr,a1
	move.w #116*61-1,d3
.kazpun
	move.w (a0)+,d1
	move.w d1,d2
	and.w d4,d1
	and.w d5,d2
	mulu.w d6,d2
	lsr.w #5,d2
	or.w d1,d2
	move.w d2,(a1)+
	dbf d3,.kazpun
	movem.l d0-a6,-(a7)
	jsr copyscr
	movem.l (a7)+,d0-a6
	move.w d0,czas(a5)
.odczes
	btst #6,$bfe001
	beq.l exit
	tst.w czas(a5)
	bne.b .odczes
	move.l #coper1,$dff080
	addq.w #1,d6
	dbf d7,.pedofa
	rts

dopicout:
	moveq #31,d7
	moveq #31,d6
	moveq #$7f,d5
	move.w d5,d4
	not.w d4
	move.l #ekr1,ekr(a5)
.pedofa
	lea picbuf,a0
	lea maiscr,a1
	move.w #116*61-1,d3
.kazpun
	move.w (a0)+,d1
	move.w d1,d2
	and.w d4,d1
	and.w d5,d2
	mulu.w d6,d2
	lsr.w #5,d2
	or.w d1,d2
	move.w d2,(a1)+
	dbf d3,.kazpun
	movem.l d0-a6,-(a7)
	jsr copyscr
	movem.l (a7)+,d0-a6
	move.w d0,czas(a5)
.odczes
	btst #6,$bfe001
	beq.l exit
	tst.w czas(a5)
	bne.b .odczes
	move.l #coper1,$dff080
	subq.w #1,d6
	dbf d7,.pedofa
	rts

depmus:
	move.w (a0)+,d6
	subq.w #1,d6
	move.w (a0)+,d7
	subq.w #1,d7
.kazbyt
	move.b (a0)+,(a1)+
	dbf d7,.kazbyt
.kazblo
	move.l a0,a2
	lea 512(a0),a0
	moveq #0,d0
	move.w #4999,d5
.kazvec
	move.b (a0)+,d0
	move.w 0(a2,d0.w*2),(a1)+
	dbf d5,.kazvec
	dbf d6,.kazblo
	rts

prepglas:
	lea colbyts,a0
	moveq #7,d7
	moveq #0,d0
.kazr
	moveq #7,d6
	moveq #0,d1
.kazg
	moveq #7,d5
	moveq #0,d2
.kazb
	moveq #15,d4
	moveq #1,d3
.kazsha
	mpush d0-d2
	muls.w d3,d0
	muls.w d3,d1
	muls.w d3,d2
	lsr.w #4,d0
	lsr.w #4,d1
	lsr.w #4,d2
	move.b d0,(a0)
	move.b d1,1(a0)
	move.b d2,2(a0)
	addq.l #4,a0
	mpop d0-d2
	addq.w #1,d3
	dbf d4,.kazsha
	add.w #32,d2
	dbf d5,.kazb
	add.w #32,d1
	dbf d6,.kazg
	add.w #32,d0
	dbf d7,.kazr
	rts

instext:
	moveq #0,d4
	lsr.w #1,d0
	bcc.b .nonext
	moveq #1,d4
.nonext
	lsl.w #8,d0
	add.w d4,d0
	lsl.l #8,d0
	lea textures,a1
	add.l d0,a1
	moveq #127,d7
.kazlin
	moveq #31,d6
.kazwie
	move.l (a0)+,(a1)+
	move.l (a0)+,(a1)+
	dbf d6,.kazwie
	lea 256(a1),a1
	dbf d7,.kazlin
	rts

NormalDecrunch
	movem.l	d0-d7/a0-a6,-(sp)
	cmp.l	#"CrM!",(a0)+
	bne.s	.NotCrunched
	tst.w	(a0)+
	move.l	(a0)+,d1
	move.l	(a0)+,d2
	move.l	a0,a2
	lea anddata-2(pc),a0
	moveq #1,d5
	bsr.s	FastDecruncher
.NotCrunched
	movem.l	(sp)+,d0-d7/a0-a6
	rts

FastDecruncher
	move.l	a1,a5
	add.l	d1,a1
	add.l	d2,a2
	move.w	-(a2),d0
	move.l	-(a2),d6
	moveq	#16,d7
	sub.w	d0,d7
	lsr.l	d7,d6
	move.w	d0,d7
	moveq	#16,d3
	moveq	#0,d4
.DecrLoop

	BitTest
	bcc.s	.InsertSeq
	moveq	#0,d4
.InsertBytes
	moveq	#8,d1
	GetBits
	move.b	d0,-(a1)
	dbf	d4,.InsertBytes
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts

.SpecialInsert
	moveq	#14,d4
	moveq	#5,d1
	BitTest
	bcs.s	.IB1
	moveq	#14,d1
.IB1
	GetBits
	add.w	d0,d4
	bra.s	.InsertBytes
.InsertSeq
	BitTest
	bcs.s	.AB1
	moveq	#1,d1
	moveq	#1,d4
	GetBits
	add.w	d0,d4
	cmp.w	#22,d4
	beq.w	.SpecialInsert
	blt.s	.Cont
	subq.w	#1,d4
.Cont
	BitTest
	bcs.w	.DB1
	moveq	#9,d1
	moveq	#$20,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
.AB1
	BitTest
	bcs.s	.AB2
	moveq	#2,d1
	moveq	#3,d4
	GetBits
	add.w	d0,d4
	cmp.w	#22,d4
	beq.w	.SpecialInsert
	blt.s	.Cont2
	subq.w	#1,d4
.Cont2
	BitTest
	bcs.w	.DB1
	moveq	#9,d1
	moveq	#$20,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop2
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop2
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
.AB2
	BitTest
	bcs.s	.AB3
	moveq	#4,d1
	moveq	#7,d4
	GetBits
	add.w	d0,d4
	cmp.w	#22,d4
	beq.w	.SpecialInsert
	blt.s	.Cont3
	subq.w	#1,d4
.Cont3
	BitTest
	bcs.w	.DB1
	moveq	#9,d1
	moveq	#$20,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop3
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop3
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
.AB3
	moveq	#8,d1
	moveq	#$17,d4
	GetBits
	add.w	d0,d4
	cmp.w	#22,d4
	beq.w	.SpecialInsert
	blt.s	.Cont4
	subq.w	#1,d4
.Cont4
	BitTest
	bcs.s	.DB1
	moveq	#9,d1
	moveq	#$20,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop4
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop4
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
.DB1
	BitTest
	bcs.s	.DB2
	moveq	#5,d1
	moveq	#0,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop5
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop5
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
.DB2
	moveq	#14,d1
	move.w	#$220,d2
	GetBits
	add.w	d2,d0
	lea	0(a1,d0.w),a3
.InsSeqLoop6
	move.b	-(a3),-(a1)
	dbf	d4,.InsSeqLoop6
	cmp.l	a5,a1
	bgt.w	.Decrloop
	rts
AndData
	dc.w	%1,%11,%111,%1111,%11111,%111111,%1111111
	dc.w	%11111111,%111111111,%1111111111
	dc.w	%11111111111,%111111111111
	dc.w	%1111111111111,%11111111111111
mt_lev6use=		0		; 0=NO, 1=YES
mt_finetuneused=	1		; 0=NO, 1=YES

mt_init	move.l	mt_data(a5),A0
	MOVE.L	A0,mt_SongDataPtr
	LEA	250(A0),A1
	MOVE.W	#511,D0
	MOVEQ	#0,D1
mtloop	MOVE.L	D1,D2
	SUBQ.W	#1,D0
mtloop2	MOVE.B	(A1)+,D1
	CMP.W	D2,D1
	BGT.S	mtloop
	DBRA	D0,mtloop2
	ADDQ	#1,D2

	MOVE.W	D2,D3
	MULU	#128,D3
	ADD.L	#766,D3
	ADD.L	mt_SongDataPtr(PC),D3
	MOVE.L	D3,mt_LWTPtr

	LEA	mt_SampleStarts(PC),A1
	MULU	#128,D2
	ADD.L	#762,D2
	ADD.L	(A0,D2.L),D2
	ADD.L	mt_SongDataPtr(PC),D2
	ADDQ.L	#4,D2
	MOVE.L	D2,A2
	MOVEQ	#30,D0
mtloop3	MOVE.L	A2,(A1)+
	MOVEQ	#0,D1
	MOVE.W	(A0),D1
	ADD.L	D1,D1
	ADD.L	D1,A2
	LEA	8(A0),A0
	DBRA	D0,mtloop3

	OR.B	#2,$BFE001
	lea	mt_speed(PC),A4
	MOVE.B	#6,(A4)
	CLR.B	mt_counter-mt_speed(A4)
	CLR.B	mt_SongPos-mt_speed(A4)
	CLR.W	mt_PatternPos-mt_speed(A4)
mt_end	LEA	$DFF096,A0
	CLR.W	$12(A0)
	CLR.W	$22(A0)
	CLR.W	$32(A0)
	CLR.W	$42(A0)
	MOVE.W	#$F,(A0)
	RTS

mt_music
	MOVEM.L	D0-D4/D7/A0-A6,-(SP)
	ADDQ.B	#1,mt_counter
	MOVE.B	mt_counter(PC),D0
	CMP.B	mt_speed(PC),D0
	BLO.S	mt_NoNewNote
	CLR.B	mt_counter
	TST.B	mt_PattDelTime2
	BEQ.S	mt_GetNewNote
	BSR.S	mt_NoNewAllChannels
	BRA.W	mt_dskip

mt_NoNewNote
	BSR.S	mt_NoNewAllChannels
	BRA.W	mt_NoNewPosYet

mt_NoNewAllChannels
	LEA	$dff090,A5
	LEA	mt_chan1temp-44(PC),A6
	BSR.W	mt_CheckEfx
	BSR.W	mt_CheckEfx
	BSR.W	mt_CheckEfx
	BRA.W	mt_CheckEfx

mt_GetNewNote
	MOVE.L	mt_SongDataPtr(PC),A0
	LEA	(A0),A3
	LEA	122(A0),A2	;pattpo
	LEA	762(A0),A0	;patterndata
	CLR.W	mt_DMACONtemp

	LEA	$DFF090,A5
	LEA	mt_chan1temp-44(PC),A6
	BSR.S	mt_DoVoice
	BSR.S	mt_DoVoice
	BSR.s	mt_DoVoice
	BSR.s	mt_DoVoice
	BRA.W	mt_SetDMA

mt_DoVoice
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.B	mt_SongPos(PC),D0
	LEA	128(A2),A2
	MOVE.B	(A2,D0.W),D1
	MOVE.W	mt_PatternPos(PC),D2
	LSL	#7,D1
	LSR.W	#1,D2
	ADD.W	D2,D1
	LEA	44(A6),A6
	lea	$10(a5),a5

	TST.L	(A6)
	BNE.S	mt_plvskip
	BSR.W	mt_PerNop
mt_plvskip
	MOVE.W	(A0,D1.W),D1
	LSL.W	#2,D1
	MOVE.L	A0,-(sp)
	MOVE.L	mt_LWTPtr(PC),A0
	MOVE.L	(A0,D1.W),(A6)
	MOVE.L	(sp)+,A0
	MOVE.B	2(A6),D2
	AND.L	#$F0,D2
	LSR.B	#4,D2
	MOVE.B	(A6),D0
	AND.B	#$F0,D0
	OR.B	D0,D2
	BEQ.s	mt_SetRegs
	MOVEQ	#0,D3
	LEA	mt_SampleStarts(PC),A1
	SUBQ	#1,D2
	MOVE	D2,D4
	ADD	D2,D2
	ADD	D2,D2
	LSL	#3,D4
	MOVE.L	(A1,D2.L),4(A6)
	MOVE.W	(A3,D4.W),8(A6)
	MOVE.W	(A3,D4.W),40(A6)
	MOVE.W	2(A3,D4.W),18(A6)
	MOVE.L	4(A6),D2	; Get start
	MOVE.W	4(A3,D4.W),D3	; Get repeat
	BEQ.S	mt_NoLoop
	MOVE.W	D3,D0		; Get repeat
	ADD.W	D3,D3
	ADD.L	D3,D2		; Add repeat
	ADD.W	6(A3,D4.W),D0	; Add replen
	MOVE.W	D0,8(A6)

mt_NoLoop
	MOVE.L	D2,10(A6)
	MOVE.L	D2,36(A6)
	MOVE.W	6(A3,D4.W),14(A6)	; Save replen
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		move.b	19(a6),1(A5,d1.w)
		movem.l	(sp)+,a5/d1
mt_SetRegs
	MOVE.W	(A6),D0
	AND.W	#$0FFF,D0
	BEQ.W	mt_CheckMoreEfx	; If no note

	IF mt_finetuneused=1
	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0E50,D0
	BEQ.S	mt_DoSetFineTune
	ENDif

	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#3,D0	; TonePortamento
	BEQ.S	mt_ChkTonePorta
	CMP.B	#5,D0
	BEQ.S	mt_ChkTonePorta
	CMP.B	#9,D0	; Sample Offset
	BNE.S	mt_SetPeriod
	BSR.W	mt_CheckMoreEfx
	BRA.S	mt_SetPeriod

mt_ChkTonePorta
	BSR.W	mt_SetTonePorta
	BRA.W	mt_CheckMoreEfx

mt_DoSetFineTune
	BSR.W	mt_SetFineTune

mt_SetPeriod
	MOVEM.L	D1/A1,-(SP)
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1

	IF mt_finetuneused=0
	MOVE.W	D1,16(A6)

	ELSE
mt_SetPeriod2
	LEA	mt_PeriodTable(PC),A1
	MOVEQ	#36,D7
mt_ftuloop
	CMP.W	(A1)+,D1
	BHS.S	mt_ftufound
	DBRA	D7,mt_ftuloop
mt_ftufound
	MOVEQ	#0,D1
	MOVE.B	18(A6),D1
	LSL	#3,D1
	MOVE	D1,D0
	LSL	#3,D1
	ADD	D0,D1
	MOVE.W	-2(A1,D1.W),16(A6)
	ENDif

	MOVEM.L	(SP)+,D1/A1

	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0ED0,D0 ; Notedelay
	BEQ.W	mt_CheckMoreEfx

	MOVE.W	20(A6),$DFF096
	BTST	#2,30(A6)
	BNE.S	mt_vibnoc
	CLR.B	27(A6)
mt_vibnoc
	BTST	#6,30(A6)
	BNE.S	mt_trenoc
	CLR.B	29(A6)
mt_trenoc
	MOVE.L	4(A6),(A5)	; Set start
	MOVE.W	8(A6),4(A5)	; Set length
	MOVE.W	16(A6),6(A5)	; Set period
	MOVE.W	20(A6),D0
	OR.W	D0,mt_DMACONtemp
	BRA.W	mt_CheckMoreEfx
 
mt_SetDMA
	IF mt_lev6use=1
	lea	$bfd000,a3
	move.b	#$7f,$d00(a3)
	move.w	#$2000,$dff09c
	move.w	#$a000,$dff09a
	move.l	$78.w,mt_oldirq
	move.l	#mt_irq1,$78.w
	moveq	#0,d0
	move.b	d0,$e00(a3)
	move.b	#$a8,$400(a3)
	move.b	d0,$500(a3)
	move.b	#$11,$e00(a3)
	move.b	#$81,$d00(a3)
	OR.W	#$8000,mt_DMACONtemp
	BRA.w	mt_dskip

	ELSE
	OR.W	#$8000,mt_DMACONtemp
	bsr.w	mt_WaitDMA
	ENDif

	IF mt_lev6use=1
mt_irq1:tst.b	$bfdd00
	MOVE.W	mt_dmacontemp(pc),$DFF096
	move.w	#$2000,$dff09c
	move.l	#mt_irq2,$78.w
	rte

	ELSE
	MOVE.W	mt_dmacontemp(pc),$DFF096
	bsr.w	mt_WaitDMA
	ENDif

	IF mt_lev6use=1
mt_irq2:tst.b	$bfdd00
	movem.l	a5-a6,-(a7)
	ENDif

	LEA	$DFF0A0,A5
	LEA	mt_chan1temp(PC),A6
	MOVE.L	10(A6),(A5)
	MOVE.W	14(A6),4(A5)
	MOVE.L	54(A6),$10(A5)
	MOVE.W	58(A6),$14(A5)
	MOVE.L	98(A6),$20(A5)
	MOVE.W	102(A6),$24(A5)
	MOVE.L	142(A6),$30(A5)
	MOVE.W	146(A6),$34(A5)

	IF mt_lev6use=1
	move.b	#0,$bfde00
	move.b	#$7f,$bfdd00
	move.l	mt_oldirq(pc),$78.w
	move.w	#$2000,$dff09c
	movem.l	(a7)+,a5-a6
	rte
	ENDif

mt_dskip
	lea	mt_speed(PC),A4
	ADDQ.W	#4,mt_PatternPos-mt_speed(A4)
	MOVE.B	mt_PattDelTime-mt_speed(A4),D0
	BEQ.S	mt_dskc
	MOVE.B	D0,mt_PattDelTime2-mt_speed(A4)
	CLR.B	mt_PattDelTime-mt_speed(A4)
mt_dskc	TST.B	mt_PattDelTime2-mt_speed(A4)
	BEQ.S	mt_dska
	SUBQ.B	#1,mt_PattDelTime2-mt_speed(A4)
	BEQ.S	mt_dska
	SUBQ.W	#4,mt_PatternPos-mt_speed(A4)
mt_dska	TST.B	mt_PBreakFlag-mt_speed(A4)
	BEQ.S	mt_nnpysk
	SF	mt_PBreakFlag-mt_speed(A4)
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	CLR.B	mt_PBreakPos-mt_speed(A4)
	LSL	#2,D0
	MOVE.W	D0,mt_PatternPos-mt_speed(A4)
mt_nnpysk
	CMP.W	#256,mt_PatternPos-mt_speed(A4)
	BLO.S	mt_NoNewPosYet
mt_NextPosition	
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	LSL	#2,D0
	MOVE.W	D0,mt_PatternPos-mt_speed(A4)
	CLR.B	mt_PBreakPos-mt_speed(A4)
	CLR.B	mt_PosJumpFlag-mt_speed(A4)
	ADDQ.B	#1,mt_SongPos-mt_speed(A4)
	AND.B	#$7F,mt_SongPos-mt_speed(A4)
	MOVE.B	mt_SongPos(PC),D1
	MOVE.L	mt_SongDataPtr(PC),A0
	CMP.B	248(A0),D1
	BLO.S	mt_NoNewPosYet
	CLR.B	mt_SongPos-mt_speed(A4)
mt_NoNewPosYet
	lea	mt_speed(PC),A4
	TST.B	mt_PosJumpFlag-mt_speed(A4)
	BNE.S	mt_NextPosition

	lea	mt_volumes,a1			;control volume
	lea	$dff0a0,a2
	move	mt_percent,d0
	move	#3,d7
mt_putvol:
	move	(a1)+,d1
	mulu	d0,d1
	lsr	#7,d1
	move	d1,8(a2)
	lea	$10(a2),a2
	dbf	d7,mt_putvol
	MOVEM.L	(SP)+,D0-D4/D7/A0-A6
	RTS

mt_CheckEfx
	lea	$10(a5),a5
	lea	44(a6),a6
	BSR.W	mt_UpdateFunk
	MOVE.W	2(A6),D0
	AND.W	#$0FFF,D0
	BEQ.S	mt_PerNop
	MOVE.B	2(A6),D0
	MOVEQ	#$0F,D1
	AND.L	D1,D0
	BEQ.S	mt_Arpeggio
	SUBQ	#1,D0
	BEQ.W	mt_PortaUp
	SUBQ	#1,D0
	BEQ.W	mt_PortaDown
	SUBQ	#1,D0
	BEQ.W	mt_TonePortamento
	SUBQ	#1,D0
	BEQ.W	mt_Vibrato
	SUBQ	#1,D0
	BEQ.W	mt_TonePlusVolSlide
	SUBQ	#1,D0
	BEQ.W	mt_VibratoPlusVolSlide
	SUBQ	#8,D0
	BEQ.W	mt_E_Commands
	MOVE.W	16(A6),6(A5)
	ADDQ	#7,D0
	BEQ.W	mt_Tremolo
	SUBQ	#3,D0
	BEQ.W	mt_VolumeSlide
mt_Return2
	RTS

mt_PerNop
	MOVE.W	16(A6),6(A5)
	RTS

mt_Arpeggio
	MOVEQ	#0,D0
	MOVE.B	mt_counter(PC),D0
	DIVS	#3,D0
	SWAP	D0
	TST.W	D0
	BEQ.S	mt_Arpeggio2
	SUBQ	#2,D0
	BEQ.S	mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	LSR.B	#4,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio2
	MOVE.W	16(A6),6(A5)
	RTS

mt_Arpeggio1
	MOVE.B	3(A6),D0
	AND.W	#15,D0
mt_Arpeggio3
	ADD.W	D0,D0
	LEA	mt_PeriodTable(PC),A0

	IF mt_finetuneused=1
	MOVEQ	#0,D1
	MOVE.B	18(A6),D1
	LSL	#3,D1
	MOVE	D1,D2
	LSL	#3,D1
	ADD	D2,D1
	ADD.L	D1,A0
	ENDif

	MOVE.W	16(A6),D1
	MOVEQ	#36,D7
mt_arploop
	CMP.W	(A0)+,D1
	BHS.S	mt_Arpeggio4
	DBRA	D7,mt_arploop
	RTS

mt_Arpeggio4
	MOVE.W	-2(A0,D0.W),6(A5)
	RTS

mt_FinePortaUp
	TST.B	mt_counter
	BNE.S	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaUp
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	SUB.W	D0,16(A6)
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#113,D0
	BPL.S	mt_PortaUskip
	AND.W	#$F000,16(A6)
	OR.W	#113,16(A6)
mt_PortaUskip
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS	
 
mt_FinePortaDown
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaDown
	CLR.W	D0
	MOVE.B	3(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	ADD.W	D0,16(A6)
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#856,D0
	BMI.S	mt_PortaDskip
	AND.W	#$F000,16(A6)
	OR.W	#856,16(A6)
mt_PortaDskip
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS

mt_SetTonePorta
	MOVE.L	A0,-(SP)
	MOVE.W	(A6),D2
	AND.W	#$0FFF,D2
	LEA	mt_PeriodTable(PC),A0

	IF	mt_finetuneused=1
	MOVEQ	#0,D0
	MOVE.B	18(A6),D0
	ADD	D0,D0
	MOVE	D0,D7
	ADD	D0,D0
	ADD	D0,D0
	ADD	D0,D7
	LSL	#3,D0
	ADD	D7,D0
	ADD.L	D0,A0
	ENDif

	MOVEQ	#0,D0
mt_StpLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_StpFound
	ADDQ	#2,D0
	CMP.W	#37*2,D0
	BLO.S	mt_StpLoop
	MOVEQ	#35*2,D0
mt_StpFound
	BTST	#3,18(A6)
	BEQ.S	mt_StpGoss
	TST.W	D0
	BEQ.S	mt_StpGoss
	SUBQ	#2,D0
mt_StpGoss
	MOVE.W	(A0,D0.W),D2
	MOVE.L	(SP)+,A0
	MOVE.W	D2,24(A6)
	MOVE.W	16(A6),D0
	CLR.B	22(A6)
	CMP.W	D0,D2
	BEQ.S	mt_ClearTonePorta
	BGE.W	mt_Return2
	MOVE.B	#1,22(A6)
	RTS

mt_ClearTonePorta
	CLR.W	24(A6)
	RTS

mt_TonePortamento
	MOVE.B	3(A6),D0
	BEQ.S	mt_TonePortNoChange
	MOVE.B	D0,23(A6)
	CLR.B	3(A6)
mt_TonePortNoChange
	TST.W	24(A6)
	BEQ.W	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	23(A6),D0
	TST.B	22(A6)
	BNE.S	mt_TonePortaUp
mt_TonePortaDown
	ADD.W	D0,16(A6)
	MOVE.W	24(A6),D0
	CMP.W	16(A6),D0
	BGT.S	mt_TonePortaSetPer
	MOVE.W	24(A6),16(A6)
	CLR.W	24(A6)
	BRA.S	mt_TonePortaSetPer

mt_TonePortaUp
	SUB.W	D0,16(A6)
	MOVE.W	24(A6),D0
	CMP.W	16(A6),D0
	BLT.S	mt_TonePortaSetPer
	MOVE.W	24(A6),16(A6)
	CLR.W	24(A6)

mt_TonePortaSetPer
	MOVE.W	16(A6),D2
	MOVE.B	31(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_GlissSkip
	LEA	mt_PeriodTable(PC),A0

	IF mt_finetuneused=1
	MOVEQ	#0,D0
	MOVE.B	18(A6),D0
	LSL	#3,D0
	MOVE	D0,D1
	LSL	#3,D0
	ADD	D1,D0
	ADD.L	D0,A0
	ENDif

	MOVEQ	#0,D0
mt_GlissLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_GlissFound
	ADDQ	#2,D0
	CMP.W	#36*2,D0
	BLO.S	mt_GlissLoop
	MOVEQ	#35*2,D0
mt_GlissFound
	MOVE.W	(A0,D0.W),D2
mt_GlissSkip
	MOVE.W	D2,6(A5) ; Set period
	RTS

mt_Vibrato
	MOVE.B	3(A6),D0
	BEQ.S	mt_Vibrato2
	MOVE.B	26(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_vibskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_vibskip
	MOVE.B	3(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_vibskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_vibskip2
	MOVE.B	D2,26(A6)
mt_Vibrato2
	MOVE.B	27(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVE.B	30(A6),D2
	AND.W	#$03,D2
	BEQ.S	mt_vib_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_vib_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_vib_set
mt_vib_rampdown
	TST.B	27(A6)
	BPL.S	mt_vib_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_sine
	MOVE.B	0(A4,D0.W),D2
mt_vib_set
	MOVE.B	26(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#7,D2
	MOVE.W	16(A6),D0
	TST.B	27(A6)
	BMI.S	mt_VibratoNeg
	ADD.W	D2,D0
	BRA.S	mt_Vibrato3
mt_VibratoNeg
	SUB.W	D2,D0
mt_Vibrato3
	MOVE.W	D0,6(A5)
	MOVE.B	26(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,27(A6)
	RTS

mt_TonePlusVolSlide
	BSR.W	mt_TonePortNoChange
	BRA.W	mt_VolumeSlide

mt_VibratoPlusVolSlide
	BSR.S	mt_Vibrato2
	BRA.W	mt_VolumeSlide

mt_Tremolo
	MOVE.B	3(A6),D0
	BEQ.S	mt_Tremolo2
	MOVE.B	28(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_treskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_treskip
	MOVE.B	3(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_treskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_treskip2
	MOVE.B	D2,28(A6)
mt_Tremolo2
	MOVE.B	29(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	30(A6),D2
	LSR.B	#4,D2
	AND.B	#$03,D2
	BEQ.S	mt_tre_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_tre_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_tre_set
mt_tre_rampdown
	TST.B	27(A6)
	BPL.S	mt_tre_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_sine
	MOVE.B	0(A4,D0.W),D2
mt_tre_set
	MOVE.B	28(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#6,D2
	MOVEQ	#0,D0
	MOVE.B	19(A6),D0
	TST.B	29(A6)
	BMI.S	mt_TremoloNeg
	ADD.W	D2,D0
	BRA.S	mt_Tremolo3
mt_TremoloNeg
	SUB.W	D2,D0
mt_Tremolo3
	BPL.S	mt_TremoloSkip
	CLR.W	D0
mt_TremoloSkip
	CMP.W	#$40,D0
	BLS.S	mt_TremoloOk
	MOVE.W	#$40,D0
mt_TremoloOk
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		MOVE	D0,(A5,d1.w)
		movem.l	(sp)+,a5/d1
	MOVE.B	28(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,29(A6)
	RTS

mt_SampleOffset
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	BEQ.S	mt_sononew
	MOVE.B	D0,32(A6)
mt_sononew
	MOVE.B	32(A6),D0
	LSL.W	#7,D0
	CMP.W	8(A6),D0
	BGE.S	mt_sofskip
	SUB.W	D0,8(A6)
	ADD.W	D0,D0
	ADD.L	D0,4(A6)
	RTS
mt_sofskip
	MOVE.W	#$0001,8(A6)
	RTS

mt_VolumeSlide
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	LSR.B	#4,D0
	TST.B	D0
	BEQ.S	mt_VolSlideDown
mt_VolSlideUp
	ADD.B	D0,19(A6)
	CMP.B	#$40,19(A6)
	BMI.S	mt_vsuskip
	MOVE.B	#$40,19(A6)
mt_vsuskip
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		move.b	19(a6),1(A5,d1.w)
		movem.l	(sp)+,a5/d1
	RTS

mt_VolSlideDown
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
mt_VolSlideDown2
	SUB.B	D0,19(A6)
	BPL.S	mt_vsdskip
	CLR.B	19(A6)
mt_vsdskip
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		move.b	19(a6),1(A5,d1.w)
		movem.l	(sp)+,a5/d1
	RTS

mt_PositionJump
	MOVE.B	3(A6),D0
	SUBQ	#1,D0
	MOVE.B	D0,mt_SongPos
mt_pj2	CLR.B	mt_PBreakPos
	ST 	mt_PosJumpFlag
	RTS

mt_VolumeChange
	MOVE.B	3(A6),D0
	CMP.B	#$40,D0
	BLS.S	mt_VolumeOk
	MOVEQ	#$40,D0
mt_VolumeOk
	MOVE.B	D0,19(A6)
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		MOVE.b	D0,1(A5,d1.w)
		movem.l	(sp)+,a5/d1
	RTS

mt_PatternBreak
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	MOVE.W	D0,D2
	LSR.B	#4,D0
	ADD	D0,D0
	MOVE	D0,D1
	ADD	D0,D0
	ADD	D0,D0
	ADD	D1,D0
	AND.B	#$0F,D2
	ADD.B	D2,D0
	CMP.B	#63,D0
	BHI.S	mt_pj2
	MOVE.B	D0,mt_PBreakPos
	ST	mt_PosJumpFlag
	RTS

mt_SetSpeed
	MOVE.B	3(A6),D0
	BEQ.W	mt_Return2
	CLR.B	mt_counter
	MOVE.B	D0,mt_speed
	RTS

mt_CheckMoreEfx
	BSR.W	mt_UpdateFunk
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	SUB.B	#9,D0
	BEQ.W	mt_SampleOffset
	SUBQ	#2,D0
	BEQ.W	mt_PositionJump
	SUBQ	#1,D0
	BEQ.w	mt_VolumeChange
	SUBQ	#1,D0
	BEQ.S	mt_PatternBreak
	SUBQ	#1,D0
	BEQ.S	mt_E_Commands
	SUBQ	#1,D0
	BEQ.S	mt_SetSpeed
	BRA.W	mt_PerNop

mt_E_Commands
	MOVE.B	3(A6),D0
	AND.W	#$F0,D0
	LSR.B	#4,D0
	BEQ.S	mt_FilterOnOff
	SUBQ	#1,D0
	BEQ.W	mt_FinePortaUp
	SUBQ	#1,D0
	BEQ.W	mt_FinePortaDown
	SUBQ	#1,D0
	BEQ.S	mt_SetGlissControl
	SUBQ	#1,D0
	BEQ.s	mt_SetVibratoControl

	IF mt_finetuneused=1
	SUBQ	#1,D0
	BEQ.s	mt_SetFineTune
	SUBQ	#1,D0

	ELSE
	SUBQ	#2,D0
	ENDif

	BEQ.s	mt_JumpLoop
	SUBQ	#1,D0
	BEQ.W	mt_SetTremoloControl
	SUBQ	#2,D0
	BEQ.W	mt_RetrigNote
	SUBQ	#1,D0
	BEQ.W	mt_VolumeFineUp
	SUBQ	#1,D0
	BEQ.W	mt_VolumeFineDown
	SUBQ	#1,D0
	BEQ.W	mt_NoteCut
	SUBQ	#1,D0
	BEQ.W	mt_NoteDelay
	SUBQ	#1,D0
	BEQ.W	mt_PatternDelay
	BRA.W	mt_FunkIt

mt_FilterOnOff
	MOVE.B	3(A6),D0
	AND.B	#1,D0
	ADD.B	D0,D0
	AND.B	#$FD,$BFE001
	OR.B	D0,$BFE001
	RTS	

mt_SetGlissControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,31(A6)
	OR.B	D0,31(A6)
	RTS

mt_SetVibratoControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,30(A6)
	OR.B	D0,30(A6)
	RTS

mt_SetFineTune
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	MOVE.B	D0,18(A6)
	RTS

mt_JumpLoop
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_SetLoop
	TST.B	34(A6)
	BEQ.S	mt_jumpcnt
	SUBQ.B	#1,34(A6)
	BEQ.W	mt_Return2
mt_jmploop 	MOVE.B	33(A6),mt_PBreakPos
	ST	mt_PBreakFlag
	RTS

mt_jumpcnt
	MOVE.B	D0,34(A6)
	BRA.S	mt_jmploop

mt_SetLoop
	MOVE.W	mt_PatternPos(PC),D0
	LSR	#2,D0
	MOVE.B	D0,33(A6)
	RTS

mt_SetTremoloControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,30(A6)
	OR.B	D0,30(A6)
	RTS

mt_RetrigNote
	MOVE.L	D1,-(SP)
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	BEQ.S	mt_rtnend
	MOVEQ	#0,d1
	MOVE.B	mt_counter(PC),D1
	BNE.S	mt_rtnskp
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	BNE.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
mt_rtnskp
	DIVU	D0,D1
	SWAP	D1
	TST.W	D1
	BNE.S	mt_rtnend
mt_DoRetrig
	MOVE.W	20(A6),$DFF096	; Channel DMA off
	MOVE.L	4(A6),(A5)	; Set sampledata pointer
	MOVE.W	8(A6),4(A5)	; Set length
	BSR.W	mt_WaitDMA
	MOVE.W	20(A6),D0
	BSET	#15,D0
	MOVE.W	D0,$DFF096
	BSR.W	mt_WaitDMA
	MOVE.L	10(A6),(A5)
	MOVE.L	14(A6),4(A5)
mt_rtnend
	MOVE.L	(SP)+,D1
	RTS

mt_VolumeFineUp
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$F,D0
	BRA.W	mt_VolSlideUp

mt_VolumeFineDown
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	BRA.W	mt_VolSlideDown2

mt_NoteCut
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	CMP.B	mt_counter(PC),D0
	BNE.W	mt_Return2
	CLR.B	19(A6)
		movem.l	a5/d1,-(sp)
		move	a5,d1
		andi	#$f0,d1
		lsr	#4,d1
		subi	#10,d1
		lsl	#1,d1
		lea	mt_volumes,a5
		clr	(A5,d1.w)
		movem.l	(sp)+,a5/d1
	RTS

mt_NoteDelay
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	CMP.B	mt_Counter(PC),D0
	BNE.W	mt_Return2
	MOVE.W	(A6),D0
	BEQ.W	mt_Return2
	MOVE.L	D1,-(SP)
	BRA.W	mt_DoRetrig

mt_PatternDelay
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	TST.B	mt_PattDelTime2
	BNE.W	mt_Return2
	ADDQ.B	#1,D0
	MOVE.B	D0,mt_PattDelTime
	RTS

mt_FunkIt
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,31(A6)
	OR.B	D0,31(A6)
	TST.B	D0
	BEQ.W	mt_Return2
mt_UpdateFunk
	MOVEM.L	D1/A0,-(SP)
	MOVEQ	#0,D0
	MOVE.B	31(A6),D0
	LSR.B	#4,D0
	BEQ.S	mt_funkend
	LEA	mt_FunkTable(PC),A0
	MOVE.B	(A0,D0.W),D0
	ADD.B	D0,35(A6)
	BTST	#7,35(A6)
	BEQ.S	mt_funkend
	CLR.B	35(A6)

	MOVE.L	10(A6),D0
	MOVEQ	#0,D1
	MOVE.W	14(A6),D1
	ADD.L	D1,D0
	ADD.L	D1,D0
	MOVE.L	36(A6),A0
	ADDQ.L	#1,A0
	CMP.L	D0,A0
	BLO.S	mt_funkok
	MOVE.L	10(A6),A0
mt_funkok
	MOVE.L	A0,36(A6)
	NEG.B	(A0)
	SUBQ.B	#1,(A0)
mt_funkend
	MOVEM.L	(SP)+,D1/A0
	RTS

mt_WaitDMA
	MOVEQ	#3,D0
mt_WaitDMA2
	MOVE.B	$DFF006,D1
mt_WaitDMA3
	CMP.B	$DFF006,D1
	BEQ.S	mt_WaitDMA3
	DBF	D0,mt_WaitDMA2
	RTS

mt_FunkTable dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

mt_VibratoTable	
	dc.b   0, 24, 49, 74, 97,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120, 97, 74, 49, 24

mt_PeriodTable
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

mt_chan1temp	blk.l	5
		dc.w	1
		blk.w	21
		dc.w	2
		blk.w	21
		dc.w	4
		blk.w	21
		dc.w	8
		blk.w	11

mt_SampleStarts	blk.l	31,0

mt_SongDataPtr	dc.l 0
mt_LWTPtr	dc.l 0
mt_oldirq	dc.l 0

mt_speed	dc.b 6
mt_counter	dc.b 0
mt_SongPos	dc.b 0
mt_PBreakPos	dc.b 0
mt_PosJumpFlag	dc.b 0
mt_PBreakFlag	dc.b 0
mt_LowMask	dc.b 0
mt_PattDelTime	dc.b 0
mt_PattDelTime2	dc.b 0,0
mt_PatternPos	dc.w 0
mt_DMACONtemp	dc.w 0
mt_volumes:	dc.w 0,0,0,0
mt_percent:	dc.w 128

	; forward = (0,1,0)
objects:
	;incdir sources:
	addobject 0,0,0,256,256,256
	dc.w 1,1,$fff
	dc.w 4
	dc.l -220,-50,220,-220,50,220,0,50,220,0,-50,220
;	dc.l -220,-50,-220,-220,50,-220,0,50,-220,0,-50,-220
;	dc.l 220,50,220,220,-50,220,220,50,-220,220,-50,-220
;	dc.l 220,50,0,220,-50,0
	dc.w 1
	dc.w 4,0,1
	dc.w 0,$0,$0,6,$7f00,$0,12,$7f00,$7f00,18,$0,$7f00
;	dc.w 4,0,1
;	dc.w 42,$0,$0,36,$7f00,$0,30,$7f00,$7f00,24,$0,$7f00
;	dc.w 4,0,1
;	dc.w 18,$0,$0,12,$7f00,$0,48,$7f00,$7f00,54,$0,$7f00
;	dc.w 4,0,1
;	dc.w 66,$0,$0,60,$7f00,$0,36,$7f00,$7f00,42,$0,$7f00
;	dc.w 4,0,1
;	dc.w 12*6,$0,$0,13*6,$7f00,$0,54,$7f00,$7f00,48,$0,$7f00
;	dc.w 4,0,1
;	dc.w 13*6,$0,$0,12*6,$7f00,$0,60,$7f00,$7f00,66,$0,$7f00
	addobject 0,0,0,1024,1024,960,sphere48.obj
	addobject 90,0,90,256,256,256,startrek.obj
	addobject 0,0,0,256,256,256
	dc.w 1,0,$fff,4
	dc.l 80,80,0,80,-80,0,-80,-80,0,-80,80,0
	dc.w 1
	dc.w 4,0,0
	dc.w 0,0,0,6,0,$7f00,12,$7f00,$7f00,18,$7f00,0
;	dc.w 4,0,8
;	dc.w 18,0,0,12,0,$7f00,6,$7f00,$7f00,0,$7f00,0
	addobject 0,180,0,256,256,256
	dc.w 3,1,$a84,1,$f00,1,$888,22*5
	dc.l -35,-40,-55,-38,10,-60,-35,30,-55,-32,40,-55,-30,50,-50,-20,50,-50
	dc.l 8,50,-50,17,45,-50,18,30,-55,19,25,-55,20,20,-60,20,0,-60,16,-10,-60
	dc.l 17,-20,-60,15,-22,-57,15,-24,-55,15,-26,-55,14,-28,-55,12,-35,-55
	dc.l 10,-38,-53,0,-50,-50,-33,-40,-55
	dc.l -65,-50,-30,-68,10,-30,-65,40,-30,-60,60,-30,-40,70,-30,-20,80,-30
	dc.l 20,80,-30,35,70,-30,44,40,-30,37,30,-30,32,20,-30,35,0,-30,38,-10,-30
	dc.l 42,-20,-30,45,-36,-30,42,-38,-30,44,-40,-30,38,-55,-30,41,-65,-30
	dc.l 35,-72,-30,0,-70,-30,-33,-50,-30
	dc.l -75,-55,0,-78,10,0,-75,40,0,-70,60,0,-50,80,0,-20,90,0
	dc.l 20,90,0,38,80,0,47,50,0,45,30,0,50,20,0,63,0,0,67,-10,0
	dc.l 50,-20,0,52,-32,0,46,-38,0,51,-45,0,43,-60,0,47,-76,0
	dc.l 38,-82,0,0,-75,0,-33,-55,0
	;0-5
	dc.l -65,-50,30,-68,10,30,-65,40,30,-60,60,30,-40,70,30,-20,80,30
	;6-12
	dc.l 20,80,30,35,70,30,44,40,30,37,30,30,32,20,30,35,0,30,38,-10,30
	;13-18
	dc.l 42,-20,30,45,-36,30,42,-38,30,44,-40,30,38,-55,30,41,-65,30
	;19-21
	dc.l 35,-72,30,0,-70,30,-33,-50,30
	dc.l -35,-40,55,-38,10,60,-35,30,55,-32,40,55,-30,50,50,-20,50,50
	dc.l 8,50,50,17,45,50,18,30,55,19,25,55,20,20,60,20,0,60,16,-10,60
	dc.l 17,-20,60,15,-22,57,15,-24,55,15,-26,55,14,-28,55,12,-35,55
	dc.l 10,-38,53,0,-50,50,-33,-40,55
	dc.w 98
	dc.w 4,2,0,1*6,0,0,0*6,0,0,22*6,0,0,23*6,0,0
	dc.w 4,2,0,23*6,0,0,22*6,0,0,44*6,0,0,45*6,0,0
	dc.w 4,2,0,45*6,0,0,44*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,2,0,67*6,0,0,66*6,0,0,88*6,0,0,89*6,0,0
	dc.w 4,2,0,2*6,0,0,1*6,0,0,23*6,0,0,24*6,0,0
	dc.w 4,2,0,24*6,0,0,23*6,0,0,45*6,0,0,46*6,0,0
	dc.w 4,2,0,46*6,0,0,45*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,2,0,68*6,0,0,67*6,0,0,89*6,0,0,90*6,0,0
	dc.w 4,2,0,3*6,0,0,2*6,0,0,24*6,0,0,25*6,0,0
	dc.w 4,2,0,25*6,0,0,24*6,0,0,46*6,0,0,47*6,0,0
	dc.w 4,2,0,47*6,0,0,46*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,2,0,69*6,0,0,68*6,0,0,90*6,0,0,91*6,0,0
	dc.w 4,2,0,4*6,0,0,3*6,0,0,25*6,0,0,26*6,0,0
	dc.w 4,2,0,26*6,0,0,25*6,0,0,47*6,0,0,48*6,0,0
	dc.w 4,2,0,48*6,0,0,47*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,2,0,70*6,0,0,69*6,0,0,91*6,0,0,92*6,0,0
	dc.w 4,2,0,5*6,0,0,4*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,2,0,27*6,0,0,26*6,0,0,48*6,0,0,49*6,0,0
	dc.w 4,2,0,49*6,0,0,48*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,2,0,71*6,0,0,70*6,0,0,92*6,0,0,93*6,0,0
	dc.w 4,2,0,6*6,0,0,5*6,0,0,27*6,0,0,28*6,0,0
	dc.w 4,2,0,28*6,0,0,27*6,0,0,49*6,0,0,50*6,0,0
	dc.w 4,2,0,50*6,0,0,49*6,0,0,71*6,0,0,72*6,0,0
	dc.w 4,2,0,72*6,0,0,71*6,0,0,93*6,0,0,94*6,0,0
	dc.w 4,2,0,7*6,0,0,6*6,0,0,28*6,0,0,29*6,0,0
	dc.w 4,2,0,29*6,0,0,28*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,2,0,51*6,0,0,50*6,0,0,72*6,0,0,73*6,0,0
	dc.w 4,2,0,73*6,0,0,72*6,0,0,94*6,0,0,95*6,0,0
	dc.w 4,2,0,8*6,0,0,7*6,0,0,29*6,0,0,30*6,0,0
	dc.w 4,2,0,30*6,0,0,29*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,2,0,52*6,0,0,51*6,0,0,73*6,0,0,74*6,0,0
	dc.w 4,2,0,74*6,0,0,73*6,0,0,95*6,0,0,96*6,0,0
	dc.w 4,0,0,9*6,0,0,8*6,0,0,30*6,0,0,31*6,0,0
	dc.w 4,0,0,31*6,0,0,30*6,0,0,52*6,0,0,53*6,0,0
	dc.w 4,0,0,53*6,0,0,52*6,0,0,74*6,0,0,75*6,0,0
	dc.w 4,0,0,75*6,0,0,74*6,0,0,96*6,0,0,97*6,0,0
	dc.w 4,0,0,10*6,0,0,9*6,0,0,31*6,0,0,32*6,0,0
	dc.w 4,0,0,32*6,0,0,31*6,0,0,53*6,0,0,54*6,0,0
	dc.w 4,0,0,54*6,0,0,53*6,0,0,75*6,0,0,76*6,0,0
	dc.w 4,0,0,76*6,0,0,75*6,0,0,97*6,0,0,98*6,0,0
	dc.w 4,0,0,11*6,0,0,10*6,0,0,32*6,0,0,33*6,0,0
	dc.w 4,0,0,33*6,0,0,32*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,0,0,55*6,0,0,54*6,0,0,76*6,0,0,77*6,0,0
	dc.w 4,0,0,77*6,0,0,76*6,0,0,98*6,0,0,99*6,0,0
	dc.w 4,0,0,12*6,0,0,11*6,0,0,33*6,0,0,34*6,0,0
	dc.w 4,0,0,34*6,0,0,33*6,0,0,55*6,0,0,56*6,0,0
	dc.w 4,0,0,56*6,0,0,55*6,0,0,77*6,0,0,78*6,0,0
	dc.w 4,0,0,78*6,0,0,77*6,0,0,99*6,0,0,100*6,0,0
	dc.w 4,0,0,13*6,0,0,12*6,0,0,34*6,0,0,35*6,0,0
	dc.w 4,0,0,35*6,0,0,34*6,0,0,56*6,0,0,57*6,0,0
	dc.w 4,0,0,57*6,0,0,56*6,0,0,78*6,0,0,79*6,0,0
	dc.w 4,0,0,79*6,0,0,78*6,0,0,100*6,0,0,101*6,0,0
	dc.w 4,0,0,14*6,0,0,13*6,0,0,35*6,0,0,36*6,0,0
	dc.w 4,0,0,36*6,0,0,35*6,0,0,57*6,0,0,58*6,0,0
	dc.w 4,0,0,58*6,0,0,57*6,0,0,79*6,0,0,80*6,0,0
	dc.w 4,0,0,80*6,0,0,79*6,0,0,101*6,0,0,102*6,0,0
	dc.w 4,0,0,15*6,0,0,14*6,0,0,36*6,0,0,37*6,0,0
	dc.w 4,1,0,37*6,0,0,36*6,0,0,58*6,0,0,59*6,0,0
	dc.w 4,1,0,59*6,0,0,58*6,0,0,80*6,0,0,81*6,0,0
	dc.w 4,0,0,81*6,0,0,80*6,0,0,102*6,0,0,103*6,0,0
	dc.w 4,0,0,16*6,0,0,15*6,0,0,37*6,0,0,38*6,0,0
	dc.w 4,1,0,38*6,0,0,37*6,0,0,59*6,0,0,60*6,0,0
	dc.w 4,1,0,60*6,0,0,59*6,0,0,81*6,0,0,82*6,0,0
	dc.w 4,0,0,82*6,0,0,81*6,0,0,103*6,0,0,104*6,0,0
	dc.w 4,0,0,17*6,0,0,16*6,0,0,38*6,0,0,39*6,0,0
	dc.w 4,0,0,39*6,0,0,38*6,0,0,60*6,0,0,61*6,0,0
	dc.w 4,0,0,61*6,0,0,60*6,0,0,82*6,0,0,83*6,0,0
	dc.w 4,0,0,83*6,0,0,82*6,0,0,104*6,0,0,105*6,0,0
	dc.w 4,0,0,18*6,0,0,17*6,0,0,39*6,0,0,40*6,0,0
	dc.w 4,0,0,40*6,0,0,39*6,0,0,61*6,0,0,62*6,0,0
	dc.w 4,0,0,62*6,0,0,61*6,0,0,83*6,0,0,84*6,0,0
	dc.w 4,0,0,84*6,0,0,83*6,0,0,105*6,0,0,106*6,0,0
	dc.w 4,0,0,19*6,0,0,18*6,0,0,40*6,0,0,41*6,0,0
	dc.w 4,0,0,41*6,0,0,40*6,0,0,62*6,0,0,63*6,0,0
	dc.w 4,0,0,63*6,0,0,62*6,0,0,84*6,0,0,85*6,0,0
	dc.w 4,0,0,85*6,0,0,84*6,0,0,106*6,0,0,107*6,0,0
	dc.w 4,0,0,20*6,0,0,19*6,0,0,41*6,0,0,42*6,0,0
	dc.w 4,0,0,42*6,0,0,41*6,0,0,63*6,0,0,64*6,0,0
	dc.w 4,0,0,64*6,0,0,63*6,0,0,85*6,0,0,86*6,0,0
	dc.w 4,0,0,86*6,0,0,85*6,0,0,107*6,0,0,108*6,0,0
	dc.w 4,0,0,21*6,0,0,20*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,0,0,43*6,0,0,42*6,0,0,64*6,0,0,65*6,0,0
	dc.w 4,0,0,65*6,0,0,64*6,0,0,86*6,0,0,87*6,0,0
	dc.w 4,0,0,87*6,0,0,86*6,0,0,108*6,0,0,109*6,0,0
	dc.w 4,2,0,0*6,0,0,21*6,0,0,43*6,0,0,22*6,0,0
	dc.w 4,2,0,22*6,0,0,43*6,0,0,65*6,0,0,44*6,0,0
	dc.w 4,2,0,44*6,0,0,65*6,0,0,87*6,0,0,66*6,0,0
	dc.w 4,2,0,66*6,0,0,87*6,0,0,109*6,0,0,88*6,0,0
	dc.w 6,2,0,3*6,0,0,4*6,0,0,5*6,0,0,6*6,0,0,7*6,0,0,8*6,0,0
	dc.w 4,2,0,2*6,0,0,3*6,0,0,8*6,0,0,9*6,0,0
	dc.w 5,2,0,1*6,0,0,2*6,0,0,9*6,0,0,10*6,0,0,11*6,0,0
	dc.w 4,2,0,0*6,0,0,1*6,0,0,11*6,0,0,21*6,0,0
	dc.w 11,0,0,21*6,0,0,11*6,0,0,12*6,0,0,13*6,0,0,14*6,0,0,15*6,0,0
	dc.w 16*6,0,0,17*6,0,0,18*6,0,0,19*6,0,0,20*6,0,0
	dc.w 6,2,0,96*6,0,0,95*6,0,0,94*6,0,0,93*6,0,0,92*6,0,0,91*6,0,0
	dc.w 4,2,0,97*6,0,0,96*6,0,0,91*6,0,0,90*6,0,0
	dc.w 5,2,0,97*6,0,0,90*6,0,0,89*6,0,0,99*6,0,0,98*6,0,0
	dc.w 4,2,0,109*6,0,0,99*6,0,0,89*6,0,0,88*6,0,0
	dc.w 11,0,0,109*6,0,0,108*6,0,0,107*6,0,0,106*6,0,0,105*6,0,0
	dc.w 104*6,0,0,103*6,0,0,102*6,0,0,101*6,0,0,100*6,0,0,99*6,0,0
	addobject 0,180,0,256,256,256
	dc.w 2,1,$05f,1,$fcc,22*5
	dc.l -43,-43,-50,-50,-33,-50,-57,-17,-50,-60,0,-50,-56,18,-50,-50,33,-50
	dc.l -33,50,-50,-17,57,-50,0,60,-50,16,58,-50,33,50,-50,43,43,-50,52,31,-50
	dc.l 57,16,-50,60,0,-50,57,-18,-50,50,-33,-50,33,-50,-50,18,-57,-50,0,-60,-50
	dc.l -16,-58,-50,-30,-54,-50
	dc.l -43,-43,-30,-50,-33,-30,-57,-17,-30,-60,0,-30,-56,18,-30,-50,33,-30
	dc.l -33,50,-30,-17,57,-30,0,60,-30,16,58,-30,33,50,-30,43,43,-30,52,31,-30
	dc.l 57,16,-30,60,0,-30,57,-18,-30,50,-33,-30,33,-50,-30,18,-57,-30,0,-60,-30
	dc.l -16,-58,-30,-30,-54,-30
	dc.l -43,-43,0,-50,-33,0,-57,-17,0,-60,0,0,-56,18,0,-50,33,0
	dc.l -33,50,0,-17,57,0,0,60,0,16,58,0,33,50,0,43,43,0,52,31,0
	dc.l 57,16,0,60,0,0,57,-18,0,50,-33,0,33,-50,0,18,-57,0,0,-60,0
	dc.l -16,-58,0,-30,-54,0
	dc.l -43,-43,30,-50,-33,30,-57,-17,30,-60,0,30,-56,18,30,-50,33,30
	dc.l -33,50,30,-17,57,30,0,60,30,16,58,30,33,50,30,43,43,30,52,31,30
	dc.l 57,16,30,60,0,30,57,-18,30,50,-33,30,33,-50,30,18,-57,30,0,-60,30
	dc.l -16,-58,30,-30,-54,30
	dc.l -43,-43,50,-50,-33,50,-57,-17,50,-60,0,50,-56,18,50,-50,33,50
	dc.l -33,50,50,-17,57,50,0,60,50,16,58,50,33,50,50,43,43,50,52,31,50
	dc.l 57,16,50,60,0,50,57,-18,50,50,-33,50,33,-50,50,18,-57,50,0,-60,50
	dc.l -16,-58,50,-30,-54,50
	dc.w 98
	dc.w 4,1,0,1*6,0,0,0*6,0,0,22*6,0,0,23*6,0,0
	dc.w 4,1,0,23*6,0,0,22*6,0,0,44*6,0,0,45*6,0,0
	dc.w 4,1,0,45*6,0,0,44*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,1,0,67*6,0,0,66*6,0,0,88*6,0,0,89*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,23*6,0,0,24*6,0,0
	dc.w 4,0,0,24*6,0,0,23*6,0,0,45*6,0,0,46*6,0,0
	dc.w 4,0,0,46*6,0,0,45*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,1,0,68*6,0,0,67*6,0,0,89*6,0,0,90*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,24*6,0,0,25*6,0,0
	dc.w 4,0,0,25*6,0,0,24*6,0,0,46*6,0,0,47*6,0,0
	dc.w 4,0,0,47*6,0,0,46*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,1,0,69*6,0,0,68*6,0,0,90*6,0,0,91*6,0,0
	dc.w 4,1,0,4*6,0,0,3*6,0,0,25*6,0,0,26*6,0,0
	dc.w 4,1,0,26*6,0,0,25*6,0,0,47*6,0,0,48*6,0,0
	dc.w 4,1,0,48*6,0,0,47*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,1,0,70*6,0,0,69*6,0,0,91*6,0,0,92*6,0,0
	dc.w 4,0,0,5*6,0,0,4*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,0,0,27*6,0,0,26*6,0,0,48*6,0,0,49*6,0,0
	dc.w 4,0,0,49*6,0,0,48*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,0,0,71*6,0,0,70*6,0,0,92*6,0,0,93*6,0,0
	dc.w 4,1,0,6*6,0,0,5*6,0,0,27*6,0,0,28*6,0,0
	dc.w 4,1,0,28*6,0,0,27*6,0,0,49*6,0,0,50*6,0,0
	dc.w 4,1,0,50*6,0,0,49*6,0,0,71*6,0,0,72*6,0,0
	dc.w 4,1,0,72*6,0,0,71*6,0,0,93*6,0,0,94*6,0,0
	dc.w 4,0,0,7*6,0,0,6*6,0,0,28*6,0,0,29*6,0,0
	dc.w 4,1,0,29*6,0,0,28*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,0,0,51*6,0,0,50*6,0,0,72*6,0,0,73*6,0,0
	dc.w 4,0,0,73*6,0,0,72*6,0,0,94*6,0,0,95*6,0,0
	dc.w 4,0,0,8*6,0,0,7*6,0,0,29*6,0,0,30*6,0,0
	dc.w 4,0,0,30*6,0,0,29*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,1,0,52*6,0,0,51*6,0,0,73*6,0,0,74*6,0,0
	dc.w 4,0,0,74*6,0,0,73*6,0,0,95*6,0,0,96*6,0,0
	dc.w 4,1,0,9*6,0,0,8*6,0,0,30*6,0,0,31*6,0,0
	dc.w 4,1,0,31*6,0,0,30*6,0,0,52*6,0,0,53*6,0,0
	dc.w 4,1,0,53*6,0,0,52*6,0,0,74*6,0,0,75*6,0,0
	dc.w 4,1,0,75*6,0,0,74*6,0,0,96*6,0,0,97*6,0,0
	dc.w 4,0,0,10*6,0,0,9*6,0,0,31*6,0,0,32*6,0,0
	dc.w 4,0,0,32*6,0,0,31*6,0,0,53*6,0,0,54*6,0,0
	dc.w 4,0,0,54*6,0,0,53*6,0,0,75*6,0,0,76*6,0,0
	dc.w 4,0,0,76*6,0,0,75*6,0,0,97*6,0,0,98*6,0,0
	dc.w 4,1,0,11*6,0,0,10*6,0,0,32*6,0,0,33*6,0,0
	dc.w 4,1,0,33*6,0,0,32*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,1,0,55*6,0,0,54*6,0,0,76*6,0,0,77*6,0,0
	dc.w 4,1,0,77*6,0,0,76*6,0,0,98*6,0,0,99*6,0,0
	dc.w 4,0,0,12*6,0,0,11*6,0,0,33*6,0,0,34*6,0,0
	dc.w 4,0,0,34*6,0,0,33*6,0,0,55*6,0,0,56*6,0,0
	dc.w 4,0,0,56*6,0,0,55*6,0,0,77*6,0,0,78*6,0,0
	dc.w 4,0,0,78*6,0,0,77*6,0,0,99*6,0,0,100*6,0,0
	dc.w 4,1,0,13*6,0,0,12*6,0,0,34*6,0,0,35*6,0,0
	dc.w 4,1,0,35*6,0,0,34*6,0,0,56*6,0,0,57*6,0,0
	dc.w 4,1,0,57*6,0,0,56*6,0,0,78*6,0,0,79*6,0,0
	dc.w 4,1,0,79*6,0,0,78*6,0,0,100*6,0,0,101*6,0,0
	dc.w 4,1,0,14*6,0,0,13*6,0,0,35*6,0,0,36*6,0,0
	dc.w 4,0,0,36*6,0,0,35*6,0,0,57*6,0,0,58*6,0,0
	dc.w 4,0,0,58*6,0,0,57*6,0,0,79*6,0,0,80*6,0,0
	dc.w 4,1,0,80*6,0,0,79*6,0,0,101*6,0,0,102*6,0,0
	dc.w 4,1,0,15*6,0,0,14*6,0,0,36*6,0,0,37*6,0,0
	dc.w 4,0,0,37*6,0,0,36*6,0,0,58*6,0,0,59*6,0,0
	dc.w 4,0,0,59*6,0,0,58*6,0,0,80*6,0,0,81*6,0,0
	dc.w 4,1,0,81*6,0,0,80*6,0,0,102*6,0,0,103*6,0,0
	dc.w 4,1,0,16*6,0,0,15*6,0,0,37*6,0,0,38*6,0,0
	dc.w 4,1,0,38*6,0,0,37*6,0,0,59*6,0,0,60*6,0,0
	dc.w 4,1,0,60*6,0,0,59*6,0,0,81*6,0,0,82*6,0,0
	dc.w 4,1,0,82*6,0,0,81*6,0,0,103*6,0,0,104*6,0,0
	dc.w 4,0,0,17*6,0,0,16*6,0,0,38*6,0,0,39*6,0,0
	dc.w 4,0,0,39*6,0,0,38*6,0,0,60*6,0,0,61*6,0,0
	dc.w 4,0,0,61*6,0,0,60*6,0,0,82*6,0,0,83*6,0,0
	dc.w 4,0,0,83*6,0,0,82*6,0,0,104*6,0,0,105*6,0,0
	dc.w 4,1,0,18*6,0,0,17*6,0,0,39*6,0,0,40*6,0,0
	dc.w 4,1,0,40*6,0,0,39*6,0,0,61*6,0,0,62*6,0,0
	dc.w 4,1,0,62*6,0,0,61*6,0,0,83*6,0,0,84*6,0,0
	dc.w 4,1,0,84*6,0,0,83*6,0,0,105*6,0,0,106*6,0,0
	dc.w 4,0,0,19*6,0,0,18*6,0,0,40*6,0,0,41*6,0,0
	dc.w 4,1,0,41*6,0,0,40*6,0,0,62*6,0,0,63*6,0,0
	dc.w 4,0,0,63*6,0,0,62*6,0,0,84*6,0,0,85*6,0,0
	dc.w 4,0,0,85*6,0,0,84*6,0,0,106*6,0,0,107*6,0,0
	dc.w 4,0,0,20*6,0,0,19*6,0,0,41*6,0,0,42*6,0,0
	dc.w 4,0,0,42*6,0,0,41*6,0,0,63*6,0,0,64*6,0,0
	dc.w 4,1,0,64*6,0,0,63*6,0,0,85*6,0,0,86*6,0,0
	dc.w 4,0,0,86*6,0,0,85*6,0,0,107*6,0,0,108*6,0,0
	dc.w 4,1,0,21*6,0,0,20*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,1,0,43*6,0,0,42*6,0,0,64*6,0,0,65*6,0,0
	dc.w 4,1,0,65*6,0,0,64*6,0,0,86*6,0,0,87*6,0,0
	dc.w 4,1,0,87*6,0,0,86*6,0,0,108*6,0,0,109*6,0,0
	dc.w 4,0,0,0*6,0,0,21*6,0,0,43*6,0,0,22*6,0,0
	dc.w 4,0,0,22*6,0,0,43*6,0,0,65*6,0,0,44*6,0,0
	dc.w 4,0,0,44*6,0,0,65*6,0,0,87*6,0,0,66*6,0,0
	dc.w 4,0,0,66*6,0,0,87*6,0,0,109*6,0,0,88*6,0,0
	dc.w 6,0,0,3*6,0,0,4*6,0,0,5*6,0,0,6*6,0,0,7*6,0,0,8*6,0,0
	dc.w 4,0,0,2*6,0,0,3*6,0,0,8*6,0,0,9*6,0,0
	dc.w 5,0,0,1*6,0,0,2*6,0,0,9*6,0,0,10*6,0,0,11*6,0,0
	dc.w 4,0,0,0*6,0,0,1*6,0,0,11*6,0,0,21*6,0,0
	dc.w 11,0,0,21*6,0,0,11*6,0,0,12*6,0,0,13*6,0,0,14*6,0,0,15*6,0,0
	dc.w 16*6,0,0,17*6,0,0,18*6,0,0,19*6,0,0,20*6,0,0
	dc.w 6,0,0,96*6,0,0,95*6,0,0,94*6,0,0,93*6,0,0,92*6,0,0,91*6,0,0
	dc.w 4,0,0,97*6,0,0,96*6,0,0,91*6,0,0,90*6,0,0
	dc.w 5,0,0,97*6,0,0,90*6,0,0,89*6,0,0,99*6,0,0,98*6,0,0
	dc.w 4,0,0,109*6,0,0,99*6,0,0,89*6,0,0,88*6,0,0
	dc.w 11,0,0,109*6,0,0,108*6,0,0,107*6,0,0,106*6,0,0,105*6,0,0
	dc.w 104*6,0,0,103*6,0,0,102*6,0,0,101*6,0,0,100*6,0,0,99*6,0,0
	addobject 0,0,0,256,256,256,heart.obj
	addobject 0,0,0,192,192,192,cube.obj
	addobject 0,0,0,128,128,128,tcube.obj
	addobject 0,0,0,256,256,128,impship.obj
	addobject 0,0,0,256,256,256,meteor.obj
	addobject 0,0,0,1024,1024,1024
	dc.w 5,1,$fff,1,$ff0,1,$f0f,1,$0ff,1,$0f0,36*2
	dc.l -45,-10,9,-40,-10,9,-40,5,9,-30,5,9,-30,10,9,-45,10,9
	dc.l -20,-10,9,-10,-10,9,-5,-5,9,-5,5,9,-10,10,9,-20,10,9,-25,5,9
	dc.l -25,-5,9,-15,-5,9,-10,0,9,-15,5,9,-20,0,9
	dc.l 0,-10,9,5,-10,9,10,0,9,15,-10,9,20,-10,9,10,10,9
	dc.l 25,-10,9,40,-10,9,40,-5,9,30,-5,9,30,-2,9,37,-2,9,37,2,9
	dc.l 30,2,9,30,5,9,40,5,9,40,10,9,25,10,9
	dc.l -45,-10,-9,-40,-10,-9,-40,5,-9,-30,5,-9,-30,10,-9,-45,10,-9
	dc.l -20,-10,-9,-10,-10,-9,-5,-5,-9,-5,5,-9,-10,10,-9,-20,10,-9,-25,5,-9
	dc.l -25,-5,-9,-15,-5,-9,-10,0,-9,-15,5,-9,-20,0,-9
	dc.l 0,-10,-9,5,-10,-9,10,0,-9,15,-10,-9,20,-10,-9,10,10,-9
	dc.l 25,-10,-9,40,-10,-9,40,-5,-9,30,-5,-9,30,-2,-9,37,-2,-9,37,2,-9
	dc.l 30,2,-9,30,5,-9,40,5,-9,40,10,-9,25,10,-9
	dc.w 60
	dc.w 4,-1,0,1*6,0,0,0*6,0,0,36*6,0,0,37*6,0,0
	dc.w 4,-1,0,2*6,0,0,1*6,0,0,37*6,0,0,38*6,0,0
	dc.w 4,-1,0,3*6,0,0,2*6,0,0,38*6,0,0,39*6,0,0
	dc.w 4,-1,0,4*6,0,0,3*6,0,0,39*6,0,0,40*6,0,0
	dc.w 4,-1,0,5*6,0,0,4*6,0,0,40*6,0,0,41*6,0,0
	dc.w 4,-1,0,0*6,0,0,5*6,0,0,41*6,0,0,36*6,0,0
	dc.w 4,-2,0,7*6,0,0,6*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,-2,0,8*6,0,0,7*6,0,0,43*6,0,0,44*6,0,0
	dc.w 4,-2,0,9*6,0,0,8*6,0,0,44*6,0,0,45*6,0,0
	dc.w 4,-2,0,10*6,0,0,9*6,0,0,45*6,0,0,46*6,0,0
	dc.w 4,-2,0,11*6,0,0,10*6,0,0,46*6,0,0,47*6,0,0
	dc.w 4,-2,0,12*6,0,0,11*6,0,0,47*6,0,0,48*6,0,0
	dc.w 4,-2,0,13*6,0,0,12*6,0,0,48*6,0,0,49*6,0,0
	dc.w 4,-2,0,6*6,0,0,13*6,0,0,49*6,0,0,42*6,0,0
	dc.w 4,-2,0,15*6,0,0,14*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,-2,0,16*6,0,0,15*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,-2,0,17*6,0,0,16*6,0,0,52*6,0,0,53*6,0,0
	dc.w 4,-2,0,14*6,0,0,17*6,0,0,53*6,0,0,50*6,0,0
	dc.w 4,-3,0,19*6,0,0,18*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,-3,0,20*6,0,0,19*6,0,0,55*6,0,0,56*6,0,0
	dc.w 4,-3,0,21*6,0,0,20*6,0,0,56*6,0,0,57*6,0,0
	dc.w 4,-3,0,22*6,0,0,21*6,0,0,57*6,0,0,58*6,0,0
	dc.w 4,-3,0,23*6,0,0,22*6,0,0,58*6,0,0,59*6,0,0
	dc.w 4,-3,0,18*6,0,0,23*6,0,0,59*6,0,0,54*6,0,0
	dc.w 4,-4,0,25*6,0,0,24*6,0,0,60*6,0,0,61*6,0,0
	dc.w 4,-4,0,26*6,0,0,25*6,0,0,61*6,0,0,62*6,0,0
	dc.w 4,-4,0,27*6,0,0,26*6,0,0,62*6,0,0,63*6,0,0
	dc.w 4,-4,0,28*6,0,0,27*6,0,0,63*6,0,0,64*6,0,0
	dc.w 4,-4,0,29*6,0,0,28*6,0,0,64*6,0,0,65*6,0,0
	dc.w 4,-4,0,30*6,0,0,29*6,0,0,65*6,0,0,66*6,0,0
	dc.w 4,-4,0,31*6,0,0,30*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,-4,0,32*6,0,0,31*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,-4,0,33*6,0,0,32*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,-4,0,34*6,0,0,33*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,-4,0,35*6,0,0,34*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,-4,0,24*6,0,0,35*6,0,0,71*6,0,0,60*6,0,0
	dc.w 4,-1,0,37*6,0,0,36*6,0,0,41*6,0,0,38*6,0,0
	dc.w 4,-1,0,39*6,0,0,38*6,0,0,41*6,0,0,40*6,0,0
	dc.w 4,-1,0,0*6,0,0,1*6,0,0,2*6,0,0,5*6,0,0
	dc.w 4,-1,0,2*6,0,0,3*6,0,0,4*6,0,0,5*6,0,0
	dc.w 6,-2,0,6*6,0,0,7*6,0,0,14*6,0,0,17*6,0,0,12*6,0,0,13*6,0,0
	dc.w 6,-2,0,8*6,0,0,9*6,0,0,10*6,0,0,11*6,0,0,16*6,0,0,15*6,0,0
	dc.w 4,-2,0,7*6,0,0,8*6,0,0,15*6,0,0,14*6,0,0
	dc.w 4,-2,0,11*6,0,0,12*6,0,0,17*6,0,0,16*6,0,0
	dc.w 4,-3,0,20*6,0,0,23*6,0,0,18*6,0,0,19*6,0,0
	dc.w 4,-3,0,22*6,0,0,23*6,0,0,20*6,0,0,21*6,0,0
	dc.w 4,-4,0,24*6,0,0,25*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,-4,0,28*6,0,0,29*6,0,0,30*6,0,0,31*6,0,0
	dc.w 4,-4,0,32*6,0,0,33*6,0,0,34*6,0,0,35*6,0,0
	dc.w 4,-4,0,35*6,0,0,24*6,0,0,27*6,0,0,32*6,0,0
	dc.w 6,-2,0,49*6,0,0,48*6,0,0,53*6,0,0,50*6,0,0,43*6,0,0,42*6,0,0
	dc.w 6,-2,0,45*6,0,0,44*6,0,0,51*6,0,0,52*6,0,0,47*6,0,0,46*6,0,0
	dc.w 4,-2,0,44*6,0,0,43*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,-2,0,52*6,0,0,53*6,0,0,48*6,0,0,47*6,0,0
	dc.w 4,-3,0,54*6,0,0,59*6,0,0,56*6,0,0,55*6,0,0
	dc.w 4,-3,0,56*6,0,0,59*6,0,0,58*6,0,0,57*6,0,0
	dc.w 4,-4,0,63*6,0,0,62*6,0,0,61*6,0,0,60*6,0,0
	dc.w 4,-4,0,67*6,0,0,66*6,0,0,65*6,0,0,64*6,0,0
	dc.w 4,-4,0,71*6,0,0,70*6,0,0,69*6,0,0,68*6,0,0
	dc.w 4,-4,0,60*6,0,0,71*6,0,0,68*6,0,0,63*6,0,0
	addobject 0,360-45,90,256,512,256,scraper.obj
	addobject 0,360-45,90,256,512,256,nscraper.obj
	addobject 180,0,0,48,48,48,strship.obj
	addobject 0,0,0,256,256,512
	dc.w 2,1,$3df,1,$fcf,66*2
	dc.l -145,0,9,-160,8,9,-200,0,9,-200,-14,9,-140,-28,9,-117,-20,9
	dc.l -124,21,9,-100,20,9,-76,-20,9,-66,-22,9,-75,3,9,-70,30,9
	dc.l -60,33,9,-70,40,9,-90,30,9,-88,12,9,-114,35,9,-135,30,9
	dc.l -134,4,9,-132,-18,9,-180,-17,9,-182,-5,9,-162,0,9
	dc.l -20,11,9,-4,0,9,3,30,9,-10,31,9,-15,16,9,-40,33,9,-45,34,9
	dc.l -38,3,9,-28,4,9,-33,18,9
	dc.l 25,-8,9,32,-14,9,38,-10,9,31,0,9,24,6,9,35,6,9,32,20,9
	dc.l 42,27,9,38,33,9,24,31,9,20,20,9
	dc.l 73,5,9,70,17,9,80,24,9,96,20,9,87,14,9,80,11,9,86,3,9
	dc.l 103,14,9,98,28,9,80,31,9,61,26,9,60,15,9
	dc.l 140,15,9,157,4,9,162,10,9,165,32,9,151,33,9,147,17,9
	dc.l 119,34,9,121,8,9,136,2,9,134,18,9
	dc.l -145,0,-9,-160,8,-9,-200,0,-9,-200,-14,-9,-140,-28,-9,-117,-20,-9
	dc.l -124,21,-9,-100,20,-9,-76,-20,-9,-66,-22,-9,-75,3,-9,-70,30,-9
	dc.l -60,33,-9,-70,40,-9,-90,30,-9,-88,12,-9,-114,35,-9,-135,30,-9
	dc.l -134,4,-9,-132,-18,-9,-180,-17,-9,-182,-5,-9,-162,0,-9
	dc.l -20,11,-9,-4,0,-9,3,30,-9,-10,31,-9,-15,16,-9,-40,33,-9,-45,34,-9
	dc.l -38,3,-9,-28,4,-9,-33,18,-9
	dc.l 25,-8,-9,32,-14,-9,38,-10,-9,31,0,-9,24,6,-9,35,6,-9,32,20,-9
	dc.l 42,27,-9,38,33,-9,24,31,-9,20,20,-9
	dc.l 73,5,-9,70,17,-9,80,24,-9,96,20,-9,87,14,-9,80,11,-9,86,3,-9
	dc.l 103,14,-9,98,28,-9,80,31,-9,61,26,-9,60,15,-9
	dc.l 140,15,-9,157,4,-9,162,10,-9,165,32,-9,151,33,-9,147,17,-9
	dc.l 119,34,-9,121,8,-9,136,2,-9,134,18,-9
	dc.w 66+28*2
	dc.w 4,0,0,1*6,0,0,0*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,0,0,4*6,0,0,3*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,0,0,5*6,0,0,4*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,0,0,6*6,0,0,5*6,0,0,71*6,0,0,72*6,0,0
	dc.w 4,0,0,7*6,0,0,6*6,0,0,72*6,0,0,73*6,0,0
	dc.w 4,0,0,8*6,0,0,7*6,0,0,73*6,0,0,74*6,0,0
	dc.w 4,0,0,9*6,0,0,8*6,0,0,74*6,0,0,75*6,0,0
	dc.w 4,0,0,10*6,0,0,9*6,0,0,75*6,0,0,76*6,0,0
	dc.w 4,0,0,11*6,0,0,10*6,0,0,76*6,0,0,77*6,0,0
	dc.w 4,0,0,12*6,0,0,11*6,0,0,77*6,0,0,78*6,0,0
	dc.w 4,0,0,13*6,0,0,12*6,0,0,78*6,0,0,79*6,0,0
	dc.w 4,0,0,14*6,0,0,13*6,0,0,79*6,0,0,80*6,0,0
	dc.w 4,0,0,15*6,0,0,14*6,0,0,80*6,0,0,81*6,0,0
	dc.w 4,0,0,16*6,0,0,15*6,0,0,81*6,0,0,82*6,0,0
	dc.w 4,0,0,17*6,0,0,16*6,0,0,82*6,0,0,83*6,0,0
	dc.w 4,0,0,18*6,0,0,17*6,0,0,83*6,0,0,84*6,0,0
	dc.w 4,0,0,19*6,0,0,18*6,0,0,84*6,0,0,85*6,0,0
	dc.w 4,0,0,20*6,0,0,19*6,0,0,85*6,0,0,86*6,0,0
	dc.w 4,0,0,21*6,0,0,20*6,0,0,86*6,0,0,87*6,0,0
	dc.w 4,0,0,22*6,0,0,21*6,0,0,87*6,0,0,88*6,0,0
	dc.w 4,0,0,0*6,0,0,22*6,0,0,88*6,0,0,66*6,0,0
	dc.w 4,0,0,24*6,0,0,23*6,0,0,89*6,0,0,90*6,0,0
	dc.w 4,0,0,25*6,0,0,24*6,0,0,90*6,0,0,91*6,0,0
	dc.w 4,0,0,26*6,0,0,25*6,0,0,91*6,0,0,92*6,0,0
	dc.w 4,0,0,27*6,0,0,26*6,0,0,92*6,0,0,93*6,0,0
	dc.w 4,0,0,28*6,0,0,27*6,0,0,93*6,0,0,94*6,0,0
	dc.w 4,0,0,29*6,0,0,28*6,0,0,94*6,0,0,95*6,0,0
	dc.w 4,0,0,30*6,0,0,29*6,0,0,95*6,0,0,96*6,0,0
	dc.w 4,0,0,31*6,0,0,30*6,0,0,96*6,0,0,97*6,0,0
	dc.w 4,0,0,32*6,0,0,31*6,0,0,97*6,0,0,98*6,0,0
	dc.w 4,0,0,23*6,0,0,32*6,0,0,98*6,0,0,89*6,0,0
	dc.w 4,0,0,34*6,0,0,33*6,0,0,99*6,0,0,100*6,0,0
	dc.w 4,0,0,35*6,0,0,34*6,0,0,100*6,0,0,101*6,0,0
	dc.w 4,0,0,36*6,0,0,35*6,0,0,101*6,0,0,102*6,0,0
	dc.w 4,0,0,33*6,0,0,36*6,0,0,102*6,0,0,99*6,0,0
	dc.w 4,0,0,38*6,0,0,37*6,0,0,103*6,0,0,104*6,0,0
	dc.w 4,0,0,39*6,0,0,38*6,0,0,104*6,0,0,105*6,0,0
	dc.w 4,0,0,40*6,0,0,39*6,0,0,105*6,0,0,106*6,0,0
	dc.w 4,0,0,41*6,0,0,40*6,0,0,106*6,0,0,107*6,0,0
	dc.w 4,0,0,42*6,0,0,41*6,0,0,107*6,0,0,108*6,0,0
	dc.w 4,0,0,43*6,0,0,42*6,0,0,108*6,0,0,109*6,0,0
	dc.w 4,0,0,37*6,0,0,43*6,0,0,109*6,0,0,103*6,0,0
	dc.w 4,0,0,45*6,0,0,44*6,0,0,110*6,0,0,111*6,0,0
	dc.w 4,0,0,46*6,0,0,45*6,0,0,111*6,0,0,112*6,0,0
	dc.w 4,0,0,47*6,0,0,46*6,0,0,112*6,0,0,113*6,0,0
	dc.w 4,0,0,48*6,0,0,47*6,0,0,113*6,0,0,114*6,0,0
	dc.w 4,0,0,49*6,0,0,48*6,0,0,114*6,0,0,115*6,0,0
	dc.w 4,0,0,50*6,0,0,49*6,0,0,115*6,0,0,116*6,0,0
	dc.w 4,0,0,51*6,0,0,50*6,0,0,116*6,0,0,117*6,0,0
	dc.w 4,0,0,52*6,0,0,51*6,0,0,117*6,0,0,118*6,0,0
	dc.w 4,0,0,53*6,0,0,52*6,0,0,118*6,0,0,119*6,0,0
	dc.w 4,0,0,54*6,0,0,53*6,0,0,119*6,0,0,120*6,0,0
	dc.w 4,0,0,55*6,0,0,54*6,0,0,120*6,0,0,121*6,0,0
	dc.w 4,0,0,44*6,0,0,55*6,0,0,121*6,0,0,110*6,0,0
	dc.w 4,0,0,57*6,0,0,56*6,0,0,122*6,0,0,123*6,0,0
	dc.w 4,0,0,58*6,0,0,57*6,0,0,123*6,0,0,124*6,0,0
	dc.w 4,0,0,59*6,0,0,58*6,0,0,124*6,0,0,125*6,0,0
	dc.w 4,0,0,60*6,0,0,59*6,0,0,125*6,0,0,126*6,0,0
	dc.w 4,0,0,61*6,0,0,60*6,0,0,126*6,0,0,127*6,0,0
	dc.w 4,0,0,62*6,0,0,61*6,0,0,127*6,0,0,128*6,0,0
	dc.w 4,0,0,63*6,0,0,62*6,0,0,128*6,0,0,129*6,0,0
	dc.w 4,0,0,64*6,0,0,63*6,0,0,129*6,0,0,130*6,0,0
	dc.w 4,0,0,65*6,0,0,64*6,0,0,130*6,0,0,131*6,0,0
	dc.w 4,0,0,56*6,0,0,65*6,0,0,131*6,0,0,122*6,0,0

	dc.w 3,1,0,0*6,0,0,1*6,0,0,22*6,0,0
	dc.w 4,1,0,1*6,0,0,2*6,0,0,21*6,0,0,22*6,0,0
	dc.w 4,1,0,2*6,0,0,3*6,0,0,20*6,0,0,21*6,0,0
	dc.w 3,1,0,3*6,0,0,4*6,0,0,20*6,0,0
	dc.w 3,1,0,4*6,0,0,19*6,0,0,20*6,0,0
	dc.w 3,1,0,4*6,0,0,5*6,0,0,19*6,0,0
	dc.w 4,1,0,5*6,0,0,6*6,0,0,18*6,0,0,19*6,0,0
	dc.w 3,1,0,6*6,0,0,17*6,0,0,18*6,0,0
	dc.w 4,1,0,6*6,0,0,7*6,0,0,16*6,0,0,17*6,0,0
	dc.w 3,1,0,7*6,0,0,15*6,0,0,16*6,0,0
	dc.w 5,1,0,7*6,0,0,8*6,0,0,9*6,0,0,10*6,0,0,15*6,0,0
	dc.w 4,1,0,10*6,0,0,11*6,0,0,14*6,0,0,15*6,0,0
	dc.w 4,1,0,11*6,0,0,12*6,0,0,13*6,0,0,14*6,0,0
	dc.w 5,1,0,30*6,0,0,31*6,0,0,32*6,0,0,28*6,0,0,29*6,0,0
	dc.w 5,1,0,23*6,0,0,24*6,0,0,27*6,0,0,28*6,0,0,32*6,0,0
	dc.w 4,1,0,24*6,0,0,25*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,1,0,33*6,0,0,34*6,0,0,35*6,0,0,36*6,0,0
	dc.w 5,1,0,37*6,0,0,38*6,0,0,39*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,1,0,39*6,0,0,40*6,0,0,41*6,0,0,42*6,0,0
	dc.w 4,1,0,44*6,0,0,45*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,1,0,45*6,0,0,46*6,0,0,53*6,0,0,54*6,0,0
	dc.w 4,1,0,46*6,0,0,47*6,0,0,52*6,0,0,53*6,0,0
	dc.w 3,1,0,47*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,1,0,47*6,0,0,48*6,0,0,50*6,0,0,51*6,0,0
	dc.w 3,1,0,48*6,0,0,49*6,0,0,50*6,0,0
	dc.w 4,1,0,63*6,0,0,64*6,0,0,65*6,0,0,62*6,0,0
	dc.w 5,1,0,56*6,0,0,57*6,0,0,61*6,0,0,62*6,0,0,65*6,0,0
	dc.w 5,1,0,58*6,0,0,59*6,0,0,60*6,0,0,61*6,0,0,57*6,0,0

	dc.w 3,1,0,88*6,0,0,67*6,0,0,66*6,0,0
	dc.w 4,1,0,88*6,0,0,87*6,0,0,68*6,0,0,67*6,0,0
	dc.w 4,1,0,87*6,0,0,86*6,0,0,69*6,0,0,68*6,0,0
	dc.w 3,1,0,86*6,0,0,70*6,0,0,69*6,0,0
	dc.w 3,1,0,86*6,0,0,85*6,0,0,70*6,0,0
	dc.w 3,1,0,85*6,0,0,71*6,0,0,70*6,0,0
	dc.w 4,1,0,85*6,0,0,84*6,0,0,72*6,0,0,71*6,0,0
	dc.w 3,1,0,84*6,0,0,83*6,0,0,72*6,0,0
	dc.w 4,1,0,83*6,0,0,82*6,0,0,73*6,0,0,72*6,0,0
	dc.w 3,1,0,82*6,0,0,81*6,0,0,73*6,0,0
	dc.w 5,1,0,81*6,0,0,76*6,0,0,75*6,0,0,74*6,0,0,73*6,0,0
	dc.w 4,1,0,81*6,0,0,80*6,0,0,77*6,0,0,76*6,0,0
	dc.w 4,1,0,80*6,0,0,79*6,0,0,78*6,0,0,77*6,0,0
	dc.w 5,1,0,95*6,0,0,94*6,0,0,98*6,0,0,97*6,0,0,96*6,0,0
	dc.w 5,1,0,98*6,0,0,94*6,0,0,93*6,0,0,90*6,0,0,89*6,0,0
	dc.w 4,1,0,93*6,0,0,92*6,0,0,91*6,0,0,90*6,0,0
	dc.w 4,1,0,102*6,0,0,101*6,0,0,100*6,0,0,99*6,0,0
	dc.w 5,1,0,109*6,0,0,108*6,0,0,105*6,0,0,104*6,0,0,103*6,0,0
	dc.w 4,1,0,108*6,0,0,107*6,0,0,106*6,0,0,105*6,0,0
	dc.w 4,1,0,121*6,0,0,120*6,0,0,111*6,0,0,110*6,0,0
	dc.w 4,1,0,120*6,0,0,119*6,0,0,112*6,0,0,111*6,0,0
	dc.w 4,1,0,119*6,0,0,118*6,0,0,113*6,0,0,112*6,0,0
	dc.w 3,1,0,118*6,0,0,117*6,0,0,113*6,0,0
	dc.w 4,1,0,117*6,0,0,116*6,0,0,114*6,0,0,113*6,0,0
	dc.w 3,1,0,116*6,0,0,115*6,0,0,114*6,0,0
	dc.w 4,1,0,128*6,0,0,131*6,0,0,130*6,0,0,129*6,0,0
	dc.w 5,1,0,131*6,0,0,128*6,0,0,127*6,0,0,123*6,0,0,122*6,0,0
	dc.w 5,1,0,123*6,0,0,127*6,0,0,126*6,0,0,125*6,0,0,124*6,0,0
	addobject 0,180,0,256,256,256
	dc.w 4,1,$fff,1,$0ff,1,$f8e,1,$fa5,22*5
	dc.l -43,-43,-50,-50,-33,-50,-57,-17,-50,-60,0,-50,-56,18,-50,-50,33,-50
	dc.l -33,50,-50,-17,57,-50,0,60,-50,16,58,-50,33,50,-50,43,43,-50,52,31,-50
	dc.l 57,16,-50,60,0,-50,57,-18,-50,50,-33,-50,33,-50,-50,18,-57,-50,0,-60,-50
	dc.l -16,-58,-50,-30,-54,-50
	dc.l -14,-14,-20,-16,-11,-20,-19,-6,-20,-20,0,-20,-19,6,-20,-16,11,-20
	dc.l -11,17,-20,-6,19,-20,0,20,-20,5,19,-20,11,17,-20,14,14,-20,17,10,-20
	dc.l 19,5,-20,20,0,-20,19,-6,-20,17,-11,-20,11,-17,-20,6,-19,-20,0,-20,-20
	dc.l -5,-19,-20,-10,-18,-20
	dc.l -14,-14,0,-16,-11,0,-19,-6,0,-20,0,0,-19,6,0,-16,11,0
	dc.l -11,17,0,-6,19,0,0,20,0,5,19,0,11,17,0,14,14,0,17,10,0
	dc.l 19,5,0,20,0,0,19,-6,0,17,-11,0,11,-17,0,6,-19,0,0,-20,0
	dc.l -5,-19,0,-10,-18,0
	dc.l -14,-14,20,-16,-11,20,-19,-6,20,-20,0,20,-19,6,20,-16,11,20
	dc.l -11,17,20,-6,19,20,0,20,20,5,19,20,11,17,20,14,14,20,17,10,20
	dc.l 19,5,20,20,0,20,19,-6,20,17,-11,20,11,-17,20,6,-19,20,0,-20,20
	dc.l -5,-19,20,-10,-18,20
	dc.l -43,-43,50,-50,-33,50,-57,-17,50,-60,0,50,-56,18,50,-50,33,50
	dc.l -33,50,50,-17,57,50,0,60,50,16,58,50,33,50,50,43,43,50,52,31,50
	dc.l 57,16,50,60,0,50,57,-18,50,50,-33,50,33,-50,50,18,-57,50,0,-60,50
	dc.l -16,-58,50,-30,-54,50
	dc.w 98
	dc.w 4,0,0,1*6,0,0,0*6,0,0,22*6,0,0,23*6,0,0
	dc.w 4,1,0,23*6,0,0,22*6,0,0,44*6,0,0,45*6,0,0
	dc.w 4,2,0,45*6,0,0,44*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,3,0,67*6,0,0,66*6,0,0,88*6,0,0,89*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,23*6,0,0,24*6,0,0
	dc.w 4,1,0,24*6,0,0,23*6,0,0,45*6,0,0,46*6,0,0
	dc.w 4,2,0,46*6,0,0,45*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,3,0,68*6,0,0,67*6,0,0,89*6,0,0,90*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,24*6,0,0,25*6,0,0
	dc.w 4,1,0,25*6,0,0,24*6,0,0,46*6,0,0,47*6,0,0
	dc.w 4,2,0,47*6,0,0,46*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,3,0,69*6,0,0,68*6,0,0,90*6,0,0,91*6,0,0
	dc.w 4,0,0,4*6,0,0,3*6,0,0,25*6,0,0,26*6,0,0
	dc.w 4,1,0,26*6,0,0,25*6,0,0,47*6,0,0,48*6,0,0
	dc.w 4,2,0,48*6,0,0,47*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,3,0,70*6,0,0,69*6,0,0,91*6,0,0,92*6,0,0
	dc.w 4,0,0,5*6,0,0,4*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,1,0,27*6,0,0,26*6,0,0,48*6,0,0,49*6,0,0
	dc.w 4,2,0,49*6,0,0,48*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,3,0,71*6,0,0,70*6,0,0,92*6,0,0,93*6,0,0
	dc.w 4,0,0,6*6,0,0,5*6,0,0,27*6,0,0,28*6,0,0
	dc.w 4,1,0,28*6,0,0,27*6,0,0,49*6,0,0,50*6,0,0
	dc.w 4,2,0,50*6,0,0,49*6,0,0,71*6,0,0,72*6,0,0
	dc.w 4,3,0,72*6,0,0,71*6,0,0,93*6,0,0,94*6,0,0
	dc.w 4,0,0,7*6,0,0,6*6,0,0,28*6,0,0,29*6,0,0
	dc.w 4,1,0,29*6,0,0,28*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,2,0,51*6,0,0,50*6,0,0,72*6,0,0,73*6,0,0
	dc.w 4,3,0,73*6,0,0,72*6,0,0,94*6,0,0,95*6,0,0
	dc.w 4,0,0,8*6,0,0,7*6,0,0,29*6,0,0,30*6,0,0
	dc.w 4,1,0,30*6,0,0,29*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,2,0,52*6,0,0,51*6,0,0,73*6,0,0,74*6,0,0
	dc.w 4,3,0,74*6,0,0,73*6,0,0,95*6,0,0,96*6,0,0
	dc.w 4,0,0,9*6,0,0,8*6,0,0,30*6,0,0,31*6,0,0
	dc.w 4,1,0,31*6,0,0,30*6,0,0,52*6,0,0,53*6,0,0
	dc.w 4,2,0,53*6,0,0,52*6,0,0,74*6,0,0,75*6,0,0
	dc.w 4,3,0,75*6,0,0,74*6,0,0,96*6,0,0,97*6,0,0
	dc.w 4,0,0,10*6,0,0,9*6,0,0,31*6,0,0,32*6,0,0
	dc.w 4,1,0,32*6,0,0,31*6,0,0,53*6,0,0,54*6,0,0
	dc.w 4,2,0,54*6,0,0,53*6,0,0,75*6,0,0,76*6,0,0
	dc.w 4,3,0,76*6,0,0,75*6,0,0,97*6,0,0,98*6,0,0
	dc.w 4,0,0,11*6,0,0,10*6,0,0,32*6,0,0,33*6,0,0
	dc.w 4,1,0,33*6,0,0,32*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,2,0,55*6,0,0,54*6,0,0,76*6,0,0,77*6,0,0
	dc.w 4,3,0,77*6,0,0,76*6,0,0,98*6,0,0,99*6,0,0
	dc.w 4,0,0,12*6,0,0,11*6,0,0,33*6,0,0,34*6,0,0
	dc.w 4,1,0,34*6,0,0,33*6,0,0,55*6,0,0,56*6,0,0
	dc.w 4,2,0,56*6,0,0,55*6,0,0,77*6,0,0,78*6,0,0
	dc.w 4,3,0,78*6,0,0,77*6,0,0,99*6,0,0,100*6,0,0
	dc.w 4,0,0,13*6,0,0,12*6,0,0,34*6,0,0,35*6,0,0
	dc.w 4,1,0,35*6,0,0,34*6,0,0,56*6,0,0,57*6,0,0
	dc.w 4,2,0,57*6,0,0,56*6,0,0,78*6,0,0,79*6,0,0
	dc.w 4,3,0,79*6,0,0,78*6,0,0,100*6,0,0,101*6,0,0
	dc.w 4,0,0,14*6,0,0,13*6,0,0,35*6,0,0,36*6,0,0
	dc.w 4,1,0,36*6,0,0,35*6,0,0,57*6,0,0,58*6,0,0
	dc.w 4,2,0,58*6,0,0,57*6,0,0,79*6,0,0,80*6,0,0
	dc.w 4,3,0,80*6,0,0,79*6,0,0,101*6,0,0,102*6,0,0
	dc.w 4,0,0,15*6,0,0,14*6,0,0,36*6,0,0,37*6,0,0
	dc.w 4,1,0,37*6,0,0,36*6,0,0,58*6,0,0,59*6,0,0
	dc.w 4,2,0,59*6,0,0,58*6,0,0,80*6,0,0,81*6,0,0
	dc.w 4,3,0,81*6,0,0,80*6,0,0,102*6,0,0,103*6,0,0
	dc.w 4,0,0,16*6,0,0,15*6,0,0,37*6,0,0,38*6,0,0
	dc.w 4,1,0,38*6,0,0,37*6,0,0,59*6,0,0,60*6,0,0
	dc.w 4,2,0,60*6,0,0,59*6,0,0,81*6,0,0,82*6,0,0
	dc.w 4,3,0,82*6,0,0,81*6,0,0,103*6,0,0,104*6,0,0
	dc.w 4,0,0,17*6,0,0,16*6,0,0,38*6,0,0,39*6,0,0
	dc.w 4,1,0,39*6,0,0,38*6,0,0,60*6,0,0,61*6,0,0
	dc.w 4,2,0,61*6,0,0,60*6,0,0,82*6,0,0,83*6,0,0
	dc.w 4,3,0,83*6,0,0,82*6,0,0,104*6,0,0,105*6,0,0
	dc.w 4,0,0,18*6,0,0,17*6,0,0,39*6,0,0,40*6,0,0
	dc.w 4,1,0,40*6,0,0,39*6,0,0,61*6,0,0,62*6,0,0
	dc.w 4,2,0,62*6,0,0,61*6,0,0,83*6,0,0,84*6,0,0
	dc.w 4,3,0,84*6,0,0,83*6,0,0,105*6,0,0,106*6,0,0
	dc.w 4,0,0,19*6,0,0,18*6,0,0,40*6,0,0,41*6,0,0
	dc.w 4,1,0,41*6,0,0,40*6,0,0,62*6,0,0,63*6,0,0
	dc.w 4,2,0,63*6,0,0,62*6,0,0,84*6,0,0,85*6,0,0
	dc.w 4,3,0,85*6,0,0,84*6,0,0,106*6,0,0,107*6,0,0
	dc.w 4,0,0,20*6,0,0,19*6,0,0,41*6,0,0,42*6,0,0
	dc.w 4,1,0,42*6,0,0,41*6,0,0,63*6,0,0,64*6,0,0
	dc.w 4,2,0,64*6,0,0,63*6,0,0,85*6,0,0,86*6,0,0
	dc.w 4,3,0,86*6,0,0,85*6,0,0,107*6,0,0,108*6,0,0
	dc.w 4,0,0,21*6,0,0,20*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,1,0,43*6,0,0,42*6,0,0,64*6,0,0,65*6,0,0
	dc.w 4,2,0,65*6,0,0,64*6,0,0,86*6,0,0,87*6,0,0
	dc.w 4,3,0,87*6,0,0,86*6,0,0,108*6,0,0,109*6,0,0
	dc.w 4,0,0,0*6,0,0,21*6,0,0,43*6,0,0,22*6,0,0
	dc.w 4,1,0,22*6,0,0,43*6,0,0,65*6,0,0,44*6,0,0
	dc.w 4,2,0,44*6,0,0,65*6,0,0,87*6,0,0,66*6,0,0
	dc.w 4,3,0,66*6,0,0,87*6,0,0,109*6,0,0,88*6,0,0
	dc.w 6,0,0,3*6,0,0,4*6,0,0,5*6,0,0,6*6,0,0,7*6,0,0,8*6,0,0
	dc.w 4,0,0,2*6,0,0,3*6,0,0,8*6,0,0,9*6,0,0
	dc.w 5,0,0,1*6,0,0,2*6,0,0,9*6,0,0,10*6,0,0,11*6,0,0
	dc.w 4,0,0,0*6,0,0,1*6,0,0,11*6,0,0,21*6,0,0
	dc.w 11,0,0,21*6,0,0,11*6,0,0,12*6,0,0,13*6,0,0,14*6,0,0,15*6,0,0
	dc.w 16*6,0,0,17*6,0,0,18*6,0,0,19*6,0,0,20*6,0,0
	dc.w 6,0,0,96*6,0,0,95*6,0,0,94*6,0,0,93*6,0,0,92*6,0,0,91*6,0,0
	dc.w 4,0,0,97*6,0,0,96*6,0,0,91*6,0,0,90*6,0,0
	dc.w 5,0,0,97*6,0,0,90*6,0,0,89*6,0,0,99*6,0,0,98*6,0,0
	dc.w 4,0,0,109*6,0,0,99*6,0,0,89*6,0,0,88*6,0,0
	dc.w 11,0,0,109*6,0,0,108*6,0,0,107*6,0,0,106*6,0,0,105*6,0,0
	dc.w 104*6,0,0,103*6,0,0,102*6,0,0,101*6,0,0,100*6,0,0,99*6,0,0
	addobject 0,180,0,256,256,256
	dc.w 4,1,$0f0,1,$0f0,1,$0ff,1,$ff0,22*5
	dc.l -21,-21,-30,-25,-16,-30,-28,-8,-30,-30,0,-30,-28,9,-30,-25,16,-30
	dc.l -16,25,-30,-8,28,-30,0,30,-30,8,29,-30,16,25,-30,21,21,-30,26,15,-30
	dc.l 28,8,-30,30,0,-30,28,-9,-30,25,-16,-30,16,-25,-30,9,-28,-30,0,-30,-30
	dc.l -8,-29,-30,-15,-27,-30
	dc.l -43,-43,0,-50,-33,0,-57,-17,0,-60,0,0,-56,18,0,-50,33,0
	dc.l -33,50,0,-17,57,0,0,60,0,16,58,0,33,50,0,43,43,0,52,31,0
	dc.l 57,16,0,60,0,0,57,-18,0,50,-33,0,33,-50,0,18,-57,0,0,-60,0
	dc.l -16,-58,0,-30,-54,0
	dc.l -43,-43,30,-50,-33,30,-57,-17,30,-60,0,30,-56,18,30,-50,33,30
	dc.l -33,50,30,-17,57,30,0,60,30,16,58,30,33,50,30,43,43,30,52,31,30
	dc.l 57,16,30,60,0,30,57,-18,30,50,-33,30,33,-50,30,18,-57,30,0,-60,30
	dc.l -16,-58,30,-30,-54,30
	dc.l -28,-28,30,-32,-22,30,-38,-12,30,-40,0,30,-38,12,30,-32,22,30
	dc.l -22,34,30,-12,38,30,0,40,30,10,38,30,22,34,30,28,28,30,34,20,30
	dc.l 38,10,30,40,0,30,38,-12,30,34,-22,30,22,-34,30,12,-38,30,0,-40,30
	dc.l -10,-38,30,-20,-36,30
	dc.l -14,-14,-20,-16,-11,-20,-19,-6,-20,-20,0,-20,-19,6,-20,-16,11,-20
	dc.l -11,17,-20,-6,19,-20,0,20,-20,5,19,-20,11,17,-20,14,14,-20,17,10,-20
	dc.l 19,5,-20,20,0,-20,19,-6,-20,17,-11,-20,11,-17,-20,6,-19,-20,0,-20,-20
	dc.l -5,-19,-20,-10,-18,-20
	dc.w 98
	dc.w 4,0,0,1*6,0,0,0*6,0,0,22*6,0,0,23*6,0,0
	dc.w 4,1,0,23*6,0,0,22*6,0,0,44*6,0,0,45*6,0,0
	dc.w 4,2,0,45*6,0,0,44*6,0,0,66*6,0,0,67*6,0,0
	dc.w 4,3,0,67*6,0,0,66*6,0,0,88*6,0,0,89*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,23*6,0,0,24*6,0,0
	dc.w 4,1,0,24*6,0,0,23*6,0,0,45*6,0,0,46*6,0,0
	dc.w 4,2,0,46*6,0,0,45*6,0,0,67*6,0,0,68*6,0,0
	dc.w 4,3,0,68*6,0,0,67*6,0,0,89*6,0,0,90*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,24*6,0,0,25*6,0,0
	dc.w 4,1,0,25*6,0,0,24*6,0,0,46*6,0,0,47*6,0,0
	dc.w 4,2,0,47*6,0,0,46*6,0,0,68*6,0,0,69*6,0,0
	dc.w 4,3,0,69*6,0,0,68*6,0,0,90*6,0,0,91*6,0,0
	dc.w 4,0,0,4*6,0,0,3*6,0,0,25*6,0,0,26*6,0,0
	dc.w 4,1,0,26*6,0,0,25*6,0,0,47*6,0,0,48*6,0,0
	dc.w 4,2,0,48*6,0,0,47*6,0,0,69*6,0,0,70*6,0,0
	dc.w 4,3,0,70*6,0,0,69*6,0,0,91*6,0,0,92*6,0,0
	dc.w 4,0,0,5*6,0,0,4*6,0,0,26*6,0,0,27*6,0,0
	dc.w 4,1,0,27*6,0,0,26*6,0,0,48*6,0,0,49*6,0,0
	dc.w 4,2,0,49*6,0,0,48*6,0,0,70*6,0,0,71*6,0,0
	dc.w 4,3,0,71*6,0,0,70*6,0,0,92*6,0,0,93*6,0,0
	dc.w 4,0,0,6*6,0,0,5*6,0,0,27*6,0,0,28*6,0,0
	dc.w 4,1,0,28*6,0,0,27*6,0,0,49*6,0,0,50*6,0,0
	dc.w 4,2,0,50*6,0,0,49*6,0,0,71*6,0,0,72*6,0,0
	dc.w 4,3,0,72*6,0,0,71*6,0,0,93*6,0,0,94*6,0,0
	dc.w 4,0,0,7*6,0,0,6*6,0,0,28*6,0,0,29*6,0,0
	dc.w 4,1,0,29*6,0,0,28*6,0,0,50*6,0,0,51*6,0,0
	dc.w 4,2,0,51*6,0,0,50*6,0,0,72*6,0,0,73*6,0,0
	dc.w 4,3,0,73*6,0,0,72*6,0,0,94*6,0,0,95*6,0,0
	dc.w 4,0,0,8*6,0,0,7*6,0,0,29*6,0,0,30*6,0,0
	dc.w 4,1,0,30*6,0,0,29*6,0,0,51*6,0,0,52*6,0,0
	dc.w 4,2,0,52*6,0,0,51*6,0,0,73*6,0,0,74*6,0,0
	dc.w 4,3,0,74*6,0,0,73*6,0,0,95*6,0,0,96*6,0,0
	dc.w 4,0,0,9*6,0,0,8*6,0,0,30*6,0,0,31*6,0,0
	dc.w 4,1,0,31*6,0,0,30*6,0,0,52*6,0,0,53*6,0,0
	dc.w 4,2,0,53*6,0,0,52*6,0,0,74*6,0,0,75*6,0,0
	dc.w 4,3,0,75*6,0,0,74*6,0,0,96*6,0,0,97*6,0,0
	dc.w 4,0,0,10*6,0,0,9*6,0,0,31*6,0,0,32*6,0,0
	dc.w 4,1,0,32*6,0,0,31*6,0,0,53*6,0,0,54*6,0,0
	dc.w 4,2,0,54*6,0,0,53*6,0,0,75*6,0,0,76*6,0,0
	dc.w 4,3,0,76*6,0,0,75*6,0,0,97*6,0,0,98*6,0,0
	dc.w 4,0,0,11*6,0,0,10*6,0,0,32*6,0,0,33*6,0,0
	dc.w 4,1,0,33*6,0,0,32*6,0,0,54*6,0,0,55*6,0,0
	dc.w 4,2,0,55*6,0,0,54*6,0,0,76*6,0,0,77*6,0,0
	dc.w 4,3,0,77*6,0,0,76*6,0,0,98*6,0,0,99*6,0,0
	dc.w 4,0,0,12*6,0,0,11*6,0,0,33*6,0,0,34*6,0,0
	dc.w 4,1,0,34*6,0,0,33*6,0,0,55*6,0,0,56*6,0,0
	dc.w 4,2,0,56*6,0,0,55*6,0,0,77*6,0,0,78*6,0,0
	dc.w 4,3,0,78*6,0,0,77*6,0,0,99*6,0,0,100*6,0,0
	dc.w 4,0,0,13*6,0,0,12*6,0,0,34*6,0,0,35*6,0,0
	dc.w 4,1,0,35*6,0,0,34*6,0,0,56*6,0,0,57*6,0,0
	dc.w 4,2,0,57*6,0,0,56*6,0,0,78*6,0,0,79*6,0,0
	dc.w 4,3,0,79*6,0,0,78*6,0,0,100*6,0,0,101*6,0,0
	dc.w 4,0,0,14*6,0,0,13*6,0,0,35*6,0,0,36*6,0,0
	dc.w 4,1,0,36*6,0,0,35*6,0,0,57*6,0,0,58*6,0,0
	dc.w 4,2,0,58*6,0,0,57*6,0,0,79*6,0,0,80*6,0,0
	dc.w 4,3,0,80*6,0,0,79*6,0,0,101*6,0,0,102*6,0,0
	dc.w 4,0,0,15*6,0,0,14*6,0,0,36*6,0,0,37*6,0,0
	dc.w 4,1,0,37*6,0,0,36*6,0,0,58*6,0,0,59*6,0,0
	dc.w 4,2,0,59*6,0,0,58*6,0,0,80*6,0,0,81*6,0,0
	dc.w 4,3,0,81*6,0,0,80*6,0,0,102*6,0,0,103*6,0,0
	dc.w 4,0,0,16*6,0,0,15*6,0,0,37*6,0,0,38*6,0,0
	dc.w 4,1,0,38*6,0,0,37*6,0,0,59*6,0,0,60*6,0,0
	dc.w 4,2,0,60*6,0,0,59*6,0,0,81*6,0,0,82*6,0,0
	dc.w 4,3,0,82*6,0,0,81*6,0,0,103*6,0,0,104*6,0,0
	dc.w 4,0,0,17*6,0,0,16*6,0,0,38*6,0,0,39*6,0,0
	dc.w 4,1,0,39*6,0,0,38*6,0,0,60*6,0,0,61*6,0,0
	dc.w 4,2,0,61*6,0,0,60*6,0,0,82*6,0,0,83*6,0,0
	dc.w 4,3,0,83*6,0,0,82*6,0,0,104*6,0,0,105*6,0,0
	dc.w 4,0,0,18*6,0,0,17*6,0,0,39*6,0,0,40*6,0,0
	dc.w 4,1,0,40*6,0,0,39*6,0,0,61*6,0,0,62*6,0,0
	dc.w 4,2,0,62*6,0,0,61*6,0,0,83*6,0,0,84*6,0,0
	dc.w 4,3,0,84*6,0,0,83*6,0,0,105*6,0,0,106*6,0,0
	dc.w 4,0,0,19*6,0,0,18*6,0,0,40*6,0,0,41*6,0,0
	dc.w 4,1,0,41*6,0,0,40*6,0,0,62*6,0,0,63*6,0,0
	dc.w 4,2,0,63*6,0,0,62*6,0,0,84*6,0,0,85*6,0,0
	dc.w 4,3,0,85*6,0,0,84*6,0,0,106*6,0,0,107*6,0,0
	dc.w 4,0,0,20*6,0,0,19*6,0,0,41*6,0,0,42*6,0,0
	dc.w 4,1,0,42*6,0,0,41*6,0,0,63*6,0,0,64*6,0,0
	dc.w 4,2,0,64*6,0,0,63*6,0,0,85*6,0,0,86*6,0,0
	dc.w 4,3,0,86*6,0,0,85*6,0,0,107*6,0,0,108*6,0,0
	dc.w 4,0,0,21*6,0,0,20*6,0,0,42*6,0,0,43*6,0,0
	dc.w 4,1,0,43*6,0,0,42*6,0,0,64*6,0,0,65*6,0,0
	dc.w 4,2,0,65*6,0,0,64*6,0,0,86*6,0,0,87*6,0,0
	dc.w 4,3,0,87*6,0,0,86*6,0,0,108*6,0,0,109*6,0,0
	dc.w 4,0,0,0*6,0,0,21*6,0,0,43*6,0,0,22*6,0,0
	dc.w 4,1,0,22*6,0,0,43*6,0,0,65*6,0,0,44*6,0,0
	dc.w 4,2,0,44*6,0,0,65*6,0,0,87*6,0,0,66*6,0,0
	dc.w 4,3,0,66*6,0,0,87*6,0,0,109*6,0,0,88*6,0,0
	dc.w 6,0,0,3*6,0,0,4*6,0,0,5*6,0,0,6*6,0,0,7*6,0,0,8*6,0,0
	dc.w 4,0,0,2*6,0,0,3*6,0,0,8*6,0,0,9*6,0,0
	dc.w 5,0,0,1*6,0,0,2*6,0,0,9*6,0,0,10*6,0,0,11*6,0,0
	dc.w 4,0,0,0*6,0,0,1*6,0,0,11*6,0,0,21*6,0,0
	dc.w 11,0,0,21*6,0,0,11*6,0,0,12*6,0,0,13*6,0,0,14*6,0,0,15*6,0,0
	dc.w 16*6,0,0,17*6,0,0,18*6,0,0,19*6,0,0,20*6,0,0
	dc.w 6,3,0,96*6,0,0,95*6,0,0,94*6,0,0,93*6,0,0,92*6,0,0,91*6,0,0
	dc.w 4,3,0,97*6,0,0,96*6,0,0,91*6,0,0,90*6,0,0
	dc.w 5,3,0,97*6,0,0,90*6,0,0,89*6,0,0,99*6,0,0,98*6,0,0
	dc.w 4,3,0,109*6,0,0,99*6,0,0,89*6,0,0,88*6,0,0
	dc.w 11,3,0,109*6,0,0,108*6,0,0,107*6,0,0,106*6,0,0,105*6,0,0
	dc.w 104*6,0,0,103*6,0,0,102*6,0,0,101*6,0,0,100*6,0,0,99*6,0,0
	addobject 0,0,0,32,32,32,cube.obj
	addobject 0,0,0,512,512,256
	dc.w 1,0,$fff,4
	dc.l 80,80,0,80,-80,0,-80,-80,0,-80,80,0
	dc.w 1
	dc.w 4,0,0
	dc.w 0,0,0,6,0,$7f00,12,$7f00,$7f00,18,$7f00,0
	addobject 0,0,0,256,256,256
	dc.w 1,1,7,12
	dc.l 15,-30,20,35,0,20,15,30,20,-15,30,20,-35,0,20,-15,-30,20
	dc.l 15,-30,-20,35,0,-20,15,30,-20,-15,30,-20,-35,0,-20,-15,-30,-20
	dc.w 12
	dc.w 4,0,0,0*6,0,0,1*6,0,$7f00,7*6,$7f00,$7f00,6*6,$7f00,0
	dc.w 4,0,0,1*6,0,0,2*6,0,$7f00,8*6,$7f00,$7f00,7*6,$7f00,0
	dc.w 4,0,0,2*6,0,0,3*6,0,$7f00,9*6,$7f00,$7f00,8*6,$7f00,0
	dc.w 4,0,0,3*6,0,0,4*6,0,$7f00,10*6,$7f00,$7f00,9*6,$7f00,0
	dc.w 4,0,0,4*6,0,0,5*6,0,$7f00,11*6,$7f00,$7f00,10*6,$7f00,0
	dc.w 4,0,0,5*6,0,0,0*6,0,$7f00,6*6,$7f00,$7f00,11*6,$7f00,0
	dc.w 4,0,2,1*6,0,0,0*6,0,$7f00,6*6,$7f00,$7f00,7*6,$7f00,0
	dc.w 4,0,4,2*6,0,0,1*6,0,$7f00,7*6,$7f00,$7f00,8*6,$7f00,0
	dc.w 4,0,3,3*6,0,0,2*6,0,$7f00,8*6,$7f00,$7f00,9*6,$7f00,0
	dc.w 4,0,2,4*6,0,0,3*6,0,$7f00,9*6,$7f00,$7f00,10*6,$7f00,0
	dc.w 4,0,4,5*6,0,0,4*6,0,$7f00,10*6,$7f00,$7f00,11*6,$7f00,0
	dc.w 4,0,3,0*6,0,0,5*6,0,$7f00,11*6,$7f00,$7f00,6*6,$7f00,0
	addobject 0,0,0,256,256,460
	dc.w 1,1,$fff,12
	dc.l 15,-30,20,35,0,20,15,30,20,-15,30,20,-35,0,20,-15,-30,20
	dc.l 15,-30,-20,35,0,-20,15,30,-20,-15,30,-20,-35,0,-20,-15,-30,-20
	dc.w 12
	dc.w 4,0,2,0*6,0,0,1*6,0,$7f00,7*6,$7f00,$7f00,6*6,$7f00,0
	dc.w 4,0,4,1*6,0,0,2*6,0,$7f00,8*6,$7f00,$7f00,7*6,$7f00,0
	dc.w 4,0,3,2*6,0,0,3*6,0,$7f00,9*6,$7f00,$7f00,8*6,$7f00,0
	dc.w 4,0,2,3*6,0,0,4*6,0,$7f00,10*6,$7f00,$7f00,9*6,$7f00,0
	dc.w 4,0,4,4*6,0,0,5*6,0,$7f00,11*6,$7f00,$7f00,10*6,$7f00,0
	dc.w 4,0,3,5*6,0,0,0*6,0,$7f00,6*6,$7f00,$7f00,11*6,$7f00,0
	dc.w 4,0,2,1*6,0,0,0*6,0,$7f00,6*6,$7f00,$7f00,7*6,$7f00,0
	dc.w 4,0,4,2*6,0,0,1*6,0,$7f00,7*6,$7f00,$7f00,8*6,$7f00,0
	dc.w 4,0,3,3*6,0,0,2*6,0,$7f00,8*6,$7f00,$7f00,9*6,$7f00,0
	dc.w 4,0,2,4*6,0,0,3*6,0,$7f00,9*6,$7f00,$7f00,10*6,$7f00,0
	dc.w 4,0,4,5*6,0,0,4*6,0,$7f00,10*6,$7f00,$7f00,11*6,$7f00,0
	dc.w 4,0,3,0*6,0,0,5*6,0,$7f00,11*6,$7f00,$7f00,6*6,$7f00,0
	addobject 0,0,0,256,256,256,icube.obj
	addobject 0,180,0,256,128,128,chair.obj
	addobject 0,0,0,128,128,128,tlamp.obj
	addobject 0,0,0,256,256,256
	dc.w 1,0,$fff,4
	dc.l 116,61,0,116,-61,0,-116,-61,0,-116,61,0
	dc.w 2
	dc.w 4,0,1
	dc.w 0,0,0,6,0,$3d00,12,$7400,$3d00,18,$7400,0
	dc.w 4,0,1
	dc.w 18,0,0,12,0,$3d00,6,$7400,$3d00,0,$7400,0
	addobject 0,0,0,80,80,80,mcube.obj
	addobject 0,0,90,128,128,128,strlamp.obj
	addobject 0,0,0,256,256,256,house.obj
	addobject 0,0,0,256,256,256,house2.obj
	addobject 0,0,0,256,256,256,house3.obj
	addobject 0,0,0,256,256,256,house4.obj
	addobject 0,0,0,256,256,256,house5.obj
	addobject 0,0,0,256,256,256,bell.obj
	addobject 0,0,0,256,256,256
	dc.w 1,1,$ff,10
	dc.l -40,10,20,-20,-10,20,10,-10,20,20,0,20,50,10,20
	dc.l -40,10,-20,-20,-10,-20,10,-10,-20,20,0,-20,50,10,-20
	dc.w 9
	dc.w 4,0,0,1*6,0,0,0*6,0,0,5*6,0,0,6*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,6*6,0,0,7*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,7*6,0,0,8*6,0,0
	dc.w 4,0,0,4*6,0,0,3*6,0,0,8*6,0,0,9*6,0,0
	dc.w 4,0,0,0*6,0,0,4*6,0,0,9*6,0,0,5*6,0,0
	dc.w 4,0,0,2*6,0,0,3*6,0,0,0*6,0,0,1*6,0,0
	dc.w 3,0,0,3*6,0,0,4*6,0,0,0*6,0,0
	dc.w 4,0,0,5*6,0,0,8*6,0,0,7*6,0,0,6*6,0,0
	dc.w 3,0,0,5*6,0,0,9*6,0,0,8*6,0,0
	addobject 0,0,0,512,512,128
	dc.w 1,0,$fff,4
	dc.l 80,80,0,80,-80,0,-80,-80,0,-80,80,0
	dc.w 1
	dc.w 4,0,0
	dc.w 0,0,0,6,0,$7f00,12,$7f00,$7f00,18,$7f00,0
	addobject 0,0,0,256,256,256
	dc.w 1,0,$fff,8
	dc.l -5,-10,5,-5,-15,5,5,-15,5,5,-10,5
	dc.l -5,-10,-5,-5,-15,-5,5,-15,-5,5,-10,-5
	dc.w 5
	dc.w 4,0,0,1*6,0,0,0*6,0,0,4*6,0,0,5*6,0,0
	dc.w 4,0,0,2*6,0,0,1*6,0,0,5*6,0,0,6*6,0,0
	dc.w 4,0,0,3*6,0,0,2*6,0,0,6*6,0,0,7*6,0,0
	dc.w 4,0,0,0*6,0,0,1*6,0,0,2*6,0,0,3*6,0,0
	dc.w 4,0,0,7*6,0,0,6*6,0,0,5*6,0,0,4*6,0,0
	addobject 0,0,0,256,256,256,pcube.obj
	addobject 0,0,0,256,256,256,incubus.obj
	addobject 0,0,0,512,512,256,vase.obj
	addobject 0,0,0,256,256,256,lighthou.obj
	addobject 180,0,0,64,64,128,ripstone.obj
	addobject 0,0,0,64,64,64,tree.obj
	addobject 0,0,0,256,256,256,thouse.obj
	addobject 0,0,0,128,128,128,spher2.obj
	addobject 0,0,0,128,128,128,spher3.obj
	addobject 0,0,0,128,128,128,spher4.obj
	addobject 0,0,0,128,128,128,spher5.obj
	addobject 0,0,0,128,128,128,spher6.obj
	dc.l -1
	; numer,numtext,klatki,pauza,nazwa
anims:
	;incdir cc0:
	addanim 0,0,30-1,10,reklama.cmanim
	dc.l -1

	addmusic music2,mod.hawker.pak
	align 4,4
freemem:
	blk.l maxmem/4,0

	section typ,code_c
music1	blk.l 35000,0
musdata	incbin mod.war-cry.pak
	align 4,4
dumcop
	dc.w $1fc,0,$180,0,$1e4,0,-1,-2
coper
	dc.w $1fc,0,$8e,$2881,$90,$28c1
	dc.w $1e4,0,$92,$38,$94,$d0,$104,$24
	dc.w $140,0,$148,0,$150,0,$158,0,$160,0,$168,0,$170,0,$178,0
	dc.w -1,-2
coper1
	dc.w $106,0,$1fc,15,$1e4,$2100
	dc.w $8e,$2871,$90,$fec7,$92,$18,$94,$d0
	dc.w $102,$88aa,$104,$24,$106,$22,$10c,$ee
adekr1	dc.w $fc,0,$fe,0,$f8,0,$fa,0,$f4,0,$f6,0,$f0,0,$f2,0
	dc.w $ec,0,$ee,0,$e8,0,$ea,0
ekr1	dc.w $e4,0,$e6,0,$e0,0,$e2,0
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$2022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$4022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $106,$6022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $45df,-2,$100,$211
inslin1	blk.l linlen*15,0
	dc.w $fa01,-2,$108,48*7-8,$10a,48*7-8,$fd01,-2
	dc.w $100,$201,-1,-2
coper2
	dc.w $106,0,$1fc,15,$1e4,$2100
	dc.w $8e,$2871,$90,$fec7,$92,$18,$94,$d0
	dc.w $102,$88aa,$104,$24,$106,$22,$10c,$ee
adekr2	dc.w $fc,0,$fe,0,$f8,0,$fa,0,$f4,0,$f6,0,$f0,0,$f2,0
	dc.w $ec,0,$ee,0,$e8,0,$ea,0
ekr2	dc.w $e4,0,$e6,0,$e0,0,$e2,0
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$2022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0
	dc.w $106,$4022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $106,$6022
	dc.w $180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0
	dc.w $190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0
	dc.w $1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0
	dc.w $1b0,0,$1b2,0
	dc.w $45df,-2,$100,$211
inslin2	blk.l linlen*15,0
	dc.w $fa01,-2,$108,48*7-8,$10a,48*7-8,$fd01,-2
	dc.w $100,$201,-1,-2
	align 8,8
dispbuf	blk.l 1024,0
coperi
	dc.w $1fc,15,$1e4,$2100
	dc.w $8e,$387d,$90,$fdbc,$92,$18,$94,$b0
	dc.w $102,$ccbb,$104,$24,$10c,$ee
moduloi	dc.w $108,0,$10a,0
adekri	dc.w $e0,0,$e2,0,$e4,0,$e6,0,$e8,0,$ea,0,$ec,0,$ee,0
	dc.w $f0,0,$f2,0,$f4,0,$f6,0,$f8,0,$fa,0,$fc,0,$fe,0,$45df,-2
modei	dc.w $100,$211
	dc.w $fd01,-2,$100,$201,-1,-2
	align 8,8
iffbuf	blk.l 10*8*183,0
