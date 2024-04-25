#include "IdealPlatform2disturb.h"
#include <iostream>
#include "cordic.cpp"

void RxRyRzFunction(float a, float b, float c, float R[3][3])
{
    COS_SIN_TYPE sina, sinb, sinc, cosa, cosb, cosc;
    cordic(a, &sina, &cosa);
    cordic(b, &sinb, &cosb);
    cordic(c, &sinc, &cosc);

    // 定义三个旋转矩阵, 这里使用旋转角顺序 x->y->z
    float Rx[3][3] = {
        {1, 0, 0},
        {0, cosa, -sina},
        {0, sina, cosa},
    };

    float Ry[3][3] = {
        {cosb, 0, sinb},
        {0, 1, 0},
        {-sinb, 0, cosb},
    };

    float Rz[3][3] = {
        {cosc, -sinc, 0},
        {sinc, cosc, 0},
        {0, 0, 1},
    };

    // 中间变量矩阵RxRy
    float RxRy[3][3] = {0};
    

    // 计算RxRy
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            for (int k = 0; k < 3; k++)
            {
                RxRy[i][j] += Rx[i][k] * Ry[k][j];
            }
        }
    }

    // 计算R
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            for (int k = 0; k < 3; k++)
            {
                R[i][j] += RxRy[i][k] * Rz[k][j];
            }
        }
    }
}