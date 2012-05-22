#!/usr/bin/python

import string

fd = open("splashscreen", "r")
buff = fd.read().split("\n")
fd.close()

LINE_WIDTH = 99
EXTRA_SPACE = 29

SADDR = 0
linecnt = 0
charcnt = 0
subcnt = 0


v1 = ""
v2 = ""
v3 = ""
v4 = ""


for line in buff:
	charcnt = 0
	subcnt = 0
	for char in line:
		if char != ' ':
			print subcnt,(linecnt+charcnt)/4,charcnt,linecnt
			charstr = str((linecnt+charcnt)/4)+" => X\""+str(hex(ord(char))).replace("0x", "").upper()+"\", "

			if subcnt == 0:
				v1 += charstr
			elif subcnt == 1:
				v2 += charstr
			elif subcnt == 2:
				v3 += charstr
			elif subcnt == 3:
				v4 += charstr
		if subcnt == 0:
			subcnt = 1
		elif subcnt == 1:
			subcnt = 2
		elif subcnt == 2:
			subcnt = 3
		else:
			subcnt = 0
		charcnt += 1
	linecnt += (LINE_WIDTH+EXTRA_SPACE)


print "--------------------"
print v1
print "--------------------"
print v2
print "--------------------"
print v3
print "--------------------"
print v4

