#include "standard.h"

int main() {
	int a;
	int b = 0x0;

	while (1) {
		a = get_chr();
		if (a == '1') {
			put_hex(b);
			b++;
			a = 0;
			put_chr('\r');
			put_chr('\n');
		}
	}

	return 0;
}
