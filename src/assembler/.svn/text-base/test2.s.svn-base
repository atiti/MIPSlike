	.file	1 "test.c"
	.text
	.align 4
	.globl	print_char
	.ent	print_char
print_char:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	move	$2,$4
	sb	$2,8($fp)
#APP
	li $v0,11;
	syscall;
#NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	print_char
	.align 4
	.globl	print_int
	.ent	print_int
print_int:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
#APP
	li $v0,1;
	syscall;
#NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	.end	print_int
	.align 4
	.globl	print_str
	.ent	print_str
print_str:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
$L4:
	lw	$2,32($fp)
	lb	$2,0($2)
	beq	$2,$0,$L3
	lw	$2,32($fp)
	lb	$2,0($2)
	move	$4,$2
	jal	print_char
	lw	$2,32($fp)
	addiu	$2,$2,1
	sw	$2,32($fp)
	b	$L4
$L3:
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	.end	print_str
	.align 4
	.globl	helloworld
	.ent	helloworld
helloworld:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	lw	$2,40($fp)
	slt	$2,$2,101
	bne	$2,$0,$L7
	lw	$2,40($fp)
	sw	$2,24($fp)
	b	$L6
$L7:
	lw	$2,40($fp)
	addiu	$2,$2,2
	move	$4,$2
	jal	helloworld
	sw	$2,24($fp)
$L6:
	lw	$2,24($fp)
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	.end	helloworld
	.rdata
	.align 4
$LC0:
	.ascii	"hello world\n\000"
	.align 4
$LC1:
	.ascii	"a: \000"
	.align 4
$LC2:
	.ascii	"Last a: \000"
	.text
	.align 4
	.globl	main
	.ent	main
main:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	reorder
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	li	$2,1			# 0x1
	sw	$2,24($fp)
	li	$2,2			# 0x2
	sw	$2,28($fp)
	sw	$0,32($fp)
	sb	$0,36($fp)
	la	$4,$LC0
	jal	print_str
	sw	$0,32($fp)
$L9:
	lw	$2,32($fp)
	slt	$2,$2,10
	beq	$2,$0,$L10
	sb	$0,36($fp)
$L12:
	lb	$3,36($fp)
	li	$2,127			# 0x7f
	beq	$3,$2,$L13
	lw	$3,24($fp)
	lw	$2,28($fp)
	addu	$3,$3,$2
	lw	$2,28($fp)
	addu	$2,$2,$3
	sw	$2,28($fp)
	lbu	$2,36($fp)
	addiu	$2,$2,1
	sb	$2,36($fp)
	b	$L12
$L13:
	lw	$3,28($fp)
	lw	$2,32($fp)
	addu	$2,$3,$2
	sw	$2,24($fp)
	la	$4,$LC1
	jal	print_str
	lw	$4,24($fp)
	jal	print_int
	li	$4,10			# 0xa
	jal	print_char
	lw	$2,32($fp)
	addiu	$2,$2,1
	sw	$2,32($fp)
	b	$L9
$L10:
	lw	$4,24($fp)
	jal	helloworld
	sw	$2,24($fp)
	la	$4,$LC2
	jal	print_str
	lw	$4,24($fp)
	jal	print_int
	li	$4,10			# 0xa
	jal	print_char
	move	$2,$0
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	j	$31
	.end	main
