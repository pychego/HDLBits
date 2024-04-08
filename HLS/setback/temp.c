#include<stdio.h>

void swap(int n1)
{
    n1 = 1000;
}

int main()
{
    int a=10;
    int b=20;
    printf("a=%d\n",a);
    printf("b=%d\n",b);
    swap(a);
    printf("a=%d\n",a);
    printf("b=%d\n",b);
}