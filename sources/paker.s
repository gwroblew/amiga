����  '�  1�  B��ܧ��ܧ��ܧ��ܧ��ܧ��ܧ	sax;;;;;;;;;;;;;;;;;;
	section mysz,code_p
select	macro
	moveq #\1,d0
	lea \2,a0
	bsr do_select
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
setwait	macro
	mpush d0-a6
	move.l whandle(a5),a0
	lea strzaw,a1
	moveq #16,d0
	moveq #16,d1
	moveq #0,d2
	moveq #0,d3
	callint -270
	mpop d0-a6
	endm
setnorm	macro
	mpush d0-a6
	move.l whandle(a5),a0
	lea strzan,a1
	moveq #16,d0
	moveq #16,d1
	moveq #0,d2
	moveq #0,d3
	callint -270
	mpop d0-a6
	endm
onmenu	macro
	openmenu menu0
	endm
offmenu	macro
	closemenu
	endm
openmenu macro
	lea \1,a1
	move.l whandle(a5),a0
	callint -264
	endm
closemenu macro
	move.l whandle(a5),a0
	callint -54
	endm
cfm	macro
	move.l whandle(a5),a0
	move.l #$ffff,d0
	callint -192
	endm
makemenu macro    ;<this menu,'Menu Title',next menu,left edge,enabled>
\1
	dc.l \3
	dc.w \4,0,\6,0,\5
	dc.l .\1title
	dc.l .\1item0
	dc.w 0,0,0,0
.\1title
	dc.b \2,0
	even
	endm
makeitem macro    ;<this item,'Item Name',next item,top,$flags,$ME,
                  ; 'Command Key',sub-item>
\1
	dc.l \3
	dc.w 0,\4,\9+$1b,10,\5
	dc.l \6
	dc.l .\1itext,0
	dc.b \7,0
	dc.l \8
	dc.w 0
.\1itext dc.b 31,0,0,0
	dc.w 3,0
	dc.l 0,.\1name,0
.\1name dc.b \2,0
	even
	endm
makesubitem macro    ;<this subitem,'SubItemName',next subitem,top
                     ; $flags,$ME,'CommandKey'>
\1
	dc.l \3
	dc.w 65,\4,80+$1b,10,\5
	dc.l \6
	dc.l .\1itext,0
	dc.b \7,0
	dc.l 0
	dc.w 0
.\1itext dc.b 31,0,0,0
	dc.w $13,0
	dc.l 0,.\1name,0
.\1name dc.b  \2,0
	even
	endm
proc	macro
	ifnc '\5',''
.lokstr\@
	blk.b \2+2,0
	even
	endc
	ifnc '\6',''
	dc.l 0,\5,\6
	else
	dc.l 0
	endc
	ifnc '\5',''
	dc.l .lokstr\@
	else
	ifnc '\2',''
	dc.l \2
	else
	dc.l 0
	endc
	endc
	ifnc '\4',''
	dc.w \4
	else
	dc.w -1
	endc
	ifc '\2',''
	dc.l 0
	endc
	ifnc '\2',''
	dc.w \2,\3
	endc
\1
	endm
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
callint	macro
	move.l intbase(a5),a6
	move.l a5,-(a7)
	jsr \1(a6)
	move.l (a7)+,a5
	endm
callgfx	macro
	move.l gfxbase(a5),a6
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
clsbox	macro
	pen #0
	move.l rastp(a5),a1
	move.l whandle(a5),a0
	move.w \1,d0
	move.w \2,d1
	move.w \3,d2
	move.w \4,d3
	callgfx -306
	endm
clswindow macro
	pen #0
	move.l rastp(a5),a1
	move.l whandle(a5),a0
	moveq #4,d0
	moveq #13,d1
	move.w 8(a0),d2
	move.w 10(a0),d3
	subq.w #6,d2
	subq.w #3,d3
	callgfx -306
	endm
drawmode macro
	move.l rastp(a5),a1
	move.w \1,d0
	callgfx -354
	endm
pen	macro
	move.l rastp(a5),a1
	move.w \1,d0
	callgfx -342
	endm
bpen	macro
	move.l rastp(a5),a1
	move.w \1,d0
	callgfx -348
	endm
plot	macro
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -240
	endm
draw	macro
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -246
	endm
line	macro
	move.w \4,-(a7)
	move.w \3,-(a7)
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -240
	move.l rastp(a5),a1
	move.w (a7)+,d0
	move.w (a7)+,d1
	callgfx -246
	endm
linec	macro
	move.l rastp(a5),a1
	move.w \5,d0
	callgfx -342
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -240
	move.l rastp(a5),a1
	move.w \3,d0
	move.w \4,d1
	callgfx -246
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
initgads macro
	move.w #0,numgads(a5)
	move.w #0,grougd(a5)
	move.l #\1,gadtab(a5)
	endm
savgads	macro
	lea savtab,a0
	moveq #\1,d0
	lsl.w #3,d0
	add.w d0,a0
	move.w numgads(a5),(a0)+
	move.w grougd(a5),(a0)+
	move.l gadtab(a5),(a0)+
	endm
loagads	macro
	lea savtab,a0
	moveq #\1,d0
	lsl.w #3,d0
	add.w d0,a0
	move.w (a0)+,numgads(a5)
	move.w (a0)+,grougd(a5)
	move.l (a0)+,gadtab(a5)
	endm
suwak	macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6+26,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	move.l #\5,(a0)+
	move.l #0,(a0)+
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \6+12,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2+1,(a0)+
	move.b \4,(a0)+
	lea \5_left,a1
	move.w #-1,-4(a1)
	move.w numgads(a5),-2(a1)
	move.l a1,(a0)+
	move.l #0,(a0)+
	ifnc '\8',''
	move.w \6+13,(a0)+
	move.w \7,(a0)+
	move.w \6+25,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2+2,(a0)+
	move.b \4,(a0)+
	lea \5_right,a1
	move.w #1,-4(a1)
	move.w numgads(a5),-2(a1)
	move.l a1,(a0)+
	move.l #0,(a0)+
	addq.w #3,numgads(a5)
	endm
suwaks	macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6+13,(a0)+
	move.w \7,(a0)+
	move.w \8-13,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	move.l #\5,(a0)+
	move.l #0,(a0)+
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \6+12,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2+1,(a0)+
	move.b \4,(a0)+
	lea \5_left,a1
	move.w #-1,-4(a1)
	move.w numgads(a5),-2(a1)
	move.l a1,(a0)+
	move.l #0,(a0)+
	ifnc '\8',''
	move.w \8-12,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -60(a0),(a0)
	move.l -56(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2+2,(a0)+
	move.b \4,(a0)+
	lea \5_right,a1
	move.w #1,-4(a1)
	move.w numgads(a5),-2(a1)
	move.l a1,(a0)+
	move.l #0,(a0)+
	addq.w #3,numgads(a5)
	endm
gadfirst macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	move.w d0,grougd(a5)
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -20(a0),(a0)
	move.l -16(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	lea \4,a1
	move.w numgads(a5),-4(a1)
	move.w numgads(a5),-2(a1)
	move.l a1,(a0)+
	move.l #.gadteg\@,(a0)
	addq.w #1,numgads(a5)
	bra.s .fuckyo\@
.gadteg\@ dc.b \5,0
	even
.fuckyo\@
	endm
gadgroup macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -20(a0),(a0)
	move.l -16(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	lea \4,a1
	move.w #0,-4(a1)
	move.w grougd(a5),-2(a1)
	move.l a1,(a0)+
	move.l #.gadtef\@,(a0)
	addq.w #1,numgads(a5)
	bra.s .gadsko\@
.gadtef\@ dc.b \5,0
	even
.gadsko\@
	endm
gadget	macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -20(a0),(a0)
	move.l -16(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	lea \4,a1
	move.l #0,-4(a1)
	move.l a1,(a0)+
	move.l #.gadtex\@,(a0)
	addq.w #1,numgads(a5)
	bra.s .gadkup\@
.gadtex\@ dc.b \5,0
	even
.gadkup\@
	endm
gadset	macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -20(a0),(a0)
	move.l -16(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	move.l #\4,(a0)+
	move.l #.gadteq\@,(a0)
	addq.w #1,numgads(a5)
	bra.s .gadkuq\@
.gadteq\@ dc.b \5,0
	even
.gadkuq\@
	endm
gadges	macro
	move.l gadtab(a5),a0
	move.w numgads(a5),d0
	mulu #20,d0
	add.l d0,a0
	ifnc '\8',''
	move.w \6,(a0)+
	move.w \7,(a0)+
	move.w \8,(a0)+
	move.w \9,(a0)+
	endc
	ifc '\8',''
	move.l -20(a0),(a0)
	move.l -16(a0),4(a0)
	add.w \6,(a0)+
	add.w \7,(a0)+
	add.w \6,(a0)+
	add.w \7,(a0)+
	endc
	move.w \1,(a0)+
	move.b \2,(a0)+
	move.b \3,(a0)+
	lea \4,a1
	move.l a1,(a0)+
	move.l #.gadtes\@,(a0)
	addq.w #1,numgads(a5)
	bra.s .gadkus\@
.gadtes\@ dc.b \5,0
	even
.gadkus\@
	endm
frame	macro
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -240
	move.l rastp(a5),a1
	move.w \3,d0
	move.w \2,d1
	callgfx -246
	move.l rastp(a5),a1
	move.w \3,d0
	move.w \4,d1
	callgfx -246
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \4,d1
	callgfx -246
	move.l rastp(a5),a1
	move.w \1,d0
	move.w \2,d1
	callgfx -246
	endm
box3d	macro
	move.w \4,-(a7)
	move.w \3,-(a7)
	move.w \2,-(a7)
	move.w \1,-(a7)
	pen #1
	frame (a7),2(a7),4(a7),6(a7)
	addq.w #1,(a7)
	addq.w #1,2(a7)
	addq.w #1,4(a7)
	addq.w #1,6(a7)
	pen #2
	frame (a7),2(a7),4(a7),6(a7)
	addq.l #8,a7
	endm
prival	macro
	move.l \3,d0
	bsr privalp
	move.w \1,d0
	move.w \2,d1
	plot d0,d1
	move.l strval(a5),a0
	tst.b (a0)
	beq.s .dalpv\@
	moveq #-1,d0
.strlev\@
	addq.l #1,d0
	tst.b (a0)+
	bne.s .strlev\@
	move.l strval(a5),a0
	move.l rastp(a5),a1
	callgfx -60
.dalpv\@
	endm
print	macro
	move.w \1,d0
	move.w \2,d1
	plot d0,d1
	lea .stpr\@,a0
	tst.b (a0)
	beq.s .dalpp\@
	moveq #-1,d0
.strlen\@
	addq.l #1,d0
	tst.b (a0)+
	bne.s .strlen\@
	lea .stpr\@,a0
	move.l rastp(a5),a1
	callgfx -60
	bra.s .dalpp\@
.stpr\@
	dc.b \3,0
	even
.dalpp\@
	endm
printc	macro
	lea .stpc\@,a0
	tst.b (a0)
	beq.s .dalpc\@
	moveq #-1,d0
.strlec\@
	addq.l #1,d0
	tst.b (a0)+
	bne.b .strlec\@
	move.l d0,-(a7)
	lsl.w #3,d0
	sub.w #420,d0
	neg.w d0
	lsr.w #1,d0
	move.w \1,d1
	plot d0,d1
	move.l (a7)+,d0
	lea .stpc\@,a0
	move.l rastp(a5),a1
	callgfx -60
	bra.s .dalpc\@
.stpc\@
	dc.b \2,0
	even
.dalpc\@
	endm

start
	mpush d1-a6
	bsr prog_start
	bsr vint_start
	bsr.s program
	bsr vint_end
	bsr prog_end
	mpop d1-a6
	moveq #0,d0
	rts

program
	lea vars,a5
	bsr initlibs
	bsr drawwindow

	bsr defdraw
	onmenu
	callint -342

	select 1,0

	move.l whandle(a5),a0
	callint -72
	callint -336
	rts

	makemenu menu0," Set Models ",menu1,10,1,96
	makeitem .menu0item0,"Pictures",.menu0item1,0,$56,0,'P',0,100
	makeitem .menu0item1,"Animation",.menu0item2,10,$56,0,'M',0,100
	makeitem .menu0item2,"Sound",.menu0item3,20,$56,0,'S',0,100
	makeitem .menu0item3,"---------------",.menu0item4,30,$12,0,0,0,100
	makeitem .menu0item4,"Iconify",.menu0item5,40,$56,0,'I',0,100
	makeitem .menu0item5,"About",.menu0item6,50,$56,0,'A',0,100
	makeitem .menu0item6,"Quit",0,60,$56,0,'Q',0,100
	makemenu menu1," Edit ",0,106,1,48
	makeitem .menu1item0,"Soundtrack",0,0,$56,0,'T',0,100

menu_tab
	dc.l models,edits
models
	dc.l picmodel,animmodel,soundmodel,-1,iconify,about,quit,-1
edits
	dc.l soundtrack

soundtrack:
	clswindow
	initgads pomgads
	gadget #$200,#0,#3,.exit,"Exit",#360,#140,#400,#154
	gadget #$200,#0,#3,.selec1,"1",#10,#30,#36,#43
	gadget #$200,#0,#3,.selec2,"2",#0,#20
	gadget #$200,#0,#3,.selec3,"3",#0,#20
	gadget #$200,#0,#3,.selec4,"4",#0,#20
	gadget #$200,#0,#3,.selec5,"5",#0,#20
	gadset #$200,#0,#$f1,.inpfre1,"",#360,#30,#400,#43
	gadset #$200,#0,#$f1,.inpfre2,"",#0,#20
	gadset #$200,#0,#$f1,.inpfre3,"",#0,#20
	gadset #$200,#0,#$f1,.inpfre4,"",#0,#20
	gadset #$200,#0,#$f1,.inpfre5,"",#0,#20
	gadset #$200,#0,#$f1,.inpfra1,"",#300,#30,#356,#43
	gadset #$200,#0,#$f1,.inpfra2,"",#0,#20
	gadset #$200,#0,#$f1,.inpfra3,"",#0,#20
	gadset #$200,#0,#$f1,.inpfra4,"",#0,#20
	gadset #$200,#0,#$f1,.inpfra5,"",#0,#20
	gadset #$200,#0,#$f0,.input1,"",#40,#30,#296,#43
	gadset #$200,#0,#$f0,.input2,"",#0,#20
	gadset #$200,#0,#$f0,.input3,"",#0,#20
	gadset #$200,#0,#$f0,.input4,"",#0,#20
	gadset #$200,#0,#$f0,.input5,"",#0,#20

	bsr gadredraw
	select 0,0
	bra defdraw
	proc .exit
	move.l #$face0000,d0
	rts
	proc .selec1
	rts
	proc .selec2
	rts
	proc .selec3
	rts
	proc .selec4
	rts
	proc .selec5
	rts
	proc .inpfre1,2,0,,8,24
	rts
	proc .inpfre2,2,0,,8,24
	rts
	proc .inpfre3,2,0,,8,24
	rts
	proc .inpfre4,2,0,,8,24
	rts
	proc .inpfre5,2,0,,8,24
	rts
	proc .inpfra1,5,0,,1,32000
	rts
	proc .inpfra2,5,0,,1,32000
	rts
	proc .inpfra3,5,0,,1,32000
	rts
	proc .inpfra4,5,0,,1,32000
	rts
	proc .inpfra5,5,0,,1,32000
	rts
	proc .input1,124,0,,1
	rts
	proc .input2,124,0,,1
	rts
	proc .input3,124,0,,1
	rts
	proc .input4,124,0,,1
	rts
	proc .input5,124,0,,1
	rts


picmodel:
	clswindow
	initgads pomgads
	gadget #$200,#0,#3,.exit,"Exit",#360,#140,#400,#154
	gadges #$100,#0,#5,filters,"Filters Off|DCT Filter|Smooth|",#10,#15,#110,#26
	gadges #$100,#0,#5,fillev,"1|2|3|4|5|6|7|8|9|",#174,#15,#194,#26
	gadges #$100,#0,#5,colmod,"RGB|YUV|256|",#90,#35,#140,#46
	gadges #$100,#0,#5,scalrx,"1:1|1:2|1:4|1:8|1:16|",#80,#65,#120,#76
	gadges #$100,#0,#5,scalgx,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalbx,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalry,"1:1|1:2|1:4|1:8|1:16|",#150,#65,#190,#76
	gadges #$100,#0,#5,scalgy,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalby,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,monofl,"Color|Mono|",#10,#123,#70,#134
	gadges #$100,#0,#5,mode,"Video Only|Audio Only|Video+Audio|",#80,#123,#190,#134
	gadges #$100,#0,#5,piccomp,"Hadamard Transform|Vector Quantization|",#10,#141,#190,#152

	savgads 1
	initgads posgads
	gadget #$200,#0,#3,.exit,"Exit",#360,#140,#400,#154
	gadges #$100,#0,#5,filters,"Filters Off|DCT Filter|Smooth|",#10,#15,#110,#26
	gadges #$100,#0,#5,fillev,"1|2|3|4|5|6|7|8|9|",#174,#15,#194,#26
	gadges #$100,#0,#5,colmod,"RGB|YUV|256|",#90,#35,#140,#46
	gadges #$100,#0,#5,scalrx,"1:1|1:2|1:4|1:8|1:16|",#80,#65,#120,#76
	gadges #$100,#0,#5,scalgx,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalbx,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalry,"1:1|1:2|1:4|1:8|1:16|",#150,#65,#190,#76
	gadges #$100,#0,#5,scalgy,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,scalby,"1:1|1:2|1:4|1:8|1:16|",#0,#20
	gadges #$100,#0,#5,monofl,"Color|Mono|",#10,#123,#70,#134
	gadges #$100,#0,#5,mode,"Video Only|Audio Only|Video+Audio|",#80,#123,#190,#134
	gadges #$100,#0,#5,piccomp,"Hadamard Transform|Vector Quantization|",#10,#141,#190,#152
	gadges #$100,#0,#5,qnumvecs,"8|16|32|64|128|256|512|1024|",#360,#15,#400,#26

	savgads 2
	move.w piccomp-4,d0
	addq.w #1,d0
	lea savtab,a0
	lsl.w #3,d0
	add.w d0,a0
	move.w (a0)+,numgads(a5)
	move.w (a0)+,grougd(a5)
	move.l (a0)+,gadtab(a5)
	bsr .drawext
	bsr gadredraw
	pen #1
	line #200,#14,#200,#154
	line #10,#30,#200,#30
	line #10,#50,#200,#50
	line #10,#120,#200,#120
	print #120,#24,"Level:"
	print #10,#44,"Colors:"
	print #70,#59,"Scaling:"
	print #10,#74,"Y-R   X:"
	print #10,#94,"U-G   X:"
	print #10,#114,"V-B   X:"
	print #130,#74,"Y:"
	print #130,#94,"Y:"
	print #130,#114,"Y:"
	move.w piccomp-4,.oldcomp

	select 0,.chamods
	bra defdraw
	proc .exit
	move.l #$face0000,d0
	rts
.oldcomp dc.w 0
.drawext
	clsbox #201,#14,#414,#156
	pen #1
	tst.w piccomp-4
	bne.w .dradov
	rts
.dradov
	print #210,#24,"Number of vectors:"
	rts
.chamods
	push d0
	move.w piccomp-4,d0
	cmp.w .oldcomp,d0
	beq.s .sameis
	move.w d0,.oldcomp
	addq.w #1,d0
	lea savtab,a0
	lsl.w #3,d0
	add.w d0,a0
	move.w (a0)+,numgads(a5)
	move.w (a0)+,grougd(a5)
	move.l (a0)+,gadtab(a5)
	bsr .drawext
	bsr gadredraw
.sameis
	pop d0
	rts

	proc filters,0,2
	rts
	proc fillev,0,8
	rts
	proc colmod,0,2
	rts
	proc scalrx,0,4
	rts
	proc scalgx,0,4
	rts
	proc scalbx,0,4
	rts
	proc scalry,0,4
	rts
	proc scalgy,0,4
	rts
	proc scalby,0,4
	rts
	proc monofl,0,1
	rts
	proc mode,0,2
	rts
	proc piccomp,0,1
	rts
	proc qnumvecs,0,7
	rts

animmodel:
	rts

soundmodel:
	clswindow
	initgads pomgads
	gadget #$200,#0,#3,.exit,"Exit",#360,#140,#400,#154
	gadges #$100,#0,#5,snumvecs,"8|16|32|64|128|256|512|1024|",#360,#15,#400,#26
	gadges #$100,#0,#5,slenvec,"2|4|6|8|10|12|14|16|",#0,#20
	gadges #$100,#0,#5,serrlev,"5|10|15|20|25|",#0,#20
	gadges #$100,#0,#5,schunk,"8|16|32|64|128|256|",#0,#20
	gadges #$100,#0,#5,sdctlen,"8|16|32|64|128|256|512|1024|",#0,#20
	gadges #$100,#0,#5,sdctcode,"Differential Coding|Vector Quantization|",#210,#121,#400,#132
	gadges #$100,#0,#5,smode,"Mono|Stereo|",#10,#123,#70,#134
	gadges #$100,#0,#5,soundcomp,"Vector Quantization|DCT Transform|",#10,#141,#190,#152

	savgads 1
	pen #1
	line #200,#14,#200,#154
	line #200,#90,#405,#90
	line #10,#120,#200,#120
	print #210,#24,"Number of vectors:"
	print #210,#44,"Lenght of vector:"
	print #210,#64,"Error level [%]:"
	print #210,#84,"Chunk size [kB]:"
	print #210,#104,"DCT block length:"
	bsr gadredraw
	select 0,0
	bra defdraw
	proc .exit
	move.l #$face0000,d0
	rts

	proc schunk,0,5
	rts
	proc snumvecs,0,7
	rts
	proc slenvec,0,7
	rts
	proc serrlev,0,4
	rts
	proc soundcomp,0,1
	rts
	proc smode,0,1
	rts
	proc sdctlen,0,7
	rts
	proc sdctcode,0,1
	rts


	proc goforit
	rts

	proc inpfile,124,0,,1
	rts

	proc outfile,124,0,,1
	rts

	proc inpsele
	rts

	proc outsele
	rts

	proc firframe,5,0,,1,32000
	rts

	proc lasframe,5,0,,1,32000
	rts

	proc getmodel,124,0,,1
	rts

	proc loadmodel
	rts

	proc savemodel
	rts

about:
	clswindow
	initgads pomgads
	gadget #$100,#0,#3,.exit,"Exit",#170,#130,#250,#144
	bsr gadredraw
	pen #1
	printc #30,"Digital Movies Compressor"
	printc #40,"written by Grzegorz Wroblewski"
	printc #50,"(c) 1995"
	printc #60,"Not allowed for commercial use!"
	printc #70,"Sources of player are available"
	printc #80,"for 50 USD at following address:"
	printc #90,"58 - 105 Swidnica"
	printc #100,"str. Warynskiego 21/2"
	printc #110,"phone: (+48)-(74)-53-16-86"
	printc #120,"ver. 1.00b     20.01.1995"
	select 0,0
	bra defdraw
	proc .exit
	move.l #$face0000,d0
	rts

iconify
	move.l whandle(a5),a0
	callint -72
	lea .newwin(pc),a0
	callint -204
	move.l d0,whandle(a5)
	move.l d0,a0
	move.l 50(a0),rastp(a5)
	initgads pomgads
	gadget #$100,#3,#3,.backto,"DMC!",#60,#14,#210,#26
	bsr gadredraw
.mainloop
	move.l whandle(a5),a0
	move.l $56(a0),a0
	callexec -372
	tst.l d0
	beq.w .wait
	move.l d0,a1
	cmp.l #$200,$14(a1)
	beq.s .end
	cmp.l #8,$14(a1)
	beq.s .mous
	bra.s .mainloop
.mous
	btst #6,$bfe001
	bne.s .mainloop
	bsr gadtest
	bra.s .mainloop
.wait
	moveq #0,d0
	moveq #0,d1
	move.l whandle(a5),a1
	move.l $56(a1),a0
	move.b 15(a0),d1
	bset d1,d0
	callexec -318
	bra.w .mainloop
	proc .backto
	addq.l #4,a7
.end
	move.l whandle(a5),a0
	callint -72
	bsr openwindow
	bra defdraw
.newwin	dc.w 0,20,270,30,$102
	dc.l $608,$100e,0,0,.title,0,0
	dc.w 20,20,270,30,1
.title	dc.b "Digital Movies Compressor",0
	even

	proc quit,,,"Q"
	move.l #$face0000,d0
	rts

drawwindow
	bsr openwindow
	initgads defgads

	gadset #$200,#0,#$f0,inpfile,"",#140,#20,#310,#34
	gadset #$200,#0,#$f0,outfile,"",#0,#20
	gadget #$200,#0,#3,inpsele,"Select",#320,#20,#400,#34
	gadget #$200,#0,#3,outsele,"Select",#0,#20
	gadset #$200,#0,#$f1,firframe,"",#120,#60,#190,#74
	gadset #$200,#0,#$f1,lasframe,"",#210,#0
	gadset #$200,#0,#$f0,getmodel,"",#80,#80,#300,#94
	gadget #$200,#0,#3,loadmodel,"Load",#310,#80,#350,#94
	gadget #$200,#0,#3,savemodel,"Save",#360,#80,#400,#94
	gadget #$200,#0,#3,goforit,"Start",#20,#140,#120,#154
	gadget #$200,#0,#3,quit,"Quit",#300,#140,#400,#154

;	gadfirst #0,#1,#$12,sele70,"",#40,#89,#56,#97
;	gadgroup #0,#1,#$12,sele71,"",#45,#0
;	gadgroup #0,#1,#$12,sele72,"",#45,#0
;	gadgroup #0,#1,#$12,sele73,"",#45,#0
;	gadget #0,#2,#$22,onoff4,"",#0,#14
;	suwaks #0,#3,#$6a,#$82,suw10,#30,#190-9,#172,#201-9
;	gadget #$200,#0,#3,dofad4,"F",#184-20,#163,#184,#174

;	gadget #10,#20,#30,#30,#0,#1,#$10,#selec0,""
;	gadhor #30,#0,#1,#$10,#selec1,""
;	gadhor #30,#0,#2,#$20,#wlowyl,""
;	gadget #100,#20,#180,#31,#0,#3,#$48,#suwproc,""
;	gadget #190,#20,#200,#31,#0,#4,#$80,#gadpro1,""
;	gadget #210,#20,#220,#31,#0,#5,#$80,#gadpro2,""
;	gadget #10,#40,#100,#50,#$100,#0,#1,#0,"Mysz"
;	gadget #10,#60,#100,#80,#$300,#0,#5,#zwierz,"Zwierz|Typowo|Myszowy|"
	savgads 0
	rts
defdraw
	loagads 0
	clswindow
	bsr gadredraw
	pen #1
	print #10,#29,"Input filename:"
	print #10,#49,"Output filename:"
	print #10,#69,"First frame:"
	print #220,#69,"Last frame:"
	print #10,#89,"Model:"
	print #10,#109,"Original lenght:"
	print #10,#119,"Crunched lenght:"
	print #260,#114,"Ratio:"
	print #10,#132,"Status: ready.                    "
	rts

;gadget	coltext.b+colin.b,graph.b,type.b,data.l,text.l,x1.w,y1.w,x2.w,y2.w
;type	bit0-text; bit1-proc; bit2-switch; bit3-nopress; bit4-concat;
;	bit5-on/off; bit6-suwak, bit5-eachproc; bit7-gadsuw;
;	$f0 - input string, $f1 - input number

konvkey
	move.w d0,.event+6
	and.w #$3ff,d1
	move.w d1,.event+8
	sub.l a1,a1
	callexec -$126
	lea .port,a1
	move.l d0,16(a1)
	callexec -$162
	lea .inireq,a1
	moveq #0,d1
	lea .tradev,a0
	moveq #-1,d0
	callexec -444
	lea .port,a1
	callexec -$168
	move.l .inireq+20,a6
	lea .event,a0
	lea .puffer,a1
	moveq #32,d1
	sub.l a2,a2
	jsr -48(a6)
	move.l d0,-(a7)
	lea .inireq,a1
	callexec -450
	moveq #0,d0
	tst.l (a7)+
	beq.s .nokey
	move.b .puffer,d0
.nokey
	rts
.port	blk.l 16,0
.inireq	blk.l 16,0
.tradev	dc.b "console.device",0,0
.puffer	blk.l 8,0
.event	dc.l 0
	dc.w $100,0,0,0,0,0,0,0,0

gadktest
	move.w numgads(a5),d7
	bne.b .moztes
	rts
.moztes
	subq.w #1,d7
	move.l gadtab(a5),a0
	lea gadgets,a1
.peszuk
	move.l 12(a0),a2
	cmp.w -6(a2),d0
	beq.b gadfound
	lea 20(a0),a0
	dbf d7,.peszuk
	rts
gadtest
	move.w numgads(a5),d7
	bne.b .moztes
	rts
.moztes
	move.l whandle(a5),a0
	move.w 12(a0),d1
	move.w 14(a0),d0
	subq.w #1,d7
	move.l gadtab(a5),a0
	lea gadgets,a1
.peszuk
	moveq #0,d2
	moveq #0,d3
	cmp.w (a0),d0
	sle d3
	add.w d3,d2
	cmp.w 4(a0),d0
	sge d3
	add.w d3,d2
	cmp.w 2(a0),d1
	sle d3
	add.w d3,d2
	cmp.w 6(a0),d1
	sge d3
	add.w d3,d2
	tst.w d2
	beq.b gadfound
	lea 20(a0),a0
	dbf d7,.peszuk
	rts
gadfound
	move.l a0,-(a7)
	movem.w (a0),d0-d3
	moveq #0,d5
	move.b 10(a0),d5
	lsl.w #4,d5
	movem.l 0(a1,d5.w),a2-a3
	btst #3,11(a0)
	bne.s .nopres
	movem.l d0-d3/a2,-(a7)
	jsr (a3)
	movem.l (a7)+,d0-d3/a2
.wmou
	btst #6,$bfe001
	beq.w .wmou
	move.l (a7),a0
.nopres
	move.b 11(a0),d4
	and.b #$f0,d4
	cmp.b #$f0,d4
	bne.w .noinpga
	jsr (a2)
	bsr cursneg
	move.l (a7),a0
	move.l a0,cursinp
	move.w 6(a0),d0
	sub.w 2(a0),d0
	subq.w #8,d0
	lsr.w #1,d0
	add.w 2(a0),d0
	move.w d0,cursposy
	move.w (a0),d0
	addq.w #6,d0
	move.w d0,cursposx
	move.l whandle(a5),a1
	move.w 14(a1),d0
	sub.w cursposx,d0
	bpl.s .nominu
	moveq #0,d0
.nominu
	lsr.w #3,d0
	move.w 4(a0),d1
	sub.w (a0),d1
	sub.w #12,d1
	lsr.w #3,d1
	subq.w #1,d1
	cmp.w d1,d0
	ble.s .nowiek
	move.w d1,d0
.nowiek
	move.l 12(a0),a1
	move.l -10(a1),a2
	add.w -2(a1),a2
	add.w d0,a2
	tst.b (a2)
	bne.s .mozbyp
.szufip
	tst.b (a2)
	bne.s .gotsom
	subq.l #1,a2
	subq.w #1,d0
	bpl.s .szufip
	moveq #0,d0
	bra.s .mozbyp
.gotsom
	move.w d0,d1
	add.w -2(a1),d1
	addq.w #1,d1
	cmp.w -4(a1),d1
	beq.s .mozbyp
	addq.w #1,d0
.mozbyp
	move.w d0,curpos
	lsl.w #3,d0
	add.w d0,cursposx
	bsr cursneg
	bra.w .judraw
.noinpga
	btst #7,11(a0)
	beq.w .nosuga
	jsr (a2)
	move.l (a7),a0
	move.l 12(a0),a1
	move.w -2(a1),d0
	mulu #20,d0
	move.l gadtab(a5),a0
	add.l d0,a0
	move.w -4(a1),d0
	move.l 12(a0),a1
	move.w -4(a1),d1
	add.w d0,d1
	bpl.w .jesplu
	moveq #0,d1
.jesplu
	cmp.w -2(a1),d1
	ble.w .jesmni
	move.w -2(a1),d1
.jesmni
	move.w d1,-4(a1)
	lea gadgets,a1
	bsr gaddraw
	bra.w .judraw
.nosuga
	btst #6,11(a0)
	beq.w .nosuwa
.pesuwa
	move.l $dff004,d0
	and.l #$1ff00,d0
	cmp.l #$13600,d0
	bne.b .pesuwa
	move.l whandle(a5),a1
	move.w 14(a1),d4
	move.w (a0),d0
	move.w 4(a0),d2
	add.w #4+9,d0
	sub.w #4+9,d2
	sub.w d0,d2
	sub.w d0,d4
	bpl.w .jemnie
	moveq #0,d4
.jemnie
	cmp.w d2,d4
	ble.b .jewiek
	move.w d2,d4
.jewiek
	move.l 12(a0),a1
	mulu -2(a1),d4
	divu d2,d4
	cmp.w -4(a1),d4
	beq.b .nochan
	move.w d4,-4(a1)
	lea gadgets,a1
	bsr gaddraw
.nochan
	move.l (a7),a0
	btst #5,11(a0)
	beq.s .noepro
	move.l a0,-(a7)
	move.l 12(a0),a0
	jsr (a0)
	move.l (a7)+,a0
.noepro
	btst #6,$bfe001
	beq.w .pesuwa
	bra.w .judraw
.nosuwa
	btst #5,11(a0)
	beq.w .noonof
	move.l 12(a0),a1
	not.w -2(a1)
	lea gadgets,a1
	bsr gaddraw
	bra.w .judraw
.noonof
	btst #4,11(a0)
	bne.w .concat
	btst #2,11(a0)
	bne.w .switch
	btst #3,11(a0)
	bne.w .judraw
	jsr (a2)
.judraw
	move.l (a7)+,a0
	btst #1,11(a0)
	beq.s .noproc
	move.l 12(a0),a1
	jmp (a1)
.noproc
	rts
.concat
	move.l 12(a0),a1
	move.w -2(a1),d0
	mulu #20,d0
	move.l gadtab(a5),a2
	move.l a0,d1
	sub.l a2,d1
	add.l d0,a2
	divu #20,d1
	move.l 12(a2),a3
	move.w -4(a3),d2
	move.w d1,-4(a3)
	mulu #20,d2
	move.l gadtab(a5),a0
	add.l d2,a0
	lea gadgets,a1
	bsr gaddraw
	move.l (a7),a0
	lea gadgets,a1
	bsr gaddraw
	bra.w .judraw
.switch
	move.l 12(a0),a1
	addq.w #1,-4(a1)
	move.w -4(a1),d0
	cmp.w -2(a1),d0
	ble.s .mozbyc
	move.w #0,-4(a1)
.mozbyc
	lea gadgets,a1
	bsr gaddraw
	bra.w .judraw

cursneg
	tst.w cursposx
	bpl.s .jecof
	rts
.jecof
	drawmode #2
	move.l rastp(a5),a1
	move.l whandle(a5),a0
	move.w cursposx,d0
	move.w cursposy,d1
	move.w d0,d2
	move.w d1,d3
	addq.w #7,d2
	addq.w #8,d3
	callgfx -306
	drawmode #0
	rts
cursposx	dc.w 0
cursposy	dc.w 0
cursinp		dc.l 0
curpos		dc.w 0

gadrdraw
	move.w numgads(a5),d7
	bne.w .mozdra
	rts
.mozdra
	subq.w #1,d7
	move.l gadtab(a5),a0
	lea gadgets,a1
.pedraw
	cmp.l 12(a0),d0
	beq.w gaddraw
	lea 20(a0),a0
	dbf d7,.pedraw
	rts
checknumbs
	move.w numgads(a5),d7
	bne.s .jecoce
	rts
.jecoce
	subq.w #1,d7
	move.l gadtab(a5),a0
.pechek
	move.b 11(a0),d0
	and.b #$f1,d0
	cmp.b #$f1,d0
	bne.s .nonumbs
	move.l 12(a0),a1
	move.l -10(a1),a2
	moveq #0,d0
.konvnum
	tst.b (a2)
	beq.s .endofk
	moveq #0,d1
	move.b (a2)+,d1
	sub.b #48,d1
	move.l d0,d2
	lsl.l #2,d0
	add.l d2,d0
	add.l d0,d0
	add.l d1,d0
	bra.s .konvnum
.endofk
	cmp.l -14(a1),d0
	bgt.s .changit
	cmp.l -18(a1),d0
	bge.s .nonumbs
.changit
	move.l -18(a1),d0
	move.l d0,-22(a1)
	move.l -10(a1),a2
	move.w -4(a1),d6
	subq.w #1,d6
.pekabu
	sf (a2)+
	dbf d6,.pekabu
	move.l -10(a1),a2
	lea .lokbuf,a3
	moveq #0,d5
	moveq #8,d6
.pepuli
	divu #10,d0
	swap d0
	add.b #48,d0
	move.b d0,(a3)+
	sf d0
	swap d0
	tst.w d0
	beq.s .putit
	addq.w #1,d5
	dbf d6,.pepuli
.putit
	move.b -(a3),(a2)+
	dbf d5,.putit
.nonumbs
	lea 20(a0),a0
	dbf d7,.pechek
	rts
.lokbuf	blk.l 12,0

gadredraw
	bsr checknumbs
	move.w #-1,cursposx
	move.w numgads(a5),d7
	bne.s .mozdra
	rts
.mozdra
	subq.w #1,d7
	move.l gadtab(a5),a0
	lea gadgets,a1
.pedraw
	bsr.b gaddraw
	lea 20(a0),a0
	dbf d7,.pedraw
	rts
gaddraw
	movem.w (a0),d0-d4
	and.w #$ff,d4
	moveq #0,d5
	move.b 10(a0),d5
	lsl.w #4,d5
	move.l 0(a1,d5.w),a3
	move.l 8(a1,d5.w),a2
	move.l 12(a1,d5.w),a4
	movem.l d7-a1,-(a7)
	movem.l d0-d3/a3-a4,-(a7)
	jsr (a2)
	movem.l (a7),d0-d3/a3-a4
	jsr (a3)
	movem.l (a7)+,d0-d3/a3-a4
	move.l 4(a7),a0
	move.b 11(a0),d4
	and.b #$f0,d4
	cmp.b #$f0,d4
	bne.w .noinpg
	move.w 4(a0),d0
	sub.w (a0),d0
	sub.w #12,d0
	lsr.w #3,d0
	subq.w #1,d0
	bmi.w .notext
	move.l 12(a0),a1
	move.l -10(a1),a2
	add.w -2(a1),a2
	tst.b (a2)
	beq.w .notext
	lea .texbuf(pc),a3
.pecopt
	move.b (a2)+,(a3)+
	beq.b .jukont
	dbf d0,.pecopt
	sf (a3)
.jukont
	lea .texbuf(pc),a2
	moveq #-1,d0
	move.l a2,a1
.calleq
	addq.l #1,d0
	tst.b (a1)+
	bne.w .calleq
	tst.w d0
	beq.w .notext
	move.l a2,a0
	move.l a2,-(a7)
	move.w d0,-(a7)
	move.l rastp(a5),a1
	callgfx -54
	move.l 10(a7),a0
	move.w 6(a0),d2
	sub.w 2(a0),d2
	subq.w #8,d2
	lsr.w #1,d2
	add.w 2(a0),d2
	addq.w #7,d2
	move.w (a0),d3
	addq.w #6,d3
	plot d3,d2
	move.l 10(a7),a0
	move.w 8(a0),d1
	lsr.w #8,d1
	pen d1
	move.l 10(a7),a0
	moveq #0,d1
	move.b 9(a0),d1
	bpen d1
	moveq #0,d0
	move.w (a7)+,d0
	move.l (a7)+,a0
	move.l rastp(a5),a1
	callgfx -60
	bra.w .notext
.noinpg
	btst #6,11(a0)
	beq.b .nosuwa
	move.l 12(a0),a1
	movem.w -4(a1),d6-d7
	jsr (a4)
	bra.w .notext
.nosuwa
	move.l 4(a7),a0
	btst #5,11(a0)
	beq.b .noonof
	move.l 12(a0),a1
	tst.w -2(a1)
	beq.w .nomoco
	jsr (a4)
.noonof
	move.l 4(a7),a0
	btst #4,11(a0)
	beq.w .nomoco
	move.l 12(a0),a1
	move.w -2(a1),d4
	mulu #20,d4
	move.l gadtab(a5),a3
	move.l 12(a3,d4.w),a2
	move.w -4(a2),d4
	mulu #20,d4
	add.l a3,d4
	cmp.l d4,a0
	bne.w .nomoco
	jsr (a4)
.nomoco
	move.l 4(a7),a0
	btst #0,11(a0)
	beq.w .notext
	move.l 16(a0),a2
	btst #2,11(a0)
	beq.w .noswit
	lea .texbuf(pc),a1
	move.l 12(a0),a3
	move.w -4(a3),d7
	subq.w #1,d7
	bmi.w .noodli
.pefind
	cmp.b #"|",(a2)+
	bne.w .pefind
	dbf d7,.pefind
.noodli
	move.b (a2)+,(a1)+
	cmp.b #"|",(a2)
	bne.w .noodli
	sf (a1)
	lea .texbuf(pc),a2
.noswit
	moveq #-1,d0
	move.l a2,a1
.callen
	addq.l #1,d0
	tst.b (a1)+
	bne.w .callen
	tst.w d0
	beq.w .notext
	move.l a2,a0
	move.l a2,-(a7)
	move.w d0,-(a7)
	move.l rastp(a5),a1
	callgfx -54
	move.l 10(a7),a0
	move.w 4(a0),d3
	sub.w (a0),d3
	sub.w d0,d3
	lsr.w #1,d3
	add.w (a0),d3
	move.w 6(a0),d2
	sub.w 2(a0),d2
	subq.w #8,d2
	lsr.w #1,d2
	add.w 2(a0),d2
	addq.w #7,d2
	plot d3,d2
	move.l 10(a7),a0
	move.w 8(a0),d1
	lsr.w #8,d1
	pen d1
	move.l 10(a7),a0
	moveq #0,d1
	move.b 9(a0),d1
	bpen d1
	moveq #0,d0
	move.w (a7)+,d0
	move.l (a7)+,a0
	move.l rastp(a5),a1
	callgfx -60
.notext
	movem.l (a7)+,d7-a1
	rts
.texbuf	blk.l 32,0

defgads	blk.l 5*50,0
pomgads	blk.l 5*100,0
posgads	blk.l 5*100,0

gadgets
	dc.l .boxframe,.boxpress,.boxbody,.boxpress
	dc.l .imaframe,.imapress,.boxbody,.imaset
	dc.l .boxframe,.boxpress,.boxbody,.boxset
	dc.l .boxpress,.boxframe,.dummy,.suwdraw
	dc.l .boxframe,.boxpress,.stlbody,.stlbody
	dc.l .boxframe,.boxpress,.strbody,.strbody
	dc.l .boxpress,.boxframe,.dummy,.suwdrap
	dc.l .boxframe,.boxpress,.stlbody,.stlbody
	dc.l .boxframe,.boxpress,.strbody,.strbody

.dummy
	rts

.suwdrap
	movem.w d6-d7,-(a7)
	movem.w d0-d3,-(a7)
	bsr .suwdraw
	pen #0
	movem.w (a7),d0-d3
	sub.w #64,d0
	move.w d0,d2
	add.w #32,d2
	move.l rastp(a5),a1
	callgfx -306
	pen #1
	movem.w (a7)+,d0-d3
	movem.w (a7)+,d6-d7
	ext.l d6
	sub.w #56,d0
	add.w #9,d1
	move.w d1,-(a7)
	move.w d0,-(a7)
	prival (a7)+,(a7)+,d6
	rts

.strbody
	movem.w d0-d3,-(a7)
	pen d4
	movem.w (a7),d0-d3
	move.l rastp(a5),a1
	callgfx -306
	movem.w (a7)+,d0-d3
	sub.w d0,d2
	sub.w d1,d3
	addq.w #1,d0
	addq.w #1,d1
	subq.w #5,d2
	subq.w #8,d3
	lsr.w #1,d2
	lsr.w #1,d3
	add.w d2,d0
	add.w d3,d1
	movem.w d0-d1,-(a7)
	pen #1
	lea .tabstr,a0
	moveq #3,d7
	bra.w .peryz
.tabstr	dc.w 0,0,3,3,1,0,4,3,0,7,3,4,1,7,4,4

.stlbody
	movem.w d0-d3,-(a7)
	pen d4
	movem.w (a7),d0-d3
	move.l rastp(a5),a1
	callgfx -306
	movem.w (a7)+,d0-d3
	sub.w d0,d2
	sub.w d1,d3
	addq.w #1,d0
	addq.w #1,d1
	subq.w #5,d2
	subq.w #8,d3
	lsr.w #1,d2
	lsr.w #1,d3
	add.w d2,d0
	add.w d3,d1
	movem.w d0-d1,-(a7)
	pen #1
	lea .tabstl,a0
	moveq #3,d7
	bra.w .peryz
.tabstl	dc.w 0,3,3,0,1,3,4,0,0,4,3,7,1,4,4,7

.suwdraw
	movem.w d6-d7,-(a7)
	movem.w d0-d3,-(a7)
	pen #2
	movem.w (a7),d0-d3
	addq.w #4,d0
	subq.w #4,d2
	addq.w #2,d1
	subq.w #2,d3
	move.l rastp(a5),a1
	callgfx -306
	pen #3
	movem.w (a7)+,d0-d3
	movem.w (a7)+,d6-d7
	addq.w #4,d0
	subq.w #4,d2
	addq.w #2,d1
	subq.w #2,d3
	sub.w d0,d2
	sub.w #19,d2
	mulu d6,d2
	divu d7,d2
	add.w d0,d2
	move.w d2,d0
	add.w #18,d2
	movem.w d0-d3,-(a7)
	move.l rastp(a5),a1
	callgfx -306
	pen #1
	movem.w (a7),d0-d3
	add.w #9,d0
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	addq.w #7,d0
	line d0,d1,d0,d3
	movem.w (a7)+,d0-d3
	add.w #11,d0
	line d0,d1,d0,d3
	rts

.boxset
	movem.w d0-d3,-(a7)
	pen #1
	movem.w (a7)+,d0-d3
	sub.w d0,d2
	sub.w d1,d3
	sub.w #13,d2
	subq.w #7,d3
	lsr.w #1,d2
	lsr.w #1,d3
	addq.w #1,d2
	addq.w #1,d3
	add.w d2,d0
	add.w d3,d1
	movem.w d0-d1,-(a7)
	moveq #5,d7
	lea .tablin,a0
.peryz
	movem.w (a7),d0-d1
	move.w d0,d2
	move.w d1,d3
	add.w (a0)+,d0
	add.w (a0)+,d1
	add.w (a0)+,d2
	add.w (a0)+,d3
	movem.l d7-a0,-(a7)
	line d0,d1,d2,d3
	movem.l (a7)+,d7-a0
	dbf d7,.peryz
	addq.l #4,a7
	rts
.tablin	dc.w 0,3,3,6,1,3,4,6,2,3,5,6,4,6,10,0,5,6,11,0,10,0,12,0

.imaset
	movem.w d0-d3,-(a7)
	bsr.w .imapress
	pen #3
	movem.w (a7),d0-d3
	addq.w #5,d0
	addq.w #3,d1
	subq.w #5,d2
	subq.w #3,d3
	move.l rastp(a5),a1
	callgfx -306
	movem.w (a7),d0-d3
	addq.w #6,d0
	subq.w #6,d2
	addq.w #2,d1
	line d0,d1,d2,d1
	movem.w (a7),d0-d3
	addq.w #6,d0
	subq.w #6,d2
	subq.w #2,d3
	line d0,d3,d2,d3
	movem.w (a7),d0-d3
	addq.w #4,d1
	subq.w #4,d3
	addq.w #4,d0
	line d0,d1,d0,d3
	movem.w (a7)+,d0-d3
	addq.w #4,d1
	subq.w #4,d3
	subq.w #4,d2
	line d2,d1,d2,d3
	rts
.imaframe
	movem.w d0-d3,-(a7)
	pen #2
	movem.w (a7),d0-d3
	addq.w #2,d0
	subq.w #2,d2
	line d0,d1,d2,d1
	movem.w (a7),d0-d3
	addq.w #2,d1
	subq.w #2,d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	addq.w #1,d0
	addq.w #2,d1
	subq.w #2,d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d1
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d1
	addq.w #1,d0
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d3
	move.w d2,d0
	subq.w #2,d0
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d3
	subq.w #1,d2
	move.w d2,d0
	subq.w #2,d0
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d3,d1
	subq.w #2,d1
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d3,d1
	subq.w #2,d1
	addq.w #1,d0
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	pen #1
.dalei
	movem.w (a7),d0-d3
	addq.w #2,d0
	subq.w #2,d2
	line d0,d3,d2,d3
	movem.w (a7),d0-d3
	addq.w #2,d1
	subq.w #2,d3
	line d2,d1,d2,d3
	movem.w (a7),d0-d3
	addq.w #2,d1
	subq.w #2,d3
	subq.w #1,d2
	line d2,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d3,d1
	subq.w #2,d1
	move.w d2,d0
	subq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7)+,d0-d3
	move.w d3,d1
	subq.w #2,d1
	subq.w #1,d2
	move.w d2,d0
	subq.w #2,d2
	line d0,d1,d2,d3
	rts
.imapress
	movem.w d0-d3,-(a7)
	pen #1
	movem.w (a7),d0-d3
	addq.w #2,d0
	subq.w #2,d2
	line d0,d1,d2,d1
	movem.w (a7),d0-d3
	addq.w #2,d1
	subq.w #2,d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	addq.w #1,d0
	addq.w #2,d1
	subq.w #2,d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d1
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d1
	addq.w #1,d0
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d3
	move.w d2,d0
	subq.w #2,d0
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d1,d3
	addq.w #2,d3
	subq.w #1,d2
	move.w d2,d0
	subq.w #2,d0
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d3,d1
	subq.w #2,d1
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	movem.w (a7),d0-d3
	move.w d3,d1
	subq.w #2,d1
	addq.w #1,d0
	move.w d0,d2
	addq.w #2,d2
	line d0,d1,d2,d3
	pen #2
	bra.w .dalei
.boxframe
	movem.w d0-d3,-(a7)
	pen #2
	movem.w (a7),d0-d3
	line d0,d1,d2,d1
	movem.w (a7),d0-d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	addq.w #1,d0
	subq.w #1,d3
	line d0,d1,d0,d3
	pen #1
.dalsam
	movem.w (a7),d0-d3
	addq.w #1,d0
	line d0,d3,d2,d3
	movem.w (a7),d0-d3
	subq.w #1,d2
	addq.w #1,d1
	line d2,d1,d2,d3
	movem.w (a7)+,d0-d3
	line d2,d1,d2,d3
	rts
.boxpress
	movem.w d0-d3,-(a7)
	pen #1
	movem.w (a7),d0-d3
	line d0,d1,d2,d1
	movem.w (a7),d0-d3
	line d0,d1,d0,d3
	movem.w (a7),d0-d3
	addq.w #1,d0
	subq.w #1,d3
	line d0,d1,d0,d3
	pen #2
	bra.w .dalsam
.boxbody
	movem.w d0-d3,-(a7)
	pen d4
	movem.w (a7)+,d0-d3
	move.l rastp(a5),a1
	callgfx -306
	rts

privalp
	lea .pribuf(pc),a0
	moveq #4,d7
	move.l #10000,d2
.konvli
	move.l d0,d1
	divu d2,d1
	move.w d1,d3
	add.w #48,d1
	move.b d1,(a0)+
	mulu d2,d3
	divu #10,d2
	sub.l d3,d0
	dbf d7,.konvli
	lea .pribuf(pc),a0
	moveq #4,d7
.skipze
	cmp.b #48,(a0)
	bne.s .mozpri
	addq.l #1,a0
	dbf d7,.skipze
	move.b #0,.pribuf+1
	lea .pribuf(pc),a0
.mozpri
	move.l a0,strval(a5)
	rts
.pribuf	dc.l 0,0

vblsct	dc.l 0,0,$2100000,0,0,0
vblnam	dc.b "VBlank-int",0,0
vint_start
	lea vblsct(pc),a1
	move.l #vblnam,10(a1)
	lea vblint(pc),a0
	move.l a0,18(a1)
	move.l a1,14(a1)
	moveq #5,d0
	callexec -168
	rts
vint_end
	lea vblsct(pc),a1
	moveq #5,d0
	callexec -174
	rts
vblint
	mpush d1-a6
	move.w $dff01e,d0
	btst #5,d0
	beq.s .spowro
	lea vars,a5
	tst.w czas(a5)
	beq.s .spowro
	subq.w #1,czas(a5)
.spowro
	mpop d1-a6
	moveq #0,d0
	rts

do_select:
	move.w .menustat,-(a7)
	move.l .extdproc,-(a7)
	move.w d0,.menustat
	move.l a0,.extdproc
.mainloop
	move.l whandle(a5),a0
	move.l $56(a0),a0
	callexec -372
	tst.l d0
	beq.w .wait
	move.l d0,a1
	tst.w .menustat
	beq.w .nomenu
	cmp.l #$100,$14(a1)
	bne.w .nomenu
	move.l $14(a1),d2
	move.w $18(a1),d3
	move.w $1a(a1),d4
	move.l $1c(a1),a0
	move.w $20(a1),d5
	move.w $22(a1),d6
	callexec -378
	moveq #0,d0
	moveq #0,d1
	moveq #0,d2
	move.w d3,d0
	move.w d3,d1
	move.w d3,d2
	and.w #31,d0
	lsr.w #5,d1
	and.w #63,d1
	rol.w #5,d2
	and.w #31,d2
	cmp.w #4,d0
	bge.s .mainloop
	lea menu_tab(pc),a0
	lsl.w #2,d0
	move.l 0(a0,d0.w),a0
	lsl.w #2,d1
	tst.l 0(a0,d1.w)
	bmi.w .mainloop
	move.l 0(a0,d1.w),a0
	move.l a0,-(a7)
	offmenu
	move.l (a7)+,a0
	jsr (a0)
	cmp.l #$face0000,d0
	beq.w .end
	onmenu
	bra.w .mainloop
.nomenu
	cmp.l #$400,$14(a1)
	beq.s .rawkey
	cmp.l #$200,$14(a1)
	beq.w .end
	cmp.l #8,$14(a1)
	beq.s .mous
	bra.w .mainloop
.wait
	moveq #0,d0
	moveq #0,d1
	move.l whandle(a5),a1
	move.l $56(a1),a0
	move.b 15(a0),d1
	bset d1,d0
	callexec -318
	bra.w .mainloop
.mous
	btst #6,$bfe001
	bne.w .mainloop
	bsr gadtest
	tst.l .extdproc
	beq.b .nospej
	move.l .extdproc,a0
	jsr (a0)
.nospej
	cmp.l #$face0000,d0
	beq.w .end
	bra.w .mainloop
.rawkey
	moveq #0,d0
	move.w $18(a1),d0
	move.w $1a(a1),d1
	tst.b d0
	bmi.w .mainloop
	move.l cursinp,a4
	cmp.b #$41,d0
	bne.s .noback
	tst.w curpos
	beq.s .trysud
	subq.w #1,curpos
	subq.w #8,cursposx
	bra.s .delcha
.trysud
	move.l 12(a4),a0
	tst.w -2(a0)
	beq.w .mainloop
	subq.w #1,-2(a0)
.delcha
	move.l 12(a4),a0
	move.l -10(a0),a1
	move.w -2(a0),d0
	add.w curpos,d0
	add.w d0,a1
	move.w -4(a0),d1
	sub.w d0,d1
	subq.w #1,d1
	bmi.s .noprde
	lea 1(a1),a2
.copdod
	move.b (a2)+,(a1)+
	dbf d1,.copdod
.noprde
	bra.w .nododc
.noback
	cmp.b #$46,d0
	beq.s .delcha
	cmp.b #$4e,d0
	bne.s .noright
	move.l 12(a4),a0
	move.l -10(a0),a1
	add.w -2(a0),a1
	add.w curpos,a1
	tst.b (a1)
	beq.w .mainloop
	tst.w -2(a0)
	bne.s .totezo
	move.w curpos,d0
	addq.w #1,d0
	cmp.w -4(a0),d0
	beq.w .mainloop
.totezo
	move.w 4(a4),d0
	sub.w (a4),d0
	sub.w #12,d0
	lsr.w #3,d0
	subq.w #1,d0
	cmp.w curpos,d0
	beq.s .trydop
	bsr cursneg
	addq.w #1,curpos
	addq.w #8,cursposx
	bsr cursneg
	bra.w .mainloop
.trydop
	move.l 12(a4),a0
	move.w -2(a0),d0
	add.w curpos,d0
	addq.w #1,d0
	cmp.w -4(a0),d0
	beq.w .mainloop
	addq.w #1,-2(a0)
	bra.w .nododc
.noright
	cmp.b #$4f,d0
	bne.s .noleft
	tst.w curpos
	beq.s .trysup
	bsr cursneg
	subq.w #1,curpos
	subq.w #8,cursposx
	bsr cursneg
	bra.w .mainloop
.trysup
	move.l 12(a4),a0
	tst.w -2(a0)
	beq.w .mainloop
	subq.w #1,-2(a0)
	bra.w .nododc
.noleft
	bsr konvkey
	tst.w d0
	beq.w .mainloop
	tst.w cursposx
	bmi.w .noputc
	cmp.b #27,d0
	bne.s .noesc
.konwpr
	move.b 11(a4),d0
	and.b #$f1,d0
	cmp.b #$f1,d0
	bne.s .uncond
	move.l 12(a4),a0
	move.l -10(a0),a1
	moveq #0,d0
.pekonl
	tst.b (a1)
	beq.s .konkonv
	moveq #0,d1
	move.b (a1)+,d1
	sub.b #48,d1
	move.l d0,d2
	lsl.l #2,d0
	add.l d2,d0
	add.l d0,d0
	add.l d1,d0
	bra.s .pekonl
.konkonv
	cmp.l -14(a0),d0
	bgt.s .beepit
	cmp.l -18(a0),d0
	blo.s .beepit
	move.l d0,-22(a0)
.uncond
	bsr cursneg
	move.w #-1,cursposx
	bra.w .mainloop
.noesc
	cmp.b #13,d0
	beq.s .konwpr
	move.l cursinp,a4
	btst #0,11(a4)
	beq.s .alllim
	cmp.b #47,d0
	ble.s .beepit
	cmp.b #58,d0
	bge.s .beepit
	bra.s .gotin
.alllim
	cmp.b #31,d0
	ble.s .beepit
	cmp.b #127,d0
	ble.s .gotin
.beepit
	sub.l a0,a0
	callint -96
	bra.w .mainloop
.gotin
	move.l 12(a4),a0
	move.l -10(a0),a1
	move.w -2(a0),d1
	add.w curpos,d1
	lea 0(a1,d1.w),a2
	move.w -4(a0),d2
	add.w d2,a1
	sub.w d1,d2
	subq.w #2,d2
	bmi.s .noprzes
	lea -1(a1),a3
.movit
	move.b -(a3),-(a1)
	dbf d2,.movit
.noprzes
	move.b d0,(a2)
	move.l 12(a4),a1
	tst.w -2(a1)
	bne.s .ominto
	move.w curpos,d0
	addq.w #1,d0
	cmp.w -4(a1),d0
	beq.s .spankit
.ominto
	move.w 4(a4),d0
	sub.w (a4),d0
	sub.w #12,d0
	lsr.w #3,d0
	subq.w #1,d0
	cmp.w curpos,d0
	beq.s .dodcoi
	addq.w #1,curpos
	addq.w #8,cursposx
.spankit
	move.l 12(a4),d0
	bsr gadrdraw
	bsr cursneg
	bra.w .mainloop
.dodcoi
	move.l 12(a4),a1
	move.w -2(a1),d0
	add.w curpos,d0
	addq.w #1,d0
	cmp.w -4(a1),d0
	beq.s .nododc
	addq.w #1,-2(a1)
.nododc
	move.l 12(a4),d0
	bsr gadrdraw
	bsr cursneg
	bra.w .mainloop
.noputc
	bsr gadktest
	cmp.l #$face0000,d0
	beq.s .end
	bra.w .mainloop
.end
	move.l (a7)+,.extdproc
	move.w (a7)+,.menustat
	bra checknumbs
.extdproc	dc.l 0
.menustat	dc.w 0

openwindow
	lea .newwin(pc),a0
	callint -204
	move.l d0,whandle(a5)
	move.l d0,a0
	move.l 50(a0),rastp(a5)
	rts
.newwin	dc.w 0,20,420,160,$102
	dc.l $708,$100e,0,0,.title,0,0
	dc.w 20,20,420,160,1
.title	dc.b "Digital Movies Compressor",0
	even

initlibs
	openlib gfx,"graphics"
	openlib int,"intuition"
	openlib dos,"dos"
	rts

prog_start
	move.l 4.w,a6
	sub.l a1,a1
	jsr -294(a6)
	move.l d0,a4
	tst.l $ac(a4)
	bne.w .fromCLI
	lea $5c(a4),a0
	jsr -384(a6)
	jsr -372(a6)
	move.l d0,wb_message
	rts
.fromCLI
	move.l #0,wb_message
	rts
prog_end
	tst.l wb_message
	beq.s .noreply
	move.l wb_message(pc),a1
	move.l 4.w,a6
	jsr -378(a6)
.noreply
	moveq #0,d0
	rts
wb_message dc.l 0

savtab	blk.l 2*10,0
vars
	long gfxbase,0
	long intbase,0
	long dosbase,0
	long whandle,0
	long rastp,0
	long gadtab,0
	long fhandle,0
	long strval,0
	int numgads,0
	int grougd,0
	int czas,0

	section zwierz,code_c
strzaw	dc.l 0
	dc.l $07e007e0,$18181ff8,$24043bfc,$440a7bf6
	dc.l $42127dee,$8221fddf,$8141febf,$8181fe7f
	dc.l $8001ffff,$8001ffff,$8001ffff,$40027ffe
	dc.l $40027ffe,$20043ffc,$18181ff8,$07e007e0
	dc.l 0,0
strzan	dc.l 0
	dc.l $c000c000,$7000b000,$3c004c00,$3f004300
	dc.l $1fc020c0,$1fc02000,$0f001100,$0d801280
	dc.l $04c00940,$046008a0,$00200040,$00000000
	dc.l $00000000,$00000000,$00000000,$00000000
	dc.l 0,0
