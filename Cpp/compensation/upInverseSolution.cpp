#include "compensation.h"
#include "unstable.h"
#include "math.h"
// 输入: 暂时的单位是cm
// 一定注意, 该模块输入和输出都是实际值的10000倍
// 使用下平台的数据
void upInverseSolution(float pose[6], float lengths[6])
{
    // 定义实际位姿
    float x, y, z, a, b, c;

    // 转化为T的真实值 T = [x, y, z];
    x = pose[0];
    y = pose[1];
    z = pose[2];
    float T[3] = {x, y, z};
    // 转化为真实的角度值
    a = pose[3];
    b = pose[4];
    c = pose[5];

    float sina, sinb, sinc, cosa, cosb, cosc;

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

    // 计算六根腿长度
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            legTemp[j] = 0;
            for (int k = 0; k < 3; k++)
            {
                legTemp[j] += R[j][k] * up_P[i][k];
            }
            legTemp[j] += T[j] - up_B[i][j];
        }
        lengths[i] = sqrt(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]);
    }

    // for (int i = 0; i < 6; i++)
    // {
    //     // 保留4位小数(四舍五入),并扩大10000倍为整数
    //     lengths[i] = (int)(lengths[i] * 10000 + 0.5);
    // }
}