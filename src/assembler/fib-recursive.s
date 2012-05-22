main:
	li $v0,4
	li $sp,31 # Set the stack pointer to the top of the memory
	li $a0,10
	jal fib	
	move $t8,123
	nop

fib:
	addi $sp,$sp,-3
	sw $31,0($sp)
	sw $s0,1($sp)
	sw $s1,2($sp)

	add $s0,$a0,$zero
	addi $t1,$zero,1
	beq $s0,$zero,return0
	beq $s0,$t1,return1

	addi $a0,$s0,-1
	jal fib

	add $s1,$zero,$v0     #s1=fib(y-1)
	addi $a0,$s0,-2
	jal fib               #v0=fib(n-2)
	add $v0,$v0,$s1       #v0=fib(n-2)+$s1

exitfib:
	lw $ra,0($sp)       #read registers from stack
	lw $s0,1($sp)
	lw $s1,2($sp)
	addi $sp,$sp,3       #bring back stack pointer
	jr $ra

return1:
	li $v0,1
	j exitfib
return0:
	li $v0,0
	j exitfib


