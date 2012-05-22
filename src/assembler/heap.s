	.file	1 "heap.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	a
	.data
	.align	2
	.type	a, @object
	.size	a, 4
a:
	.word	123
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
	la	$2,a
	lw	$2,0($2)
	addiu	$2,$2,3
	sw	$2,8($sp)
	move	$2,$0
	addiu	$sp,$sp,16
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
