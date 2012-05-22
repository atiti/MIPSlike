#include "standard.h"

int main() {
	int a;
	int cnt = 192;
	int cnt2 = 0;

	while (1) {
		//cnt = 0;
		//for(a=97;a<123;a++) {
			//put_chr(a);
		//	put_chr_vga(a, 0, 10);
		//	cnt = cnt + 1;
		//}

		a = 48+cnt2;

		put_chr_vga(a, cnt, cnt2);

		cnt2 = cnt2 + 1;
		if (cnt2 > 96) {
			cnt2 = 0;
			if (cnt > 1632)
				cnt = 0;

			cnt += 96;
		}
	}

	return 0;
}
