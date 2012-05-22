#include "standard.h"

/* Outputs a value in hex */
void print_hex(int v) {
	int g = v;
	if (g > 9)
		g = (g-10) + 65;
	else
		g = g + 48;
		
        __asm__("nop");
        __asm__("li $5,49152");
        __asm__("nop");
        __asm__("nop");
        __asm__("sw $2,0($5)");
	return;
}
/* Outputs a value as hexadecimal */
void print_hex_long(int v) {
	int g = v;
	int i;
	for(i=0;i<32;i += 4) {
		g = (v >> (32 - i)) & 0xF;
		print_hex(g);
	}
	return;
}


int main() {
	char a = 0xaa;
/*	int b = 2;
	int c = 0;
	if (b < a)
		print_hex(1);
	else
		print_hex(0);	

	c = a & b;
	print_hex(c);

	for(a=0;a<16;a++) {
		//c = c << 1; //c + 3;
		print_hex(a);
	}

	c = c << 4;
*/
	print_hex_long(a);

	return 0;
}
