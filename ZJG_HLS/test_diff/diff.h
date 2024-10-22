#ifndef __diff_H__
#define __diff_H__
#include <iostream>

typedef unsigned short bit16;


/*
输入:
    A: 输入数组
    N: 输入数组长度
    B: 输出数组
输出:
    B: 数组的微分,长度也是N
*/

void diff(int *A, int N, int *B);

#endif
