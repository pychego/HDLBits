/*
根据matlab IterationFunction得到的C++代码
*/
#include "mlp.h"
#include "math.h"

// 输入角度是角度制
float *IteationFunction(float pose[6], float lengths[6])
{
    // 下 stwart 的参数
    // 定义六个腿的底座坐标(在base坐标系下)
    RTYPE B[6][3] = {
        {35.8245f, -10.0280f, 4.0000f},
        {9.2278f, 36.0390f, 4.0000f},
        {-9.2278f, 36.0390f, 4.0000f},
        {-35.8245f, -10.0280f, 4.0000f},
        {-26.5968f, -26.0110f, 4.0000f},
        {26.5968f, -26.0110f, 4.0000f}};

    // 定义六个腿的平台坐标(在disturb随体坐标系下)
    RTYPE P[6][3] = {
        {24.2334f, 6.9222f, -4.0000f},
        {18.1115f, 17.5257f, -4.0000f},
        {-18.1115f, 17.5257f, -4.0000f},
        {-24.2334f, 6.9222f, -4.0000f},
        {-6.1219f, -24.4478f, -4.0000f},
        {6.1219f, -24.4478f, -4.0000f}};

    // 定义实际位姿
    float x, y, z, a, b, c;
    x = pose[0];
    y = pose[1];
    z = pose[2];
    a = pose[3] / 180 * M_PI;
    b = pose[4] / 180 * M_PI;
    c = pose[5] / 180 * M_PI;
    // 定义三个旋转矩阵, 这里使用旋转角顺序 x->y->z
    float T[3] = {x, y, z};

    RTYPE Rx[3][3] = {
        {1, 0, 0},
        {0, cos(a), -sin(a)},
        {0, sin(a), cos(a)},
    };

    RTYPE Ry[3][3] = {
        {cos(b), 0, sin(b)},
        {0, 1, 0},
        {-sin(b), 0, cos(b)},
    };

    RTYPE Rz[3][3] = {
        {cos(c), -sin(c), 0},
        {sin(c), cos(c), 0},
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
                legTemp[j] += R[j][k] * P[i][k];
            }
            legTemp[j] += T[j] - B[i][j];
        }
        pose2lengths[i] = sqrt(float(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]));
    }

    // 计算f
    float f[6] = {0};
    for (int i = 0; i < 6; i++)
    {
        f[i] = pose2lengths[i] - lengths[i];
    }
    return f;
}