#this is a comment

        .text
        .globl  main
main:
	addi $8,$0,32
	addi $7,$0,10
	addi $6,$0,65
	add $0,$0,$0
	add $0,$0,$0
	add $0,$0,$0
	add $0,$0,$0
	sw $6,$8,0
	add $0,$0,$0
	add $0,$0,$0
	add $0,$0,$0
	add $0,$0,$0
	sw $7,$8,0
	add $0,$0,$0
	beq $0,$0,main

