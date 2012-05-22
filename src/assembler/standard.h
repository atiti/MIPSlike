#ifndef __H_STANDARD__
#define __H_STANDARD__

#undef char
#undef short
#undef long
#define char int
#define short int
#define long int

//#define SERIAL_STATUS 16384
//#define SERIAL_DATA 49152
#define SERIAL_BASE 0x4000
#define SERIAL_STATUS SERIAL_BASE
#define SERIAL_DATA (SERIAL_BASE+1)

#define SERIAL_TX_STATUS 0x1
#define SERIAL_RX_STATUS 0x2

#define VGA_BASE 0x8000
//#define VGA_BASE 0x4169

// 99 - end of line
// 129 -
// 30  

#define KBD_BASE 0xf000
#define KBD_STATUS KBD_BASE
#define KBD_DATA (KBD_BASE+1)

void put_chr(int c) {
        int a = 0;
	int *ser_status = (int *)SERIAL_STATUS;
	int *ser_data = (int *)SERIAL_DATA;

	while (!a) {
		a = *(ser_status) & SERIAL_TX_STATUS;
	}

	*(ser_data) = c;
}

int get_chr() {
	int a = 0;
	int *ser_status = (int *)SERIAL_STATUS;
	int *ser_data = (int *)SERIAL_DATA;

	while (!a) {
		a = *(ser_status) & SERIAL_RX_STATUS;
	}
	
	return *(ser_data);
}

int get_chr_nb() {
        int a = 0;
	int cnt = 30000;
        int *ser_status = (int *)SERIAL_STATUS;
        int *ser_data = (int *)SERIAL_DATA;

	while (!a && cnt) {
        	a = *(ser_status) & SERIAL_RX_STATUS;
		cnt--;
	}
	if (!a && !cnt) return -1;

        return *(ser_data);
}

int get_kbd_nb() {
	int a = 0;
	int cnt = 10000;
	int *kbd_status = (int *)KBD_STATUS;
	int *kbd_data = (int *)KBD_DATA;

	while (!a && cnt) {
		a = *(kbd_status);
		cnt --;
	}

	if (!a && !cnt) return -1;

	return *(kbd_data);
}


void _put_hex(int c) {
	if (c > 9) {
		put_chr((c-10)+65);
	} else {
		put_chr(c+48);
	}
}

void put_hex(int c) {
	int a = c, b;
	if (a == 0) {
		_put_hex(c);
		return;
	}

	while (a != 0) {
		b = a & 0xf;
		_put_hex(b);
		a = a >> 4;
	}
}

void put_chr_vga(int a, int x, int y) {
	int *vga_ptr = (int *)VGA_BASE;
	int v = x + y;
	vga_ptr += v;
	*(vga_ptr) = a;	
}

void put_hex_vga(int c, int x) {
	int a = c, b, d, e = x;
	if (a == 0) {
		put_chr_vga('0', 0, x);
		return;
	}
	while (a != 0) {
		b = a & 0xf;
		if (b > 9)
			d = (b-10)+65;
		else
			d = b+48;
		put_chr_vga(d, 0, e);
		a = a >> 4;
		e++; 
	}
}

void delay() {
	int n,m;
	for(n=0;n<10;n++) {
		for(m=0;m<2000;m++) {
			__asm__("nop");
		}
	}
}

/*
void print_str(int *string) {
        while(*string != '\0') {
                put_chr(*string);
                *string++;
        }
}
*/
#endif
