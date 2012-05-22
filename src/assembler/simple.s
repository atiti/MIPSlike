	.file	1 "simple.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	main
	.ent	main
	.type	main, @function
main:
	.frame	$sp,24,$31		# vars= 16, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	li	$sp,31
	addi	$sp,$sp,-24
	sw	$0,8($sp)
	sw	$0,12($sp)
	li	$2,10			# 0xa
	sw	$2,16($sp)
$L2:
	lw	$2,8($sp)
	lw	$3,16($sp)
	slt	$2,$2,$3
	beq	$2,$0,$L3
	lw	$3,12($sp)
	lw	$2,8($sp)
	add	$2,$3,$2
	sw	$2,12($sp)
	lw	$2,8($sp)
	addi	$2,$2,1
	sw	$2,8($sp)
	b	$L2
$L3:
	move	$2,$0
	addi	$sp,$sp,24
	nop
	nop
	nop
#	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
