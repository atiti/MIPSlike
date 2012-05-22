void main() {
	int a = 0;
	int b = 1;
	int sum = 0;
	int i = 0;
	
	for(i=0;i<20;i++) {
		sum = a + b;
		a = b;
		b = sum;
	}
}
