	.file	1 "serial-racer.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,48,$31		# vars= 16, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-48
	sw	$31,40($sp)
	.cprestore	16
	li	$2,8			# 0x8
	sw	$2,24($sp)
	li	$2,1			# 0x1
	sw	$2,28($sp)
	sw	$0,32($sp)
	sw	$0,36($sp)
$L2:
	jal	get_chr
	sw	$2,36($sp)
	sw	$0,32($sp)
$L4:
	lw	$2,32($sp)
	slt	$2,$2,40
	beq	$2,$0,$L5
	lw	$2,32($sp)
	lw	$3,24($sp)
	slt	$2,$2,$3
	bne	$2,$0,$L8
	li	$3,40			# 0x28
	lw	$2,24($sp)
	subu	$3,$3,$2
	lw	$2,32($sp)
	slt	$2,$3,$2
	bne	$2,$0,$L8
	b	$L7
$L8:
	li	$4,45			# 0x2d
	jal	put_chr
	b	$L6
$L7:
	li	$4,35			# 0x23
	jal	put_chr
$L6:
	lw	$2,32($sp)
	addiu	$2,$2,1
	sw	$2,32($sp)
	b	$L4
$L5:
	lw	$2,28($sp)
	beq	$2,$0,$L10
	lw	$2,24($sp)
	addiu	$2,$2,1
	sw	$2,24($sp)
	b	$L11
$L10:
	lw	$2,24($sp)
	addiu	$2,$2,-1
	sw	$2,24($sp)
$L11:
	lw	$2,24($sp)
	slt	$2,$2,15
	beq	$2,$0,$L13
	lw	$2,24($sp)
	slt	$2,$2,4
	bne	$2,$0,$L13
	b	$L2
$L13:
	lw	$2,28($sp)
	beq	$2,$0,$L14
	sw	$0,28($sp)
	b	$L2
$L14:
	li	$2,1			# 0x1
	sw	$2,28($sp)
	b	$L2
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
