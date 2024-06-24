#include "matrix_mul.h"

void matrix_mul(ap_int<8> A[4][4], ap_int<8> B[4][4], ap_int<16> C[4][4])
{
#pragma HLS INTERFACE s_axilite port=C
#pragma HLS INTERFACE s_axilite port=B
#pragma HLS INTERFACE s_axilite port=A

// 为了让ap_start ap_done这些信号也受cpu控制,融入到axi lite接口中
#pragma HLS INTERFACE s_axilite port=return

#pragma HLS ARRAY_RESHAPE variable=B complete dim=1
#pragma HLS ARRAY_RESHAPE variable=A complete dim=2

    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
#pragma HLS PIPELINE II=1
            C[i][j] = 0;
            for (int k = 0; k < 4; k++)
            {
                C[i][j] += A[i][k] * B[k][j];
                // 乘法和加法各消耗一个时钟周期,因此最内层循环用4*2=8个周期
            }
        }
    }
}
