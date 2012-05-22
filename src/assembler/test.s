	.file	1 "test.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	print_char
	.ent	print_char
	.type	print_char, @function
print_char:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	move	$2,$4
	sb	$2,0($sp)
#APP
	li $v0,11;
	syscall;
#NO_APP
	j	$31
	.end	print_char
	.align	2
	.globl	print_int
	.ent	print_int
	.type	print_int, @function
print_int:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	sw	$4,0($sp)
#APP
	li $v0,1;
	syscall;
#NO_APP
	j	$31
	.end	print_int
	.align	2
	.globl	print_str
	.ent	print_str
	.type	print_str, @function
print_str:
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
$L4:
	lw	$2,32($sp)
	lb	$2,0($2)
	beq	$2,$0,$L3
	lw	$2,32($sp)
	lb	$2,0($2)
	move	$4,$2
	jal	print_char
	lw	$2,32($sp)
	addiu	$2,$2,1
	sw	$2,32($sp)
	b	$L4
$L3:
	lw	$31,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	print_str
	.align	2
	.globl	helloworld
	.ent	helloworld
	.type	helloworld, @function
helloworld:
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
	slt	$2,$2,101
	bne	$2,$0,$L7
	lw	$2,40($sp)
	sw	$2,24($sp)
	b	$L6
$L7:
	lw	$2,40($sp)
	addiu	$2,$2,2
	move	$4,$2
	jal	helloworld
	sw	$2,24($sp)
$L6:
	lw	$2,24($sp)
	lw	$31,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	helloworld
	.rdata
	.align	2
$LC0:
	.ascii	"hello world\n\000"
	.align	2
$LC1:
	.ascii	"a: \000"
	.align	2
$LC2:
	.ascii	"Last a: \000"
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
	li	$2,1			# 0x1
	sw	$2,24($sp)
	li	$2,2			# 0x2
	sw	$2,28($sp)
	sw	$0,32($sp)
	sb	$0,36($sp)
	la	$4,$LC0
	jal	print_str
	sw	$0,32($sp)
$L9:
	lw	$2,32($sp)
	slt	$2,$2,10
	beq	$2,$0,$L10
	sb	$0,36($sp)
$L12:
	lb	$3,36($sp)
	li	$2,127			# 0x7f
	beq	$3,$2,$L13
	lw	$3,24($sp)
	lw	$2,28($sp)
	addu	$3,$3,$2
	lw	$2,28($sp)
	addu	$2,$2,$3
	sw	$2,28($sp)
	lbu	$2,36($sp)
	addiu	$2,$2,1
	sb	$2,36($sp)
	b	$L12
$L13:
	lw	$3,28($sp)
	lw	$2,32($sp)
	div	$0,$3,$2
	bne	$2,$0,1f
	break	7
1:
	mflo	$2
	sw	$2,24($sp)
	la	$4,$LC1
	jal	print_str
	lw	$4,24($sp)
	jal	print_int
	li	$4,10			# 0xa
	jal	print_char
	lw	$2,32($sp)
	addiu	$2,$2,1
	sw	$2,32($sp)
	b	$L9
$L10:
	lw	$4,24($sp)
	jal	helloworld
	sw	$2,24($sp)
	la	$4,$LC2
	jal	print_str
	lw	$4,24($sp)
	jal	print_int
	li	$4,10			# 0xa
	jal	print_char
	move	$2,$0
	lw	$31,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
