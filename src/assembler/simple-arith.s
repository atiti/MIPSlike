	.file	1 "simple-arith.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	print_hex
	.ent	print_hex
	.type	print_hex, @function
print_hex:
	.frame	$sp,16,$31		# vars= 8, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	addiu	$sp,$sp,-16
	sw	$4,16($sp)
	lw	$2,16($sp)
	sw	$2,8($sp)
	lw	$2,8($sp)
	slt	$2,$2,10
	bne	$2,$0,$L2
	lw	$2,8($sp)
	addiu	$2,$2,55
	sw	$2,8($sp)
	b	$L3
$L2:
	lw	$2,8($sp)
	addiu	$2,$2,48
	sw	$2,8($sp)
$L3:
#APP
	nop
	li $5,49152
	nop
	nop
	sw $2,0($5)
#NO_APP
	addiu	$sp,$sp,16
	j	$31
	.end	print_hex
	.align	2
	.globl	print_hex_long
	.ent	print_hex_long
	.type	print_hex_long, @function
print_hex_long:
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
	sw	$0,28($sp)
$L5:
	lw	$2,28($sp)
	slt	$2,$2,32
	beq	$2,$0,$L4
	li	$3,32			# 0x20
	lw	$2,28($sp)
	subu	$3,$3,$2
	lw	$2,40($sp)
	sra	$2,$2,$3
	andi	$2,$2,0xf
	sw	$2,24($sp)
	lw	$4,24($sp)
	jal	print_hex
	lw	$2,28($sp)
	addiu	$2,$2,4
	sw	$2,28($sp)
	b	$L5
$L4:
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	print_hex_long
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
	li	$2,170			# 0xaa
	sw	$2,24($sp)
	lw	$4,24($sp)
	jal	print_hex_long
	move	$2,$0
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
