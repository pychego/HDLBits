#include <iostream>

#include "diff.cpp"
int main()
{
    int M = 10000;
    int A[M] = {0};
    int N  = M;
    int B[M];
    diff(A, N, B);
    // 输出B
    for(int i=0; i<N; i++){
        printf("B[%d]: %d\n", i, B[i]);
    }

}
