#this is a comment
        .text
        .globl  main
main:
	li $t0,96
	li $a3,10
	li $a2,49
	li $s0,57
	li $t1,0
	li $s5,2000
loop:
	addi $t1,$t1,1
	add $v1,$a2,$t1
	li $s4,0
	jal dummy
	nop
	nop
	sw $v1,0($t0)
	beq $v1,$s0,newline
	j loop
	nop
	nop
	nop

newline:
	li $a3,10
	sw $a3,0($t0)
	li $t1,0
	li $a3,13
	sw $a3,0($t0)
	beq $0,$0,main


dummy:
	nop
	nop
	nop
	nop
	addi $s4,$s4,1
	nop
	nop
	nop
	nop
	bne $s4,$s5,dummy
	jr $31


