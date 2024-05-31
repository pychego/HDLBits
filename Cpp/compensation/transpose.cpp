#include "compensation.h"
#include <iostream>

// 定义transpose函数， 返回值为void
void transpose(float R[3][3], float Rt[3][3])
{
    // 计算转置矩阵
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            Rt[i][j] = R[j][i];
        }
    }
}