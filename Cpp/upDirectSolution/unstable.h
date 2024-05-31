#ifndef __unstable_H__
#define __unstable_H__

typedef float RTYPE;

// 注意， 这个坐标相对的坐标系和world的姿态一样， 仅上下平移了
// 上 stwart 的参数
// 定义六个腿的底座坐标(在distrueb随体坐标系下)
RTYPE up_B[6][3] = {
    {6.1219f, -24.4478f, 4.0000f},
    {24.2334f, 6.9222f, 4.0000f},
    {18.1115f, 17.5257f, 4.0000f},
    {-18.1115f, 17.5257f, 4.0000f},
    {-24.2334f, 6.9222f, 4.0000f},
    {-6.1219f, -24.4478f, 4.0000f}};

// 上 stwart 的参数
// 定义六个腿的平台坐标(在platform随体坐标系下)
RTYPE up_P[6][3] = {
    {11.0404f, -10.4546f, -4.0000f},
    {14.5742f, -4.3340f, -4.0000f},
    {3.5337f, 14.7886f, -4.0000f},
    {-3.5337f, 14.7886f, -4.0000f},
    {-14.5742f, -4.3340f, -4.0000f},
    {-11.0404f, -10.4546f, -4.0000f}};

void upMLP(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void upIterationFunction(float pose[6], float lengths[6], float f[6]);

/* 下平台雅可比矩阵, 输入姿态为XYZ欧拉角(单位: 角度)
   输入: x, y, z, a, b, c 位姿
   输出: J 雅可比矩阵
*/
void upJacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);

#endif