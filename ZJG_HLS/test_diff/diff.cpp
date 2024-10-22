#include "diff.h"

void diff(int *A, int N, int *B)
{

    B[0] = A[1] - A[0];
    for (int j = 1; j < N; j++)
    {
        B[j] = A[j] - A[j - 1];
    }
}