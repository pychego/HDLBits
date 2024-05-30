/*
根据matlab IterationFunction得到的C++代码
*/
#include "downDirectSolution.h"
#include "unstable.h"
#include "math.h"
#include "cordic.cpp"

// 输入角度是角度制
void downIterationFunction(float pose[6], float lengths[6], float f[6])
{
    // 定义实际位姿
    float x, y, z, a, b, c;
    x = pose[0];
    y = pose[1];
    z = pose[2];
    a = pose[3];
    b = pose[4];
    c = pose[5];

    COS_SIN_TYPE sina, sinb, sinc, cosa, cosb, cosc;

    cordic(a, &sina, &cosa);
    cordic(b, &sinb, &cosb);
    cordic(c, &sinc, &cosc);
    // float sina, sinb, sinc, cosa, cosb, cosc;
    // sina = sin(a * DEG2RAD);
    // sinb = sin(b * DEG2RAD);
    // sinc = sin(c * DEG2RAD);
    // cosa = cos(a * DEG2RAD);
    // cosb = cos(b * DEG2RAD);
    // cosc = cos(c * DEG2RAD);
    // 定义三个旋转矩阵, 这里使用旋转角顺序 x->y->z
    float T[3] = {x, y, z};

    RTYPE Rx[3][3] = {
        {1, 0, 0},
        {0, cosa, -sina},
        {0, sina, cosa},
    };

    RTYPE Ry[3][3] = {
        {cosb, 0, sinb},
        {0, 1, 0},
        {-sinb, 0, cosb},
    };

    RTYPE Rz[3][3] = {
        {cosc, -sinc, 0},
        {sinc, cosc, 0},
        {0, 0, 1},
    };

    // 初始化元素全为0
    RTYPE RxRy[3][3] = {0};
    RTYPE R[3][3] = {0};

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
    RTYPE legTemp[3] = {0, 0, 0};
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
                legTemp[j] += R[j][k] * down_P[i][k];
            }
            legTemp[j] += T[j] - down_B[i][j];
        }
        pose2lengths[i] = sqrt(float(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]));
    }

    // 计算f
    for (int i = 0; i < 6; i++)
    {
        f[i] = pose2lengths[i] - lengths[i];
    }
}