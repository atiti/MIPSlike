	.file	1 "serial-puthex.c"
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
	li	$2,49152			# 0xc000
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
	li	$2,49152			# 0xc000
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
	bne	$2,$0,$L8
	lw	$2,32($sp)
	addiu	$2,$2,55
	move	$4,$2
	jal	put_chr
	b	$L7
$L8:
	lw	$2,32($sp)
	addiu	$2,$2,48
	move	$4,$2
	jal	put_chr
$L7:
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
	bne	$2,$0,$L12
	lw	$4,40($sp)
	jal	_put_hex
	b	$L10
$L12:
	lw	$2,24($sp)
	beq	$2,$0,$L10
	lw	$2,24($sp)
	andi	$2,$2,0xf
	sw	$2,28($sp)
	lw	$4,28($sp)
	jal	_put_hex
	lw	$2,24($sp)
	sra	$2,$2,4
	sw	$2,24($sp)
	b	$L12
$L10:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	put_hex
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,40,$31		# vars= 8, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,32($sp)
	.cprestore	16
	sw	$0,28($sp)
$L15:
	jal	get_chr
	sw	$2,24($sp)
	lw	$3,24($sp)
	li	$2,49			# 0x31
	bne	$3,$2,$L15
	lw	$4,28($sp)
	jal	put_hex
	lw	$2,28($sp)
	addiu	$2,$2,1
	sw	$2,28($sp)
	sw	$0,24($sp)
	li	$4,13			# 0xd
	jal	put_chr
	li	$4,10			# 0xa
	jal	put_chr
	b	$L15
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
