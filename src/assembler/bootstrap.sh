#!/bin/bash

cat > $1.hex << EOF
mipslikeboot:
        li \$sp,1023
        nop
        jal main
mipslikeend:
        nop
        nop  
        nop
        nop
        j mipslikeend

EOF

cat $1 |sed "s/addiu/addi/g" >> $1.hex
