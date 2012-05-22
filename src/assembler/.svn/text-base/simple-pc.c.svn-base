#include <stdlib.h>
int main() {
	int i = 0;
	volatile int a = 0, b = 10;
//	for(i=0;i<b;i++) {
	while (i < b) {
		printf("%d\n", a);
		a += i;
		i++;
	}
	printf("final: %d\n", a);
	return 0;
}
