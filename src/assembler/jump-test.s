main:
	li $a0,123
	nop
	move $a1,$a0
	jal func1
	li $t1,1
	li $t2,2
	li $t3,3
	li $t4,4
	nop
	nop
	nop
	nop
	li $t1,5
	li $t2,6
	li $t3,7
	li $t4,8
	beq $0,$0,end

func1:
	li $a3,111
	jr $31
	nop

end:
	li $a4,333


