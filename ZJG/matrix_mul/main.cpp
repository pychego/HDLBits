#include "matrix.h"
#include <iostream>

int main()
{
    ap_int<8> A[4][4];
    ap_int<8> B[4][4];
    ap_int<8> C[4][4];

    // 初始化赋值0, 1, 2, 3, 4, 5......
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            A[i][j] = i * 4 + j;
            B[i][j] = A[i][j];
        }
    }

    matrix_mul(A, B, C);

    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            std::cout << "C[" << i << "][" << j << "] = " << C[i][j] << std::endl;
        }
    }
}