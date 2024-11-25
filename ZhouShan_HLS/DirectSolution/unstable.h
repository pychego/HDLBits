#ifndef __unstable_H__
#define __unstable_H__

// 舟山 stwart 的参数 cm
// 定义六个腿的底座坐标(在base坐标系下)
float B[6][3] = {
    {79.3725f, -10.0000f, 0},
    {79.3725f, 10.0000f, 0},
    {-31.0260f, 73.7386f, 0},
    {-48.3465f, 63.7386f, 0},
    {-48.3465f, -63.7386f, 0},
    {-31.0260f, -73.7386f, 0}};

// 定义六个腿的平台坐标(舟山)
float P[6][3] = {
    {33.1552f, -37.4264f, 0},
    {33.1552f, 37.4264f, 0},
    {15.8346f, 47.4264f, 0},
    {-48.9898f, 10.0000f, 0},
    {-48.9898f, -10.0000f, 0},
    {15.8346f, -47.4264f, 0}};

void MLP(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void IterationFunction(float pose[6], float lengths[6], float f[6]);

/* 下平台雅可比矩阵, 输入姿态为XYZ欧拉角(单位: 角度)
   输入: x, y, z, a, b, c 位姿
   输出: J 雅可比矩阵
*/
void Jacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);

#endif