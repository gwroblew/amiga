����                                        fg:	;Analyzer





freqband=	2


















partyfreq=	3







breit=		320
hoch=		256







sync=		500
inleng=		80
digitn=		256
digitbits=	8
partyn=		64
partybits=	6



WAIT1	MACRO
	IF freqband>2
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDIF
	IF freqband>3
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDIF
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDM
WAIT2	MACRO
	IF freqband>1
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDIF
	IF freqband>2
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDIF
	IF freqband>3
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDIF
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ENDM

CIAA=		$bfe001
CIAb=		$bfd000
PARPORT=	CIAA+$100
PARDIR=		CIAA+$300
BUTDIR=		CIAA+$200
CTRLDIR=	CIAB+$200
COPROC=		$dff000
POTGOR=		COPROC+$16
DMACON=		COPROC+$96
VPOSR=		COPROC+$4
DMACONR=	2
COP1LC=		COPROC+$80
COPJMP1=	COPROC+$88
BLTAMOD=	100
BLTBMOD=	98
BLTCMOD=	96
BLTAFWM=	68
BLTADAT=	116
BLTBDAT=	114
BLTCON0=	64
BLTSIZE=	88
BLTAPTL=	82
BLTAPTH=	72
BLTDPTH=	84
onsprite=	$8020
offsprite=	$0020

openlibrary=	-552
closelibrary=	-414
enable=		-126
disable=	-120
permit=		-138
forbid=		-132
allocmem=	-198
freemem=	-210
delay=		-198
close=		-36
open=		-30
read=		-42
write=		-48
input=		-54
output=		-60
ioerr=		-132
openscreen=	-198
closescreen=	-66
screentofront=	-252
screentoback=	-246
viewaddress=	-294
move=		-240
draw=		-246
setapen=	-342
setrast=	-234
text=		-60
loadrgb4=	-192
openfont=	-72
closefont=	-78
setfont=	-66
;
;
;
start:
	move.l	sp,savesp
	bsr	init
	move.l	#liste1,a6
	move.l	4(a6),a4
	jsr	(a4)
mainloop:

	lea	10(a6),a5
	move.w	8(a6),d7
callloop:
	move.l	(a5)+,a4
	jsr	(a4)
	dbf	d7,callloop
	bsr	keytest
	cmpi.b	#1,d0
	beq.s	links
	cmpi.b	#2,d0
	beq.s	rechts
	bra.s	mainloop

rechts:
	bsr	keytest
	tst.b	d0
	bne.s	rechts
	move.l	(a6),a6
	move.l	4(a6),a4
	jsr	(a4)
	bra.s	mainloop

links:
	bsr	keytest
	tst.b	d0
	bne.s	links
linkswait:
	
	bsr	keytest
	tst.b	d0
	beq.s	linkswait
	cmp.b	#2,d0
	beq.s	linksrechts
	moveq	#0,d4
links2:
	addq.l	#1,d4
	cmpi.l	#70000,d4
	bge.s	linkslong
	bsr	keytest
	tst.b	d0
	bne.s	links2
	tst.b	clearflag
	beq.s	mainloop
	movem.l	d7/a5/a6,-(a7)
	bsr	sumclear
	movem.l	(a7)+,d7/a5/a6
	bra.s	mainloop
linkslong:
	tst.w	saveenable
	beq.s	links
	bsr	save
	bra.s	links
linksrechts:
	bsr.s	keytest
	tst.b	d0
	bne.s	linksrechts
	move.l	(a6),a6
	move.l	4(a6),a4
	jsr	(A4)
	tst.b	flag
	bne.s	lr2
	bsr	fftlong
lr2:
	bsr	show
	bra.s	linkswait
savesp:	
	dc.l	0
	
	
	
liste1:
	dc.l	liste2
	dc.l	clean1
	dc.w	1
	dc.l	digit
	dc.l	show
	
liste2:
	dc.l	liste3
	dc.l	clean2
	dc.w	2
	dc.l	digit
	dc.l	fftlong
	dc.l	show
	
liste3:	
	dc.l	liste4
	dc.l	clean3
	dc.w	3
	dc.l	digit
	dc.l	fftlong
	dc.l	summ
	dc.l	show
	
liste4:	
	dc.l	liste1
	dc.l	clean4
	dc.w	2
	dc.l	digit
	dc.l	fftshort
	dc.l	color
	
	
keytest:
	moveq	#0,d0
	move.b	ciaa,d1
	andi.b	#$40,d1
	bne.s	noleft
	or.b	#1,d0
noleft:
	move.w	potgor,d1
	and.w	#$400,d1
	bne.s	noright
	or.b	#2,d0
noright:
	cmpi.b	#3,d0
	beq	kill
	rts

init:
	move.l	4,execbase
	move.l	#intuitionname,a1
	move.l	#intuibase,a5
	bsr	getlib
	move.l	#graphicsname,a1
	move.l	#graphicsbase,a5
	bsr	getlib
	move.l	#dosname,a1
	move.l	#dosbase,a5
	bsr	getlib
	bsr	makekrscreen
	bsr	makescreen
	move.l	graphicsbase,a6
	move.l	krrastport,a1
	moveq	#0,d0
	jsr	setrast(a6)
	move	#219,x0
	move	#128,y0
	move	#7,radius
	move	#100,s_rad
	move	#13,kr_anz
	move	#13,kr_col
	bsr	circle
	move	#60,x0
	move	#185,y0
	move	#5,radius
	move	#60,s_rad
	move	#10,kr_anz
	move	#23,kr_col
	bsr	circle
	move	#60,x0
	move	#50,y0
	move	#5,radius
	move	#45,s_rad
	move	#8,kr_anz
	move	#31,kr_col
	bsr	circle
	move.l	dosbase,a6
	jsr	input(a6)
	move.l	d0,dinput
	jsr	output(a6)
	move.l	d0,doutput
	move.l	execbase,a6
	jsr	forbid(a6)
	jsr	disable
	bsr	mauskill
	bsr	initpar
	move.l	#digitn-1,d7
	move.l	#digitbits-1,d4
	move.l	#shuffle,a0
	move.l	#spektrum,a1
	bsr	makeshuffle
	move.l	#partyn-1,d7
	move.l	#partybits-1,d4
	move.l	#sshuffle,a0
	move.l	#sspektrum,a1
	bsr	makeshuffle
	rts
	
execbase:	dc.l	0
intuibase:	dc.l	0
graphicsbase:	dc.l	0
dosbase:	dc.l	0
dinput:		dc.l	0
doutput:	dc.l	0
file:		dc.l	0
intuitionname:	dc.b	"intuition.library",0
graphicsname:	dc.b	"graphics.library",0
dosname:	dc.b	"dos.library",0
fontname:	dc.b	"topaz.font",0
waittext:	dc.b	"Bitte warten...",0
auttext:	dc.b	"Autoren: Danisch/Reinhardt/Schwaiger",0
		even
waitlen=	15
autlen=		36
font:		dc.l	0
screen:		dc.l	0
rastport:	dc.l	0
viewport:	dc.l	0
bitmap:		dc.l	0
bitplane1:	dc.l	0
bitplane2:	dc.l	0
bpr:		dc.w	0
view:		dc.l	0
krscreen:	dc.l	0
krrastport:	dc.l	0
krviewport:	dc.l	0
flag:		dc.w	0
clearflag:	dc.w	0
saveenable:	dc.w	0
digiflag:	dc.w	0
newscreen:	dc.w	0,0
		dc.w	320,256
		dc.w	2
		dc.b	0,1
		dc.w	0
		dc.w	$f
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
newkrscreen:
		dc.w	0,0
		dc.w	320,256
		dc.w	5
		dc.b	0,1
		dc.w	0
		dc.w	$f
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
textattr:
		dc.l	fontname
		dc.w	8
		dc.w	0
		dc.w	0
		
getlib:
	moveq	#0,d0
	move.l	execbase,a6
	jsr	openlibrary(a6)
	tst.l	d0
	beq	kill
	move.l	d0,(a5)
	rts
	
mauskill:
	btst	#0,vposr+1
	beq.s	mauskill
	move.w	#offsprite,dmacon
	rts
	
	
initpar:
	move.b	#0,pardir
	move.b	ctrldir,d0
	andi.b	#$fa,d0
	ori.b	#$04,d0
	move.b	d0,ctrldir
	andi.b	#$3f,butdir
	move.w	potgor,d0
	andi.w	#$f7ff,d0
	move.w	d0,potgor
	move.l	#ciab,a0
	move.l	#parport,a1
	moveq	#4,d0
	moveq	#$fa-256,d1
	moveq	#1,d2
	clr.w	digiflag
	or.b	d0,(a0)
	and.b	d1,(a0)
	move.b	d0,(a1)
ibusy1:
	and.b	d2,(a0)
	beq.s	ibusy1
	move.b	(a1),d5
	move.b	d0,(a1)
ibusy2:
	and.b	d2,(a0)
	bne.s	olddigit
	move.w	d2,digiflag
olddigit:
	rts
	
makeshuffle:
	moveq	#0,d0
shuffleloop:
	moveq	#0,d2
	move.l	d0,d1
	move.w	d4,d3
shiftloop:
	roxr	#1,d1
	roxl	#1,d2
	dbf	d3,shiftloop
	asl	#2,d2
	lea	(a1,d2.w),a2
	move.l	a2,(a0)+
	addq	#1,d0
	dbf	d7,shuffleloop
	rts
makekrscreen:
	move.l	#newkrscreen,a0
	move.l	intuibase,a6
	jsr	openscreen(a6)
	tst.l	d0
	beq	kill
	move.l	d0,krscreen
	move.l	d0,a0
	lea	84(a0),a1
	move.l	a1,krrastport
	lea	44(a0),a0
	move.l	a0,krviewport
	moveq	#32,d0
	move.l	#krcollist,a1
	move.l	graphicsbase,a6
	jsr	loadrgb4(a6)
	move.l	intuibase,a6
	jsr	viewaddress(a6)
	move.l	d0,view
	rts
krcollist:	blk.w	32,0


makescreen:
	move.l	#textattr,a0
	move.l	graphicsbase,a6
	jsr	openfont(a6)
	tst.l	d0
	beq	kill
	move.l	d0,font
	move.l	#newscreen,a0
	move.l	intuibase,a6
	jsr	openscreen(a6)
	tst.l	d0
	beq	kill
	move.l	d0,screen
	move.l	d0,a0
	lea	84(a0),a1
	move.l	a1,rastport
	lea	44(a0),a3
	move.l	a3,viewport
	move.l	4(a1),a2
	move.l	a2,bitmap
	move.l	8(a2),bitplane1
	move.l	12(a2),bitplane2
	move.w	(a2),bpr
	move.l	graphicsbase,a6
	move.l	font,a0
	move.l	rastport,a1
	jsr	setfont(a6)
	move.l	graphicsbase,a6
	move.l	viewport,a0
	move.l	#collist,a1
	moveq	#4,d0
	jsr	loadrgb4(a6)
	move.l	rastport,a1
	moveq	#100,d0
	moveq	#120,d1
	jsr	move(a6)
	move.l	#waittext,a0
	move.l	#waitlen,d0
	jsr	text(a6)
	move.l	rastport,a1
	moveq	#0,d0
	moveq	#25,d1
	jsr	move(a6)
	move.l	#auttext,a0
	move.l	#autlen,d0
	jsr	text(a6)
	rts
collist:
	dc.w	$444
	dc.w	$090
	dc.w	$009
	dc.w	0
	
kill:
	move.w	onsprite,dmacon
	move.l	screen,a0
	move.l	a0,d0
	tst.l	d0
	beq.s	noscreen
	move.l	intuibase,a6
	jsr	closescreen(a6)
noscreen:
	move.l	krscreen,a0
	move.l	a0,d0
	tst.l	d0
	beq.s	nokrscreen
	move.l	intuibase,a6
	jsr	closescreen(a6)
nokrscreen:
	move.l	execbase,a6
	jsr	enable(a6)
	jsr	permit(a6)
	move.l	font,a1
	move.l	a1,d0
	tst.l	d0
	beq.s	nofont
	move.l	graphicsbase,a6
	jsr	closefont(a6)
nofont:
	move.l	execbase,a6
	move.l	dosbase,a1
	move.l	a1,d0
	tst.l	d0
	beq.s	nodos
	jsr	closelibrary(a6)
nodos:
	move.l	graphicsbase,a1
	move.l	a1,d0
	tst.l	d0
	beq.s	nographics
	jsr	closelibrary(a6)
nographics:
	move.l	intuibase,a1
	move.l	a1,d0
	tst.l	d0
	beq.s	nointui
	jsr	closelibrary(a6)
nointui:
	move.l	savesp,sp
	rts
	
	
	
clean1:
	movem.l	d7/a5/a6,-(a7)
	move.l	intuibase,a6
	move.l	screen,a0
	jsr	screentofront(a6)
	bsr	mauskill
	move.w	#-1,saveenable
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#0,d0
	jsr	setrast(a6)
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#2,d0
	jsr	setapen(a6)
	tst.w	digiflag
	beq.s	clean1old
	move.l	#line1x,a5
	bsr	makeline
	move.l	#text1x,a5
	bsr	maketext
	bra.s	clean1cont
clean1old:
	move.l	#line1,a5
	bsr	makeline
	move.l	#text1,a5
	bsr	maketext
clean1cont:
	move.l	#oldpoint,a0
	move.w	#digitn/4-1,d0
	moveq	#-1,d1
clean1loop:
	move.l	d1,(a0)+
	dbf	d0,clean1loop
	move.l	#welle,feld
	move.w	#digitn-1,count
	move.w	#1,step
	move.l	#64,startpos
	move.w	#0,offset
	move.w	#0,clearflag
	movem.l	(a7)+,d7/a5-a6
	rts
line1x:
line1:
	dc.w	9
	dc.l	63,0,63,255
	dc.l	64,127,319,127
	dc.l	64,63,319,63
	dc.l	64,191,319,191
	dc.l	64,0,319,0
	dc.l	64,255,319,255
	dc.l	127,0,127,255
	dc.l	191,0,191,255
	dc.l	255,0,255,255
	dc.l	319,0,319,255
text1:
	dc.w	9
	dc.l	0,8,6,str1n3
	dc.l	0,67,6,str1n2
	dc.l	0,131,6,str1n1
	dc.l	0,195,6,str1n2
	dc.l	0,254,6,str1n3
	dc.l	44,235,2,str1n4
	dc.l	92,235,4,str1t
	dc.l	156,235,4,str1t+4
	dc.l	220,235,4,str1t+8
	dc.l	284,235,4,str1t+12
text1x:
	dc.w	9
	dc.l	0,8,6,str1n3
	dc.l	0,67,6,str1n2
	dc.l	0,131,6,str1n1
	dc.l	0,195,6,str1n2
	dc.l	0,254,6,str1n3
	dc.l	44,235,2,str1n4
	dc.l	92,235,4,str1t
	dc.l	156,235,4,str1t+4
	dc.l	220,235,4,str1t+8
	dc.l	284,235,4,str1t+12
str1n1:	dc.b	"0 Volt"
str1n2:	dc.b	"1.25 V"
str1n3:	dc.b	"2.5  V"
str1n4:	dc.b	"ms",0
str1x:
;if freqband<2
;	dc.b	" 1.3 2.5 3.8 5.1"
;endif
str1t:
;if freqband < 3
	dc.b	" 1.6 3.2 4.8 6.4"
;endif
;if freqband = 3
;	dc.b	" 2.1 4.2 6.3 8.4"
;endif
;if freqband > 3
;	dc.b	" 3.2 6.4 9.612.8"
;endif
	even
	
clean2:
	movem.l	d7/a5-a6,-(a7)
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#0,d0
	jsr	setrast(a6)
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#2,d0
	jsr	setapen(a6)
	move.l	#line2,a5
	bsr	makeline
	tst.w	digiflag
	beq.s	clean2old
	move.l	#scale2x,a5
	bsr	makescale
	move.l	#text2x,a5
	bsr	maketext
	bra.s	clean2cont
clean2old:
	move.l	#scale2,a5
	bsr	makescale
	move.l	#text2,a5
	bsr	maketext
clean2cont:
	move.l	#oldpoint,a0
	move.w	#digitn/4-1,d0
	move.l	#$e5e5e5e5,d1
clean2loop:
	move.l	d1,(a0)+
	dbf	d0,clean2loop
	move.l	#spektrum,feld
	move.w	#digitn/2-1,count
	move.w	#2,step
	move.l	#64,startpos
	move.w	#$1a,offset
	move.w	#0,clearflag
	movem.l	(a7)+,d7/a5/a6
	rts
line2:
	dc.w	6
	dc.l	63,1,63,230
	dc.l	63,230,319,230
	dc.l	64,57,319,57
	dc.l	64,115,319,115
	dc.l	64,172,319,172
	dc.l	64,1,319,1
	dc.l	319,1,319,230
scale2x:
;if freqband < 2
;	dc.w	-75,85,96,106,-116,126,137,147
;	dc.w	157,-167,177,187,197,207,-217,227
;	dc.w	237,247,257,-267,277,287,297,307
;	dc.w	-317,0
;endif
scale2:
;if freqband < 3
	dc.w	-76,88,101,113,-126,138,151,163
	dc.w	177,-189,203,215,228,240,-253,265
	dc.w	278,290,305,-319,0
;endif
;if freqband = 3
;	dc.w	-81,98,115,132,-149,166,183,200
;	dc.w	217,-234,251,268,285,302,-319,0
;endif
;if freqband > 3
;	dc.w	-90,-115,-140,-166,-191,-217,-243,-269
;	dc.w	-295,-319,0
;endif
text2:
	dc.w	6
	dc.l	0,255-8,3,str2n1
	dc.l	64,255-9,32,freq1
	dc.l	64,255-1,32,freq2
	dc.l	0,175,5,fdb1
	dc.l	0,118,5,fdb2
	dc.l	0,60,5,fdb3
	dc.l	0,8,5,fdb4
text2x:
	dc.w	6
	dc.l	0,255-8,3,str2n1
	dc.l	64,255-9,32,freq1
	dc.l	64,255-1,32,freq2
	dc.l	0,175,5,fdb1
	dc.l	0,118,5,fdb2
	dc.l	0,60,5,fdb3
	dc.l	0,8,5,fdb4
str2n1:	dc.b	"KHz",0
fdb1:	dc.b	"-6 dB",0
fdb2:	dc.b	" 0 dB",0
fdb3:	dc.b	" 3 dB",0
fdb4:	dc.b	" 6 dB",0
freq1x:
;if freqband < 2
;	dc.b	" 1    5    1    1    2    2"
;	dc.b	"           0    5    0    5"
;endif
freq1:
;if freqband < 3
	dc.b	" 1     5     1     1     2"
	dc.b	"             0     5     0"
;endif
;if freqband = 3
;	dc.b	"  1      5      1      1"
;	dc.b	"                0      5"
;endif
;if freqband > 3
;	dc.b	"   1  2  3  4  5  6  7  8  9  1"
;	dc.b	"                              0"
;endif
freq2 = freq1+32
freq2x = freq1x+32
	even
	
clean3:
	movem.l	d7/a5-a6,-(a7)
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#0,d0
	jsr	setrast(a6)
	move.l	graphicsbase,a6
	move.l	rastport,a1
	moveq	#2,d0
	jsr	setapen(a6)
	move.l	#line2,a5
	bsr	makeline
	tst.w	digiflag
	beq.s	clean3old
	move.l	#scale2x,a5
	bsr	makescale
	move.l	#text3x,a5
	bsr	maketext
	bra.s	clean3cont
clean3old:
	move.l	#scale2,a5
	bsr	makescale
	move.l	#text3,a5
	bsr	maketext
clean3cont:
	move.l	#oldpoint,a0
	move.w	#digitn/4-1,d0
	move.l	#$e5e5e5e5,d1
clean3loop:
	move.l	d1,(a0)+
	dbf	d0,clean3loop
	move.l	#sumshow,feld
	move.w	#digitn/2-1,count
	move.w	#2,step
	move.l	#64,startpos
	move.w	#$1a,offset
	move.w	#-1,clearflag
	bsr	sumclear
	movem.l	(a7)+,d7/a5-a6
	rts
text3:
	dc.w	5
	dc.l	0,255-8,3,str2n1
	dc.l	64,255-9,32,freq1
	dc.l	64,255-1,32,freq2
	dc.l	0,15,6,str3n1
	dc.l	0,35,6,str3n2
	dc.l	0,43,2,str3n3
text3x:
	dc.w	5
	dc.l	0,255-8,3,str2n1
	dc.l	64,255-9,32,freq1
	dc.l	64,255-1,32,freq2
	dc.l	0,15,6,str3n1
	dc.l	0,35,6,str3n2
	dc.l	0,43,2,str3n3
str3n1:	dc.b	"Profil",0
str3n2:	dc.b	"Faktor",0
str3n3:	dc.b	"2^",0
	even
	
shiftshow:
	move.l	rastport,a1
	moveq	#16,d0
	moveq	#43,d1
	move.l	graphicsbase,a6
	jsr	move(a6)
	move.l	shift,d0
	move.l	#zifflist,a0
	add.l	d0,a0
	add.l	d0,a0
	moveq	#2,d0
	move.l	rastport,a1
	jsr	text(a6)
	rts
zifflist:
	dc.b	"0 1 2 3 4 5 6 7 8 9 1011121314151617181920"
	dc.b	"2122232425262728293031",0
	even
clean4:
	movem.l	d7/a5/a6,-(a7)
	clr.w	saveenable
	move.l	krscreen,a0
	move.l	intuibase,a6
	jsr	screentofront(a6)
	bsr	mauskill
	move.l	#copfield,a0
	moveq	#31,d0
cl4l1:
	clr.l	(a0)+
	dbf	d0,cl4l1
	move.l	view,a0
	move.l	4(a0),a0
	move.w	8(a0),d6
	subq	#1,d6
	move.l	4(a0),a6
	move.l	#copfield,a5
cl4l2:
	move.l	(a6)+,d0
	swap	d0
	andi.l	#$fff,d0
	moveq	#1,d1
	and.w	d0,d1
	bne.s	nocopcol
	subi.w	#$180,d0
	blt.s	nocopcol
	cmpi.w	#$40,d0
	bge.s	nocopcol
	lsl.w	#1,d0
	move.l	a6,d1
	subq	#2,d1
	move.l	d1,(a5,d0)
nocopcol:
	dbf	d6,cl4l2
	moveq	#31,d0
	move.l	#copfield,a0
cl4l3:
	tst.l	(a0)+
	beq	kill
	dbf	d0,cl4l3
	move.l	#oldvalue,a0
	moveq	#7,d0
cl4l5:
	clr.l	(a0)+
	dbf	d0,cl4l5
	movem.l	(a7)+,d7/a5/a6
	rts
	
makeline:
	move.w	(a5)+,d5
lineloop:
	movem.l	(a5)+,d0/d1
	move.l	rastport,a1
	jsr	move(a6)
	movem.l	(a5)+,d0/d1
	move.l	rastport,a1
	jsr	draw(a6)
	dbf	d5,lineloop
	rts
	
makescale:
	moveq	#0,d0
	move.l	#233,d1
	move.w	(a5)+,d0
	bne.s	makescp
	rts
makescp:
	bpl.s	makescpl
	neg.w	d0
	move.w	#236,d1
makescpl:
	move.l	d0,d6
	move.l	rastport,a1
	jsr	move(a6)
	moveq	#0,d0
	move.w	d6,d0
	move.l	#231,d0
	move.l	rastport,a1
	jsr	draw(a6)
	bra.s	makescale
	
maketext:
	move.w	(a5)+,d5
textloop:
	move.l	rastport,a1
	movem.l	(a5)+,d0/d1
	jsr	move(a6)
	movem.l	(a5)+,d0/d1
	jsr	text(a6)
	dbf	d5,textloop
	rts
	
	
	
	
	
digit:
	move.l	#daten,a0
	move.w	#sync,d2
	move.w	#sync,d3
	move.w	#digitn-1,d4
	moveq	#4,d5
	moveq	#$fa-256,d6
	moveq	#1,d1
	move.l	#ciab,a1
	move.l	#parport,a2
	tst.w	digiflag
	beq	digold
	move.b	d0,(a2)
	move.b	(a2),d0
	nop
	nop
	nop
digit5loop:
	wait2
	move.b	d0,(a2)
	nop
	nop
	move.b	(a2),d0
	nop
	dbpl	d2,digit5loop
digit6loop:
	wait2
	move.b	d0,(a2)
	nop
	nop
	move.b	(a2),d0
	nop
	dbmi	d3,digit6loop
digit7loop:
	wait2
	move.b	d0,(a2)
	nop
	nop
	move.b	(a2),(a0)+
	dbf	d4,digit7loop
	bra	digend
digold:
	
digit1loop:
	
	or.b	d5,(a1)
	and.b	d6,(a1)
	wait1
	move.b	(a2),d0
	dbpl	d2,digit1loop
digit2loop:
	or.b	d5,(a1)
	and.b	d6,(a1)
	wait1
	move.b	(a2),d0
	dbmi	d3,digit2loop
digit3loop:
	
	or.b	d5,(a1)
	and.b	d5,(a1)
	wait1
	move.b	(a2),(a0)+
	dbf	d4,digit3loop
digend:
	move.l	#daten,a0
	move.l	#welle,a1
	move.l	#shuffle,a2
	move.w	#digitn-1,d1
digit4loop:
	
	moveq	#0,d0
	move.b	(a0)+,d0
	move.l	d0,(a1)+
	subi.w	#128,d0
	move.l	(a2)+,a3
	move.l	d0,(a3)
	dbf	d1,digit4loop
	clr.b	flag
	rts
	
	
	
	
fftshort:
	movem.l	d7/a5/a6,-(a7)
	move.l	#daten,a0
	move.l	#sshuffle,a1
	moveq	#partyn-1,d1
fftsl1:
	moveq	#0,d0
	move.b	(a0),d0
	addq.l	#partyfreq,a0
	subi.w	#128,d0
	move.l	(a1)+,a2
	move.l	d0,(a2)
	dbf	d1,fftsl1
	move.l	#sspektrum,a6
	move.l	#4*partyn,a0
	move.w	#partyn/2-1,sqcount
	bra.s	fft
fftlong:
	movem.l	d7/a5/a6,-(a7)
	move.l	#spektrum,a6
	move.l	#4*digitn,a0
	move.w	#digitn/2-1,sqcount
	move.b	#-1,flag
fft:
	moveq	#4,d7
	move.l	#sinustab,a3
fftloop1:
	moveq	#4,d6
fftfor:
	move.l	d6,d0
	subq	#4,d0
	asl.l	#5,d0
	asl.l	#4,d0
	divs	d7,d0
	cmpi.w	#256,d0
	bge.s	gross
	moveq	#0,d3
	move.w	(a3,d0.w),d3
	move.l	d3,a1
	move.w	#256,d1
	sub.w	d0,d1
	move.w	(a3,d1.w),d3
	move.l	d3,a2
	bra.s	endsin
gross:
	moveq	#0,d3
	move.l	d0,d1
	sub.w	#256,d1
	sub.w	(a3,d1.w),d3
	move.l	d3,a2
	move.w	#512,d1
	sub.w	d0,d1
	moveq	#0,d3
	move.w	(a3,d1.w),d3
	move.l	d3,a1
endsin:
	move.l	d6,a5
	subq	#4,a5
	move.l	a2,d3
	move.l	a1,d2
fftloop2:
	move.l	a5,a4
	add.l	d7,a4
	move.w	2(a6,a4),d5
	move.w	(a6,a4),d4
	move.w	d5,d1
	move.w	d4,d0
	muls	d3,d5
	muls	d3,d4
	muls	d2,d0
	muls	d2,d1
	sub.l	d0,d5
	add.l	d1,d4
	asr.l	#8,d5
	asr.l	#8,d4
	move.w	2(a6,a5),d1
	move.w	(a6,a4),d0
	sub.w	d5,d1
	sub.w	d4,d0
	move.w	d1,2(a6,a4)
	move.w	d0,(a6,a4)
	add.w	d5,2(a6,a5)
	add.w	d4,(a6,a5)
	add.l	d7,a5
	add.l	d7,a5
	cmp.l	a0,a5
	blt.s	fftloop2
	addq	#4,d6
	cmp.l	d7,d6
	ble	fftfor
	asl.l	#1,d7
	cmp.l	a0,d7
	blt	fftloop1
	move.w	sqcount,d7
	moveq	#5,d4
quadloop:
	move.w	(a6),d0
	move.w	2(a6),d1
	muls	d0,d0
	muls	d1,d1
	add.l	d1,d0
	move.w	#2,d6
	moveq	#15,d5
	move.l	d0,d2
	asr.l	#1,d2
	or.l	d0,d2
schaetzung:
	asl.l	#2,d2
	roxl.w	#1,d1
	dbf	d5,schaetzung
sqrtloop:
	tst.w	d1
	beq.s	sqrtend
	move.l	d0,d2
	divs	d1,d2
	add.w	d2,d1
	asr.w	#1,d1
	and.w	#$7fff,d1
	dbf	d6,sqrtloop
sqrtend:
	lsr.w	d4,d1
	andi.l	#$0000ffff,d1
	move.l	d1,(a6)+
	dbf	d7,quadloop
	movem.l	(a7)+,d7/a5/a6
	rts
sqcount:	dc.w	0
sinustab:	dc.w	000,003,006,009,013,016,019,022
		dc.w	025,028,031,034,038,041,044,047
		dc.w	050,053,056,059,062,065,068,071
		dc.w	074,077,080,083,086,089,092,095
		dc.w	098,101,104,107,109,112,115,118
		dc.w	121,123,126,129,132,134,137,140
		dc.w	142,145,147,150,152,155,157,160
		dc.w	162,165,167,170,172,174,177,179
		dc.w	181,183,185,188,190,192,194,196
		dc.w	198,200,202,204,206,207,209,211
		dc.w	213,215,216,218,220,221,223,224
		dc.w	226,227,229,230,231,233,234,235
		dc.w	237,238,239,240,241,242,243,244
		dc.w	245,246,247,248,248,249,250,250
		dc.w	251,252,252,253,253,254,254,254
		dc.w	255,255,255,256,256,256,256,256,256


show:
	movem.l	d7/a5/a6,-(a7)
	move.l	feld,a5
	move.l	#oldpoint,a4
	move.w	count,d7
	move.l	#coproc,a6
	move.l	startpos,d6
showloop:
	move.l	(a5)+,d4
	cmp.w	#$ff,d4
	ble.s	notgreat
	move.w	#$ff,d4
notgreat:
	not.b	d4
	sub.w	offset,d4
	bge.s	offsetok
	moveq	#0,d4
offsetok:
	moveq	#0,d3
	move.b	(a4),d3
	move.b	d4,(a4)+
	cmp.b	d3,d4
	beq.L	sloopend
showwait:
	btst	#6,dmaconr(a6)
	bne.s	showwait
	moveq	#0,d0
	move.w	d0,bltbmod(a6)
	move.l	#-1,bltafwm(a6)
	move.w	#$8000,bltadat(a6)
	move.w	bpr,bltcmod(a6)
	move.w	#-1,bltbdat(a6)
	move.l	bitplane1,a0
	move.w	d6,d0
	asr.w	#3,d0
	add.l	d0,a0
	move.w	d3,d0
	mulu	bpr,d0
	add.l	d0,a0
;	move.l	a0,bltcpth(a6)
;	move.l	a0,bltdpth(a6)
	moveq	#$f,d1
	and.w	d6,d1
	swap	d1
	asr.l	#4,d1
	swap	d1
	sub.w	d3,d4
	blt.s	rauf
	ori.l	#$0b0af041,d1
	bra.s	richtok
rauf:
	ori.l	#$0bcaf045,d1
	neg.b	d4
	subq.b	#1,d4
richtok:
	andi.w	#$00ff,d4
	move.l	d1,bltcon0(a6)
	moveq	#0,d0
	sub.w	d4,d0
	move.w	d0,bltaptl(a6)
	sub.w	d4,d0
	move.w	d0,bltaptl(a6)
	move.w	d4,d0
	addq.w	#1,d0
	asl.w	#6,d0
	ori.w	#2,d0
	move.w	d0,bltsize(a6)
sloopend:
	add.w	step,d6
	dbf	d7,showloop
sendwait:
	btst	#6,dmaconr(a6)
	bne.s	sendwait
	movem.l	(a7)+,d7/a5/a6
	rts
feld:		dc.l	0
count:		dc.w	0
step:		dc.w	0
startpos:	dc.l	0
offset:		dc.w	0

sumclear:
	movem.l	d0/a0/a1,-(a7)
	move.l	#sumfeld,a0
	move.l	#sumshow,a1
	move.w	#digitn/2-1,d0
sumclloop:
	clr.l	(a0)+
	clr.l	(a1)+
	dbf	d0,sumclloop
	move.l	#0,shift
	jsr	shiftshow
	movem.l	(a7)+,d0/a0/a1
	rts
summ:
	movem.l	d0-d3/d7/a0-a2/a5/a6,-(a7)
	move.l	#spektrum,a0
	move.l	#sumfeld,a1
	move.l	#sumshow,a2
	move.l	#digitn/2-1,d0
	move.l	shift,d1
	moveq	#0,d3
summloop:
	move.l	(a1),d2
	add.l	(a0)+,d2
	bcs.s	summalert
	move.l	d2,(a1)+
	lsr.l	d1,d2
	move.l	d2,(a2)+
	cmp.l	#230,d2
	blt.s	nobig
	moveq	#-1,d3
nobig:
	dbf	d0,summloop
	tst.l	d3
	beq.s	noscale
	addq.l	#1,shift
	cmp.l	#23,shift
	bge.s	summalert
	jsr	shiftshow
	bra.s	noscale
summalert:
	bsr	sumclear
noscale:
	movem.l	(a7)+,d0-d3/d7/a0-a2/a5/a6
	rts
shift:	dc.l	0


kr_num:	dc.w	0
circle:
	clr.l	d7
	clr.l	d1
	move	s_rad,d7
	clr.l	kr_num
loop:
	move.l	graphicsbase,a6
	move.l	krrastport,a1
	move	kr_col,d0
	sub	kr_num,d0
	jsr	setapen(a6)
	move.l	d7,d6
	subq	#1,d6
	clr.l	d4
	move.l	d7,d5
kr_l_1:
	cmp	#0,d6
	bge.s	kr_l_2
	subq	#1,d5
	add	d5,d6
	add	d5,d6
kr_l_2:
	move	x0,d0
	add	d4,d0
	move	y0,d1
	add	d5,d1
	move.l	krrastport,a1
	jsr	move(a6)
	move	x0,d0
	sub	d4,d0
	move	y0,d1
	add	d5,d1
	move.l	krrastport,a1
	jsr	draw(a6)		;tu
	move	x0,d0
	add	d4,d0
	move	y0,d1
	sub	d5,d1
	move.l	krrastport,a1
	jsr	move(a6)
	move	x0,d0
	sub	d4,d0
	move	y0,d1
	sub	d5,d1
	move.l	krrastport,a1
	jsr	draw(a6)		;tu
	move	x0,d0
	add	d5,d0
	move	y0,d1
	add	d4,d1
	move.l	krrastport,a1
	jsr	move(a6)
	move	x0,d0
	sub	d5,d0
	move	y0,d1
	add	d4,d1
	move.l	krrastport,a1
	jsr	draw(a6)		;tu
	move	x0,d0
	add	d5,d0
	move	y0,d1
	sub	d4,d1
	move.l	krrastport,a1
	jsr	move(a6)
	move	x0,d0
	sub	d5,d0
	move	y0,d1
	sub	d4,d1
	move.l	krrastport,a1
	jsr	draw(a6)		;tu
	sub	d4,d6
	sub	d4,d6
	subq	#1,d6
	addq	#1,d4
	cmp	d4,d5
	ble.s	kr_fin
	bra	kr_l_1
kr_fin:
	sub	radius,d7
	addq	#1,kr_num
	move	kr_num,d1
	cmp	kr_anz,d1
	bne	loop
	rts
	
x0:	dc.w	0
y0:	dc.w	0
radius:	dc.w	0
s_rad:	dc.w	0
kr_anz:	dc.w	0
kr_col:	dc.w	0


color:
	movem.l	d7/a5/a6,-(a7)
	move	#30,d7
	move.l	#sspektrum,a1
	move.l	#oldvalue,a2
	move.l	#maxlist,a3
	move.l	#rainbow+2,a4
	move.l	#copfield+4,a5
col:
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d6
	move.l	(a1)+,d1
	lsl	#1,d1
	and.l	#255,d1
	move.b	(a2),d2
	move.b	(a3)+,d3
	move.b	d3,d0
	lsr.b	#4,d0
	addq.b	#2,d0
	cmp.b	d3,d1
	blt.s	col1
	move.b	d3,d1
col1:
	cmp.b	d2,d1
	blt.s	col2
	add.b	d0,d1
	move.b	d1,d2
col2:
	sub.b	d0,d2
	bpl.s	col3
	moveq	#0,d2
col3:
	move.b	d2,(a2)+
	move.b	(a4)+,d1
	mulu	d2,d1
	move	d3,d4
	divu	d4,d1
	and.b	#$f,d1
	move.b	d1,d6
	lsl.w	#4,d6
	move.b	(a4),d1
	lsr.b	#4,d1
	mulu	d2,d1
	move	d3,d4
	divu	d4,d1
	and.b	#$f,d1
	or.b	d1,d6
	lsl.w	#4,d6
	move.b	(a4)+,d1
	andi.b	#$f,d1
	mulu	d2,d1
	move	d3,d4
	divu	d4,d1
	andi	#$f,d1
	or.b	d1,d6
	move.l	(a5)+,a6
	move.w	d6,(a6)
	dbra	d7,col
	movem.l	(a7)+,d7/a5/a6
	rts
	
rainbow:
	dc.w	$000,$f0f
	dc.w	$d0f,$b0f
	dc.w	$80f,$00f
	dc.w	$07f,$08f
	dc.w	$09f,$0af
	dc.w	$0bf,$0cf
	dc.w	$0df,$0ef
	dc.w	$0ff,$0fd
	dc.w	$0fb,$0f8
	dc.w	$0f0,$8f0
	dc.w	$bf0,$df0
	dc.w	$ff0,$fe0
	dc.w	$fd0,$fc0
	dc.w	$fb0,$fa0
	dc.w	$f90,$f80
	dc.w	$f70,$f00
maxlist:
	if partyfreq=1
	dc.b	55,30,24,22,22,21,20,19,19,18
	dc.b	18,17,16,15,14,13,11,10,10,9
	dc.b	8,8,8,8,8,8,8,7,7,7
	dc.b	7
	endif
	if partyfreq=2
	dc.b	55,30,24,22,22,21,20,19,19,18
	dc.b	18,17,16,15,14,13,11,10,10,9
	dc.b	8,8,8,8,8,8,8,7,7,7
	dc.b	7
	endif
	if partyfreq=3
	dc.b	63,32,26,23,22,21,20,19,19,18
	dc.b	18,18,18,17,17,17,17,17,16,16
	dc.b	16,16,16,16,16,15,15,15,15,15
	dc.b	15
	endif
	if partyfreq=4
	dc.b	63,32,26,23,22,21,20,19,19,18
	dc.b	18,18,18,17,17,17,17,17,16,16
	dc.b	16,16,16,16,16,15,15,15,15,15
	dc.b	15
	endif
	even
	
save:
	movem.l	d7/a5/a6,-(a7)
	move.l	screen,a0
	move.l	intuibase,a6
	jsr	screentoback(a6)
	move.l	krscreen,a0
	jsr	screentoback(a6)
	move.l	execbase,a6
	jsr	enable(a6)
	move.w	#onsprite,dmacon
	move.l	dosbase,a6
	bsr.s	dodos
	move.l	execbase,a6
	jsr	disable(a6)
	move.l	screen,a0
	move.l	intuibase,a6
	jsr	screentofront(a6)
	bsr	mauskill
	movem.l	(a7)+,d7/a5/a6
	rts
dodos:
	move.l	doutput,d1
	move.l	#dtext1,d2
	moveq	#dtl1,d3
	jsr	write(a6)
	move.l	dinput,d1
	move.l	#instring,d2
	moveq	#inleng,d3
	jsr	read(a6)
	cmp.l	#2,d0
	blt.L	dosx
	move.l	#instring,a0
	move.b	#0,-1(a0,d0)
	move.l	a0,d1
	move.l	#1006,d2
	jsr	open(a6)
	move.l	d0,file
	tst.l	d0
	beq.L	doserr
	move.l	file,d1
	move.l	#dfeld,d2
	move.l	#dflen,d3
	jsr	write(a6)
	cmp.l	#dflen,d0
	bne.L	doserr
	move.l	bitplane1,a4
	move.l	bitplane2,a5
	move.w	#hoch-1,d5
iffloop:
	movem.l	d5/a4/a5,-(a7)
	move.l	file,d1
	move.l	4(a7),d2
	move.l	#breit/8,d3
	jsr	write(a6)
	cmp.l	#breit/8,d0
	beq.s	iff1
	movem.l	(a7)+,d5/a4/a5
	bra.s	doserr
iff1:
	move.l	file,d1
	move.l	8(a7),d2
	move.l	#breit/8,d3
	jsr	write(a6)
	cmp.l	#breit/8,d0
	beq.s	iff2
	movem.l	(a7)+,d5/a4/a5
	bra.s	doserr
iff2:
	movem.l	(a7)+,d5/a4/a5
	add.l	#breit/8,a4
	add.l	#breit/8,a5
	dbf	d5,iffloop
	move.l	file,d1
	jsr	close(a6)
	clr.l	file
dosend:
	move.l	doutput,d1
	move.l	#dtext2,d2
	move.l	#dtl2,d3
	jsr	write(a6)
	move.l	#200,d1
	jsr	delay(a6)
dosx:
	rts
doserr:
	jsr	ioerr(a6)
	move.l	d0,dosern
	move.l	file,d1
	jsr	close(a6)
	bra	dodos
dosern:		dc.l	0
dtext1:		dc.b	"Filename :",0
dtext2:		dc.b	"Bitte warten,gleich geht s weiter",$0d,$0a
dtext3:
dtl1 = dtext2-dtext1
dtl2 = dtext3-dtext2
	even
fieldlen = breit*hoch/8
	
dfeld:
	dc.b	"FORM"
	dc.l	2*fieldlen+dflen-8
	dc.b	"ILBM"
	dc.b	"BMHD"
	dc.l	20
	dc.w	breit,hoch,0,0
	dc.b	2,0,0,0
	dc.w	0
	dc.b	$a,$b
	dc.w	breit,hoch
	dc.b	"BODY"
	dc.l	2*fieldlen
dfeldend:
dflen = dfeldend-dfeld
	
data
daten:		blk.b	digitn
welle:		blk.l	digitn
spektrum:	blk.l	digitn
sspektrum:	blk.l	partyn
oldpoint:	blk.b	digitn
shuffle:	blk.l	digitn
sshuffle:	blk.l	partyn
sumfeld:	blk.l	digitn/2
sumshow:	blk.l	digitn/2
instring:	blk.b	inleng+4
copfield:	blk.l	32
oldvalue:	blk.b	32
