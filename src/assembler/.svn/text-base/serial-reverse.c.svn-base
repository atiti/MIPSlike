#include "standard.h"

int main() {
	int a[100], c=0;
	int b = 0x0;

	while (1) {
		a[c] = get_chr();
		put_chr(a[c]);
		put_chr_vga(a[c], c,c);
		if (c > 30 || a[c] == '\r') {
			b = c;
			put_chr('\r');
			put_chr('\n');
			while (b != -1) {
				put_chr(a[b]);
				b--;
			}
			put_chr('\r');
			put_chr('\n');
			c = 0;
		} else
			c++;
	}

	return 0;
}
