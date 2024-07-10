#include "inverse.h"
#include "math.h"

// 全部使用float类型,hls_math消耗的资源比math头文件消耗资源更多
// 使用下steart的!!!!!!

// 输入: 单位是 cm, deg
// 输入pose是相对于中位位姿的, 送入之后要加上**中位高度**centralZ
// 一定注意, 该模块输入和输出都是实际值的10000倍
void inverse(int referX, int referY, int referZ, int referA, int referB, int referC,
             int *target1, int *target2, int *target3, int *target4, int *target5, int *target6)
{
    // 下 stwart 的参数(cm)
    // 定义六个腿的底座坐标(和李世阳的base一样)
    float B[6][3] = {
        {99.0152f, -14.0000f, 0},
        {99.0152f, 14.0000f, 0},
        {-37.3832f, 92.7496f, 0},
        {-61.6319f, 78.7496f, 0},
        {-61.6319f, -78.7496f, 0},
        {-37.3832f, -92.7496f, 0}};

    // 定义六个腿的平台坐标(和base位姿相同的动平面下)
    float P[6][3] = {
        {49.1464f, -63.1240f, 0},
        {49.1464f, 63.1240f, 0},
        {30.0938f, 74.1240f, 0},
        {-79.2401f, 11.0000f, 0},
        {-79.2401f, -11.0000f, 0},
        {30.0938f, -74.1240f, 0}};

    // 定义实际位姿
    float x, y, z, a, b, c;

    // 转化为T的真实值 T = [x, y, z];
    float centralZ = 149.5; // 中位高度(上下铰点所在平面的高度差cm)
    x = referX / 10000.0;
    y = referY / 10000.0;
    z = referZ / 10000.0 + centralZ;
    float T[3] = {x, y, z};
    // 转化为真实的角度值
    a = referA / 10000.0;
    b = referB / 10000.0;
    c = referC / 10000.0;
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
        lengths_float[i] = sqrt(float(legTemp[0] * legTemp[0] + legTemp[1] * legTemp[1] + legTemp[2] * legTemp[2]));
    }

    //    for (int i = 0; i < 6; i++)
    //    {
    //        // 保留4位小数(四舍五入),并扩大10000倍为整数
    //        lengths[i] = (int)(lengths_float[i]*10000 + 0.5);
    //    }
    *target1 = roundf(lengths_float[0] * 10000);
    *target2 = roundf(lengths_float[1] * 10000);
    *target3 = roundf(lengths_float[2] * 10000);
    *target4 = roundf(lengths_float[3] * 10000);
    *target5 = roundf(lengths_float[4] * 10000);
    *target6 = roundf(lengths_float[5] * 10000);
}
