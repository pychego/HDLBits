#include "inverse.h"
#include "math.h"

// 全部使用float类型,hls_math消耗的资源比math头文件消耗资源更多
// 使用下steart的!!!!!!

// 输入: 暂时的单位是 cm
// 如果计算的单位更小,会不会消耗资源更少?
// 一定注意, 该模块输入和输出都是实际值的10000倍
void inverse(int pose[6], struct Target* target)
{
	// 下 stwart 的参数
    // 定义六个腿的底座坐标(在base坐标系下)
    float B[6][3] = {
            {35.8245f, -10.0280f, 4.0000f},
            {9.2278f, 36.0390f, 4.0000f},
            {-9.2278f, 36.0390f, 4.0000f},
            {-35.8245f, -10.0280f, 4.0000f},
            {-26.5968f, -26.0110f, 4.0000f},
            {26.5968f, -26.0110f, 4.0000f}
        };

    // 定义六个腿的平台坐标(在disturb随体坐标系下)
    float P[6][3] = {
            {24.2334f, 6.9222f, -4.0000f},
            {18.1115f, 17.5257f, -4.0000f},
            {-18.1115f, 17.5257f, -4.0000f},
            {-24.2334f, 6.9222f, -4.0000f},
            {-6.1219f, -24.4478f, -4.0000f},
            {6.1219f, -24.4478f, -4.0000f}
        };

    // 定义实际位姿
    float x, y, z, a, b, c;

    // 转化为T的真实值 T = [x, y, z];
    x = pose[0] / 10000.0;
    y = pose[1] / 10000.0;
    z = pose[2] / 10000.0;
    float T[3] = {x, y, z};
    // 转化为真实的弧度值
    a = pose[3] / 10000.0;
    b = pose[4] / 10000.0;
    c = pose[5] / 10000.0;
    COS_SIN_TYPE sina, sinb, sinc, cosa, cosb, cosc;

// 不知道为什么如果使用这个循环的话,综合就会出问题
//    for(int i=0; i<3; i++){
//    	if(i=0)
//    		cordic(a, &sina, &cosa);
//    	else if (i=1)
//    		cordic(b, &sinb, &cosb);
//    	else if (i=2)
//    		cordic(c, &sinc, &cosc);
//    }
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

    // for (int i = 0; i < 6; i++)
    // {
    //     // 保留4位小数(四舍五入),并扩大10000倍为整数
    //     lengths[i] = (int)(lengths_float[i]*10000 + 0.5);
    // }

    // 输出到target
    target->target1 = (int)(lengths_float[0] * 10000 + 0.5);
    target->target2 = (int)(lengths_float[1] * 10000 + 0.5);
    target->target3 = (int)(lengths_float[2] * 10000 + 0.5);
    target->target4 = (int)(lengths_float[3] * 10000 + 0.5);
    target->target5 = (int)(lengths_float[4] * 10000 + 0.5);
    target->target6 = (int)(lengths_float[5] * 10000 + 0.5);
}
