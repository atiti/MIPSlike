main:
	li $t0,32
	li $t1,96
	nop
	nop
	nop
	nop
	sw $t0,2($zero)
	nop
	nop
	nop
	nop
	lw $s1,2($zero)
	nop
	nop
wait:
	nop
	nop
	lw $s0,0($t0)
	li $t2,2
	nop
	nop
	and $t4,$s0,$t2
	beq $t4,$t2,readchar
	j wait	

readchar:
	lw $s0,0($t1)
	nop
	nop
	nop
	sw $s0,0($t1)
	nop
	nop
	j wait

