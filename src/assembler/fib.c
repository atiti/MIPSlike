#include "standard.h"

int main ()
{
  int a = 0,f=5;
  while (1) {
	a = get_chr();
  	fibonacci(f);
	f++;
  }
  return 0;
}

int fibonacci(int n)
{
  int a = 0;
  int b = 1;
  int sum;
  int i;
  for (i=0;i<n;i++)
  {
    put_hex(a);
    put_chr(' ');
    sum = a + b;
    a = b;
    b = sum;
  }
  put_chr('\r');
  put_chr('\n');
  return 0;
}

