	.file	1 "serial-fib.c"
	.section .mdebug.abi32
	.previous
	.abicalls

 # -G value = 0, Arch = mips1, ISA = 1
 # GNU C version 3.4.6 (mipsel-unknown-linux-gnu)
 #	compiled by GNU C version 4.6.1.
 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed:  -iprefix -auxbase -fverbose-asm -fomit-frame-pointer
 # options enabled:  -feliminate-unused-debug-types -fomit-frame-pointer
 # -fpeephole -ffunction-cse -fkeep-static-consts -fpcc-struct-return
 # -fgcse-lm -fgcse-sm -fgcse-las -fsched-interblock -fsched-spec
 # -fsched-stalled-insns -fsched-stalled-insns-dep -fbranch-count-reg -fpic
 # -fcommon -fverbose-asm -fargument-alias -fzero-initialized-in-bss
 # -fident -fmath-errno -ftrapping-math -mgas -mabicalls
 # -mno-flush-func_flush_cache -mflush-func=_flush_cache

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
	addiu	$sp,$sp,-24	 #,,
	sw	$0,8($sp)	 #, a
	li	$2,1			# 0x1	 # tmp181,
	sw	$2,12($sp)	 # tmp181, b
	sw	$0,16($sp)	 #, sum
	sw	$0,20($sp)	 #, i
	sw	$0,20($sp)	 #, i
$L2:
	lw	$2,20($sp)	 # i, i
	slt	$2,$2,20	 # tmp183, i,
	beq	$2,$0,$L1	 #, tmp183,
	lw	$3,8($sp)	 # a, a
	lw	$2,12($sp)	 # b, b
	addu	$2,$3,$2	 # tmp186, a, b
	sw	$2,16($sp)	 # tmp186, sum
	lw	$2,12($sp)	 # b, b
	sw	$2,8($sp)	 # b, a
	lw	$2,16($sp)	 # sum, sum
	sw	$2,12($sp)	 # sum, b
	lw	$2,20($sp)	 # i, i
	addiu	$2,$2,1	 # tmp190, i,
	sw	$2,20($sp)	 # tmp190, i
	b	$L2	 #
$L1:
	addiu	$sp,$sp,24	 #,,
	j	$31	 #
	.end	main
	.ident	"GCC: (GNU) 3.4.6"
