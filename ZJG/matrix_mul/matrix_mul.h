#ifndef __MATRIX_MUL__
#define __MATRIX_MUL__

// HLS提供的任意精度定点数文件
#include "ap_fixed.h"

// A * B = C
void matrix_mul(ap_int<8> A[4][4], ap_int<8> B[4][4], ap_int<8> C[4][4]);

# endif