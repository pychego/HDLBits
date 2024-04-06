#include "inverse.h"
#include "math.h"

// 输入: 暂时的单位是cm
// 一定注意, 该模块输入和输出都是实际值的10000倍
void inverse(INT_TYPE pose[6], INT_TYPE lengths[6])
{

    // 定义六个腿的底座坐标(在base坐标系下)
    float B[6][3] = {
        {6.1219, -24.4478, 4.0000},
        {24.2334, 6.9222, 4.0000},
        {18.1115, 17.5257, 4.0000},
        {-18.1115, 17.5257, 4.0000},
        {-24.2334, 6.9222, 4.0000},
        {-6.1219, -24.4478, 4.0000}};

    // 定义六个腿的平台坐标(在disturb随体坐标系下)
    float P[6][3] = {
        {11.0404, -10.4546, -4.0000},
        {14.5742, -4.3340, -4.0000},
        {3.5337, 14.7886, -4.0000},
        {-3.5337, 14.7886, -4.0000},
        {-14.5742, -4.3340, -4.0000},
        {-11.0404, -10.4546, -4.0000}};

    // 定义实际位姿
    float x, y, z, a, b, c;

    // 转化为T的真实值 T = [x, y, z];
    x = pose[0] / 10000.0;
    y = pose[1] / 10000.0;
    z = pose[2] / 10000.0;
    float T[3] = {x, y, z};
    // 转化为真实的弧度值
    a = pose[3] / 10000.0 / 180.0 * M_PI;
    b = pose[4] / 10000.0 / 180.0 * M_PI;
    c = pose[5] / 10000.0 / 180.0 * M_PI;

    // 定义三个旋转矩阵, 这里使用旋转角顺序 x->y->z
    float Rx[3][3] = {
        {1, 0, 0},
        {0, cos(a), -sin(a)},
        {0, sin(a), cos(a)},
    };

    float Ry[3][3] = {
        {cos(b), 0, sin(b)},
        {0, 1, 0},
        {-sin(b), 0, cos(b)},
    };

    float Rz[3][3] = {
        {cos(c), -sin(c), 0},
        {sin(c), cos(c), 0},
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
    // 存放实际的浮点数腿长
    float lengths_float[6] = {0};

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
        lengths_float[i] = sqrt(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]);
    }

    for (int i = 0; i < 6; i++)
    {
        // 保留4位小数(四舍五入),并扩大10000倍为整数
        lengths[i] = (int)(lengths_float[i]*10000 + 0.5);
    }
}