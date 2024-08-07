/*
根据matlab IterationFunction得到的C++代码
*/
#include "DirectSolution.h"
#include "unstable.h"
#include "math.h"
#include "cordic.cpp"

// 输入角度是角度制
void IterationFunction(float pose[6], float lengths[6], float f[6])
{
    // 定义实际位姿
    float x, y, z, a, b, c;
    x = pose[0];
    y = pose[1];
    z = pose[2];
    a = pose[3];
    b = pose[4];
    c = pose[5];

    float sina, sinb, sinc, cosa, cosb, cosc;

    cordic(a, &sina, &cosa);
    cordic(b, &sinb, &cosb);
    cordic(c, &sinc, &cosc);

    // 定义三个旋转矩阵, 这里使用旋转角顺序 x->y->z
    float T[3] = {x, y, z};

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

    // 初始化元素全为0
    float RxRy[3][3] = {0};
    float R[3][3] = {0};

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

    // 存放临时的腿长
    float legTemp[3] = {0, 0, 0};
    // 存放pose反解得到的腿长
    float pose2lengths[6] = {0};

    // 计算六根腿长度
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            legTemp[j] = 0;
            for (int k = 0; k < 3; k++)
            {
                legTemp[j] += R[j][k] * P[i][k];
            }
            legTemp[j] += T[j] - B[i][j];
        }
        pose2lengths[i] = sqrt(float(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]));
    }

    // 计算f
    for (int i = 0; i < 6; i++)
    {
        f[i] = pose2lengths[i] - lengths[i];
    }
}