	.file	1 "serial-fib.c"
	.text
	.align 4
	.globl	main
	.ent	main
main:
	.frame	$sp,24,$31		# vars= 16, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-24
	sw	$0,8($sp)
	li	$2,1			# 0x1
	sw	$2,12($sp)
	sw	$0,16($sp)
	sw	$0,20($sp)
	sw	$0,20($sp)
$L2:
	lw	$2,20($sp)
	slt	$2,$2,20
	beq	$2,$0,$L1
	lw	$3,8($sp)
	lw	$2,12($sp)
	addu	$2,$3,$2
	sw	$2,16($sp)
	lw	$2,12($sp)
	sw	$2,8($sp)
	lw	$2,16($sp)
	sw	$2,12($sp)
	lw	$2,20($sp)
	addiu	$2,$2,1
	sw	$2,20($sp)
	b	$L2
$L1:
	addiu	$sp,$sp,24
	j	$31
	.end	main
