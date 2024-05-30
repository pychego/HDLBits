#ifndef __unstable_H__
#define __unstable_H__

// 下 stwart 的参数
// 定义六个腿的底座坐标(在base坐标系下)
RTYPE down_B[6][3] = {
    {35.8245f, -10.0280f, 4.0000f},
    {9.2278f, 36.0390f, 4.0000f},
    {-9.2278f, 36.0390f, 4.0000f},
    {-35.8245f, -10.0280f, 4.0000f},
    {-26.5968f, -26.0110f, 4.0000f},
    {26.5968f, -26.0110f, 4.0000f}};

// 下 stwart 的参数
// 定义六个腿的平台坐标(在disturb随体坐标系下)
RTYPE down_P[6][3] = {
    {24.2334f, 6.9222f, -4.0000f},
    {18.1115f, 17.5257f, -4.0000f},
    {-18.1115f, 17.5257f, -4.0000f},
    {-24.2334f, 6.9222f, -4.0000f},
    {-6.1219f, -24.4478f, -4.0000f},
    {6.1219f, -24.4478f, -4.0000f}};

void downMLP(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void downIterationFunction(float pose[6], float lengths[6], float f[6]);

/* 下平台雅可比矩阵, 输入姿态为XYZ欧拉角(单位: 角度)
   输入: x, y, z, a, b, c 位姿
   输出: J 雅可比矩阵
*/
void downJacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);

#endif