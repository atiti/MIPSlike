#!/usr/bin/env python

import os, string, sys

opcode_lookup = {"000000": "add",
		 "000001": "sub",
		 "000010": "j",
		 "000011": "jal",
		 "000100": "beq",
		 "000101": "bne",
		 "000110": "blez",
		 "000111": "bgtz",
		 "001000": "addi",
		 "001001": "addiu",
		 "001010": "slti",
		 "001011": "sltiu",
		 "001100": "andi",
		 "001101": "ori",
		 "001110": "xori",
		 "001111": "lui",
		 "100000": "lb",
		 "100001": "lh",
		 "100010": "lwl",
		 "100011": "lw",
		 "100100": "lbu",
		 "100101": "lhu",
		 "100110": "lwr",
		 "100111": "",
		 "101000": "sb",
		 "101001": "sh",
		 "101010": "swl",
		 "101011": "sw" }



fd = open(sys.argv[1], "r")
data = fd.read()
fd.close()

data = string.split(data, "\n")
PC = 0
for line in data:
	if not line:
		continue

	opcode = line[0:6]
	rs = line[6:11]
	rt = line[11:16]
	rd = line[16:21]
	shamt = line[21:26]
	funct = line[26:32]
	immediate = line[16:32]
	address = line[6:32]

	print "PC:",PC,"\tOP: "+opcode_lookup[opcode], "("+str(int(opcode,2))+")\t",
	iop = int(opcode,2)
	if iop == 0 or (iop >= 4 and iop <= 15) or (iop >= 32 and iop <= 43):
		print "RS:"+rs,"("+str(int(rs, 2))+")\tRT:",rt,"("+str(int(rt, 2))+")\t",
		if iop == 0: # R-Type
			print "RD:",rd,"("+str(int(rd,2))+")\tSHAMT:",shamt,"("+str(int(shamt,2))+")\tFUNCT:",funct,"("+str(int(funct,2))+")"
		else:
			print "IMMEDIATE:",immediate,"("+str(int(immediate,2))+")"
	else:
		print line[6:32]
	PC += 4


