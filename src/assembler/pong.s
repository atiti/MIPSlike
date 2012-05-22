	.file	1 "pong.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	put_chr
	.ent	put_chr
	.type	put_chr, @function
put_chr:
	.frame	$sp,24,$31		# vars= 16, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-24
	sw	$4,24($sp)
	sw	$0,8($sp)
	li	$2,16384			# 0x4000
	sw	$2,12($sp)
	li	$2,16385			# 0x4001
	sw	$2,16($sp)
$L2:
	lw	$2,8($sp)
	bne	$2,$0,$L3
	lw	$2,12($sp)
	lw	$2,0($2)
	andi	$2,$2,0x1
	sw	$2,8($sp)
	b	$L2
$L3:
	lw	$3,16($sp)
	lw	$2,24($sp)
	sw	$2,0($3)
	addiu	$sp,$sp,24
	j	$31
	.end	put_chr
	.align	2
	.globl	get_chr
	.ent	get_chr
	.type	get_chr, @function
get_chr:
	.frame	$sp,24,$31		# vars= 16, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-24
	sw	$0,8($sp)
	li	$2,16384			# 0x4000
	sw	$2,12($sp)
	li	$2,16385			# 0x4001
	sw	$2,16($sp)
$L5:
	lw	$2,8($sp)
	bne	$2,$0,$L6
	lw	$2,12($sp)
	lw	$2,0($2)
	andi	$2,$2,0x2
	sw	$2,8($sp)
	b	$L5
$L6:
	lw	$2,16($sp)
	lw	$2,0($2)
	addiu	$sp,$sp,24
	j	$31
	.end	get_chr
	.align	2
	.globl	get_chr_nb
	.ent	get_chr_nb
	.type	get_chr_nb, @function
get_chr_nb:
	.frame	$sp,32,$31		# vars= 24, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-32
	sw	$0,8($sp)
	li	$2,30000			# 0x7530
	sw	$2,12($sp)
	li	$2,16384			# 0x4000
	sw	$2,16($sp)
	li	$2,16385			# 0x4001
	sw	$2,20($sp)
$L8:
	lw	$2,8($sp)
	bne	$2,$0,$L9
	lw	$2,12($sp)
	beq	$2,$0,$L9
	lw	$2,16($sp)
	lw	$2,0($2)
	andi	$2,$2,0x2
	sw	$2,8($sp)
	lw	$2,12($sp)
	addiu	$2,$2,-1
	sw	$2,12($sp)
	b	$L8
$L9:
	lw	$2,8($sp)
	bne	$2,$0,$L10
	lw	$2,12($sp)
	bne	$2,$0,$L10
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,24($sp)
	b	$L7
$L10:
	lw	$2,20($sp)
	lw	$2,0($2)
	sw	$2,24($sp)
$L7:
	lw	$2,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	get_chr_nb
	.align	2
	.globl	get_kbd_nb
	.ent	get_kbd_nb
	.type	get_kbd_nb, @function
get_kbd_nb:
	.frame	$sp,32,$31		# vars= 24, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-32
	sw	$0,8($sp)
	li	$2,10000			# 0x2710
	sw	$2,12($sp)
	li	$2,61440			# 0xf000
	sw	$2,16($sp)
	li	$2,61441			# 0xf001
	sw	$2,20($sp)
$L12:
	lw	$2,8($sp)
	bne	$2,$0,$L13
	lw	$2,12($sp)
	beq	$2,$0,$L13
	lw	$2,16($sp)
	lw	$2,0($2)
	sw	$2,8($sp)
	lw	$2,12($sp)
	addiu	$2,$2,-1
	sw	$2,12($sp)
	b	$L12
$L13:
	lw	$2,8($sp)
	bne	$2,$0,$L14
	lw	$2,12($sp)
	bne	$2,$0,$L14
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,24($sp)
	b	$L11
$L14:
	lw	$2,20($sp)
	lw	$2,0($2)
	sw	$2,24($sp)
$L11:
	lw	$2,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	get_kbd_nb
	.align	2
	.globl	_put_hex
	.ent	_put_hex
	.type	_put_hex, @function
_put_hex:
	.frame	$sp,32,$31		# vars= 0, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-32
	sw	$31,24($sp)
	.cprestore	16
	sw	$4,32($sp)
	lw	$2,32($sp)
	slt	$2,$2,10
	bne	$2,$0,$L16
	lw	$2,32($sp)
	addiu	$2,$2,55
	move	$4,$2
	jal	put_chr
	b	$L15
$L16:
	lw	$2,32($sp)
	addiu	$2,$2,48
	move	$4,$2
	jal	put_chr
$L15:
	lw	$31,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	_put_hex
	.align	2
	.globl	put_hex
	.ent	put_hex
	.type	put_hex, @function
put_hex:
	.frame	$sp,40,$31		# vars= 8, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	.cprestore	16
	sw	$4,40($sp)
	lw	$2,40($sp)
	sw	$2,24($sp)
	lw	$2,24($sp)
	bne	$2,$0,$L20
	lw	$4,40($sp)
	jal	_put_hex
	b	$L18
$L20:
	lw	$2,24($sp)
	beq	$2,$0,$L18
	lw	$2,24($sp)
	andi	$2,$2,0xf
	sw	$2,28($sp)
	lw	$4,28($sp)
	jal	_put_hex
	lw	$2,24($sp)
	sra	$2,$2,4
	sw	$2,24($sp)
	b	$L20
$L18:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	put_hex
	.align	2
	.globl	put_chr_vga
	.ent	put_chr_vga
	.type	put_chr_vga, @function
put_chr_vga:
	.frame	$sp,16,$31		# vars= 8, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-16
	sw	$4,16($sp)
	sw	$5,20($sp)
	sw	$6,24($sp)
	li	$2,32768			# 0x8000
	sw	$2,8($sp)
	lw	$3,20($sp)
	lw	$2,24($sp)
	addu	$2,$3,$2
	sw	$2,12($sp)
	lw	$2,12($sp)
	sll	$3,$2,2
	lw	$2,8($sp)
	addu	$2,$2,$3
	sw	$2,8($sp)
	lw	$3,8($sp)
	lw	$2,16($sp)
	sw	$2,0($3)
	addiu	$sp,$sp,16
	j	$31
	.end	put_chr_vga
	.align	2
	.globl	put_hex_vga
	.ent	put_hex_vga
	.type	put_hex_vga, @function
put_hex_vga:
	.frame	$sp,48,$31		# vars= 16, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-48
	sw	$31,40($sp)
	.cprestore	16
	sw	$4,48($sp)
	sw	$5,52($sp)
	lw	$2,48($sp)
	sw	$2,24($sp)
	lw	$2,52($sp)
	sw	$2,36($sp)
	lw	$2,24($sp)
	bne	$2,$0,$L25
	li	$4,48			# 0x30
	move	$5,$0
	lw	$6,52($sp)
	jal	put_chr_vga
	b	$L23
$L25:
	lw	$2,24($sp)
	beq	$2,$0,$L23
	lw	$2,24($sp)
	andi	$2,$2,0xf
	sw	$2,28($sp)
	lw	$2,28($sp)
	slt	$2,$2,10
	bne	$2,$0,$L27
	lw	$2,28($sp)
	addiu	$2,$2,55
	sw	$2,32($sp)
	b	$L28
$L27:
	lw	$2,28($sp)
	addiu	$2,$2,48
	sw	$2,32($sp)
$L28:
	lw	$4,32($sp)
	move	$5,$0
	lw	$6,36($sp)
	jal	put_chr_vga
	lw	$2,24($sp)
	sra	$2,$2,4
	sw	$2,24($sp)
	lw	$2,36($sp)
	addiu	$2,$2,1
	sw	$2,36($sp)
	b	$L25
$L23:
	lw	$31,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	put_hex_vga
	.align	2
	.globl	delay
	.ent	delay
	.type	delay, @function
delay:
	.frame	$sp,16,$31		# vars= 8, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-16
	sw	$0,8($sp)
$L30:
	lw	$2,8($sp)
	slt	$2,$2,10
	beq	$2,$0,$L29
	sw	$0,12($sp)
$L33:
	lw	$2,12($sp)
	slt	$2,$2,2000
	beq	$2,$0,$L32
#APP
	nop
#NO_APP
	lw	$2,12($sp)
	addiu	$2,$2,1
	sw	$2,12($sp)
	b	$L33
$L32:
	lw	$2,8($sp)
	addiu	$2,$2,1
	sw	$2,8($sp)
	b	$L30
$L29:
	addiu	$sp,$sp,16
	j	$31
	.end	delay
	.align	2
	.globl	draw_walls
	.ent	draw_walls
	.type	draw_walls, @function
draw_walls:
	.frame	$sp,40,$31		# vars= 8, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	.cprestore	16
	sw	$0,24($sp)
	sw	$0,28($sp)
	sw	$0,24($sp)
$L37:
	lw	$2,24($sp)
	slt	$2,$2,99
	beq	$2,$0,$L36
	li	$4,31			# 0x1f
	move	$5,$0
	lw	$6,24($sp)
	jal	put_chr_vga
	li	$4,31			# 0x1f
	lw	$5,28($sp)
	move	$6,$0
	jal	put_chr_vga
	li	$4,31			# 0x1f
	lw	$5,28($sp)
	li	$6,98			# 0x62
	jal	put_chr_vga
	lw	$2,28($sp)
	addiu	$2,$2,128
	sw	$2,28($sp)
	lw	$2,24($sp)
	addiu	$2,$2,1
	sw	$2,24($sp)
	b	$L37
$L36:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	draw_walls
	.align	2
	.globl	clear_screen
	.ent	clear_screen
	.type	clear_screen, @function
clear_screen:
	.frame	$sp,48,$31		# vars= 16, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-48
	sw	$31,40($sp)
	.cprestore	16
	sw	$0,24($sp)
	sw	$0,28($sp)
	sw	$0,32($sp)
	sw	$0,24($sp)
$L41:
	lw	$2,24($sp)
	slt	$2,$2,32
	beq	$2,$0,$L40
	sw	$0,28($sp)
$L44:
	lw	$2,28($sp)
	slt	$2,$2,99
	beq	$2,$0,$L45
	li	$4,32			# 0x20
	move	$5,$0
	lw	$6,32($sp)
	jal	put_chr_vga
	lw	$2,32($sp)
	addiu	$2,$2,1
	sw	$2,32($sp)
	lw	$2,28($sp)
	addiu	$2,$2,1
	sw	$2,28($sp)
	b	$L44
$L45:
	lw	$2,32($sp)
	addiu	$2,$2,29
	sw	$2,32($sp)
	lw	$2,24($sp)
	addiu	$2,$2,1
	sw	$2,24($sp)
	b	$L41
$L40:
	lw	$31,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	clear_screen
	.align	2
	.globl	erase_flipper
	.ent	erase_flipper
	.type	erase_flipper, @function
erase_flipper:
	.frame	$sp,40,$31		# vars= 8, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	.cprestore	16
	sw	$4,40($sp)
	sw	$0,24($sp)
	sw	$0,24($sp)
$L48:
	lw	$2,24($sp)
	slt	$2,$2,12
	beq	$2,$0,$L47
	lw	$3,40($sp)
	lw	$2,24($sp)
	addu	$2,$3,$2
	li	$4,32			# 0x20
	li	$5,3968			# 0xf80
	move	$6,$2
	jal	put_chr_vga
	lw	$2,24($sp)
	addiu	$2,$2,1
	sw	$2,24($sp)
	b	$L48
$L47:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	erase_flipper
	.align	2
	.globl	draw_flipper
	.ent	draw_flipper
	.type	draw_flipper, @function
draw_flipper:
	.frame	$sp,40,$31		# vars= 8, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	.cprestore	16
	sw	$4,40($sp)
	sw	$0,24($sp)
	sw	$0,24($sp)
$L52:
	lw	$2,24($sp)
	slt	$2,$2,12
	beq	$2,$0,$L51
	lw	$3,40($sp)
	lw	$2,24($sp)
	addu	$2,$3,$2
	li	$4,95			# 0x5f
	li	$5,3968			# 0xf80
	move	$6,$2
	jal	put_chr_vga
	lw	$2,24($sp)
	addiu	$2,$2,1
	sw	$2,24($sp)
	b	$L52
$L51:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	draw_flipper
	.align	2
	.globl	draw_ball
	.ent	draw_ball
	.type	draw_ball, @function
draw_ball:
	.frame	$sp,32,$31		# vars= 0, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-32
	sw	$31,24($sp)
	.cprestore	16
	sw	$4,32($sp)
	sw	$5,36($sp)
	sw	$6,40($sp)
	sw	$7,44($sp)
	li	$4,32			# 0x20
	lw	$5,44($sp)
	lw	$6,40($sp)
	jal	put_chr_vga
	li	$4,42			# 0x2a
	lw	$5,36($sp)
	lw	$6,32($sp)
	jal	put_chr_vga
	lw	$31,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	draw_ball
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,88,$31		# vars= 56, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-88
	sw	$31,80($sp)
	.cprestore	16
	sw	$0,24($sp)
	sw	$0,28($sp)
	li	$2,3840			# 0xf00
	sw	$2,48($sp)
$L57:
	sw	$0,32($sp)
	li	$2,44			# 0x2c
	sw	$2,36($sp)
	li	$2,44			# 0x2c
	sw	$2,40($sp)
	li	$2,46			# 0x2e
	sw	$2,44($sp)
	li	$2,3840			# 0xf00
	sw	$2,48($sp)
	li	$2,46			# 0x2e
	sw	$2,52($sp)
	li	$2,3840			# 0xf00
	sw	$2,56($sp)
	li	$2,1			# 0x1
	sw	$2,60($sp)
	li	$2,-128			# 0xffffffffffffff80
	sw	$2,64($sp)
	li	$2,4			# 0x4
	sw	$2,68($sp)
	li	$2,1			# 0x1
	sw	$2,72($sp)
	jal	get_chr
	sw	$2,24($sp)
	jal	clear_screen
$L58:
	jal	draw_walls
	lw	$4,40($sp)
	jal	erase_flipper
	lw	$4,36($sp)
	jal	draw_flipper
	lw	$4,44($sp)
	lw	$5,48($sp)
	lw	$6,52($sp)
	lw	$7,56($sp)
	jal	draw_ball
	lw	$4,32($sp)
	li	$5,258			# 0x102
	jal	put_hex_vga
	lw	$2,44($sp)
	sw	$2,52($sp)
	lw	$2,48($sp)
	sw	$2,56($sp)
	lw	$2,36($sp)
	sw	$2,40($sp)
	jal	get_chr_nb
	sw	$2,24($sp)
	lw	$2,24($sp)
	slt	$2,$2,0
	bne	$2,$0,$L60
	lw	$4,24($sp)
	jal	put_chr
$L60:
	lw	$2,72($sp)
	beq	$2,$0,$L61
	lw	$3,24($sp)
	li	$2,119			# 0x77
	bne	$3,$2,$L61
	sw	$0,72($sp)
$L61:
	lw	$3,24($sp)
	li	$2,97			# 0x61
	bne	$3,$2,$L62
	lw	$2,36($sp)
	slt	$2,$2,2
	bne	$2,$0,$L62
	lw	$2,36($sp)
	lw	$3,68($sp)
	subu	$2,$2,$3
	sw	$2,36($sp)
	b	$L63
$L62:
	lw	$3,24($sp)
	li	$2,100			# 0x64
	bne	$3,$2,$L63
	lw	$2,36($sp)
	slt	$2,$2,85
	beq	$2,$0,$L63
	lw	$2,36($sp)
	lw	$3,68($sp)
	addu	$2,$2,$3
	sw	$2,36($sp)
$L63:
	lw	$2,44($sp)
	slt	$2,$2,2
	bne	$2,$0,$L66
	lw	$2,44($sp)
	slt	$2,$2,97
	beq	$2,$0,$L66
	b	$L65
$L66:
	lw	$2,60($sp)
	subu	$2,$0,$2
	sw	$2,60($sp)
$L65:
	lw	$2,48($sp)
	slt	$2,$2,256
	beq	$2,$0,$L67
	lw	$2,64($sp)
	subu	$2,$0,$2
	sw	$2,64($sp)
	b	$L68
$L67:
	lw	$2,48($sp)
	slt	$2,$2,3969
	bne	$2,$0,$L69
	lw	$2,44($sp)
	lw	$3,36($sp)
	slt	$2,$3,$2
	beq	$2,$0,$L69
	lw	$2,36($sp)
	addiu	$3,$2,12
	lw	$2,44($sp)
	slt	$2,$2,$3
	beq	$2,$0,$L69
	lw	$2,64($sp)
	subu	$2,$0,$2
	sw	$2,64($sp)
	lw	$2,32($sp)
	addiu	$2,$2,10
	sw	$2,32($sp)
	b	$L68
$L69:
	lw	$2,48($sp)
	slt	$2,$2,3969
	bne	$2,$0,$L68
	b	$L59
$L68:
	lw	$2,72($sp)
	bne	$2,$0,$L58
	lw	$3,44($sp)
	lw	$2,60($sp)
	addu	$2,$3,$2
	sw	$2,44($sp)
	lw	$3,48($sp)
	lw	$2,64($sp)
	addu	$2,$3,$2
	sw	$2,48($sp)
	b	$L58
$L59:
	li	$4,103			# 0x67
	jal	put_chr
	li	$4,71			# 0x47
	li	$5,640			# 0x280
	li	$6,45			# 0x2d
	jal	put_chr_vga
	li	$4,97			# 0x61
	li	$5,640			# 0x280
	li	$6,46			# 0x2e
	jal	put_chr_vga
	li	$4,109			# 0x6d
	li	$5,640			# 0x280
	li	$6,47			# 0x2f
	jal	put_chr_vga
	li	$4,101			# 0x65
	li	$5,640			# 0x280
	li	$6,48			# 0x30
	jal	put_chr_vga
	li	$4,32			# 0x20
	li	$5,640			# 0x280
	li	$6,49			# 0x31
	jal	put_chr_vga
	li	$4,111			# 0x6f
	li	$5,640			# 0x280
	li	$6,50			# 0x32
	jal	put_chr_vga
	li	$4,118			# 0x76
	li	$5,640			# 0x280
	li	$6,51			# 0x33
	jal	put_chr_vga
	li	$4,101			# 0x65
	li	$5,640			# 0x280
	li	$6,52			# 0x34
	jal	put_chr_vga
	li	$4,114			# 0x72
	li	$5,640			# 0x280
	li	$6,53			# 0x35
	jal	put_chr_vga
	li	$4,33			# 0x21
	li	$5,640			# 0x280
	li	$6,54			# 0x36
	jal	put_chr_vga
	b	$L57
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
