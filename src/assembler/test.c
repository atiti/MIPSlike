void print_char(char c) {
	__asm__("li $v0,11;");
	__asm__("syscall;");
}

void print_int(int a) {
	__asm__("li $v0,1;");
	__asm__("syscall;");
}

void print_str(char *string) {
	while(*string != '\0') {
		print_char(*string);
		*string++;
	}
}

int helloworld(int a) {
 	if (a > 100)
		return a;
	return helloworld(a+2);
}

int main() {
	int a = 1, b = 2, c = 0;
	char cnt = 0;

	print_str("hello world\n");

	for(c=0;c<10;c++) {
		for(cnt=0;cnt<127;cnt++) {
			b += a + b;
		}
		a = b / c;
		print_str("a: ");
		print_int(a);
		print_char('\n');
	}
	
	a = helloworld(a);
	print_str("Last a: ");
	print_int(a);
	print_char('\n');
	return 0;
}
