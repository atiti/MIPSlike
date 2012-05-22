#include "standard.h"

int main() {
	int i;
	int abc[25];
	while (1) {
		for(i=0;i<25;i++) {
			abc[i] = 97 + i;
			put_chr(abc[i]);
		}
		put_chr('\n');	
	}
	return 0;
}
