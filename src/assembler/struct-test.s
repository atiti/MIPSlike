	.file	1 "struct-test.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,16,$31		# vars= 8, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-16
	la	$3,c
	li	$2,1			# 0x1
	sw	$2,0($3)
	la	$3,c
	li	$2,2			# 0x2
	sw	$2,4($3)
	la	$2,c
	la	$3,c
	lw	$4,0($2)
	lw	$2,4($3)
	addu	$2,$4,$2
	sw	$2,8($sp)
	lw	$2,8($sp)
	addiu	$sp,$sp,16
	j	$31
	.end	main

	.comm	c,8,4
	.ident	"GCC: (GNU) 3.4.6"
