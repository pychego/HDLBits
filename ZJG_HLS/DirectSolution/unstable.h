#ifndef __unstable_H__
#define __unstable_H__

// ZJG stwart 的参数 cm
// 定义六个腿的底座坐标(在base坐标系下)
float B[6][3] = {
    {99.0152f, -14.0000f, 0},
    {99.0152f, 14.0000f, 0},
    {-37.3832f, 92.7496f, 0},
    {-61.6319f, 78.7496f, 0},
    {-61.6319f, -78.7496f, 0},
    {-37.3832f, -92.7496f, 0}};

// 下 stwart 的参数
// 定义六个腿的平台坐标(在disturb随体坐标系下)
float P[6][3] = {
    {49.1464f, -63.1240f, 0},
    {49.1464f, 63.1240f, 0},
    {30.0938f, 74.1240f, 0},
    {-79.2401f, 11.0000f, 0},
    {-79.2401f, -11.0000f, 0},
    {30.0938f, -74.1240f, 0}};

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