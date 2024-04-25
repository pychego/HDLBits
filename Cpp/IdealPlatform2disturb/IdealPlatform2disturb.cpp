#include "IdealPlatform2disturb.h"
#include <iostream>
#include "math.h"

void IdealPlatform2disturb(float pose1[6], float pose2[6])
{
    // R12是xyz型旋转矩阵 R=R12的逆=R12^T
    float R12[3][3] = {0};  // 不初始化为0会有问题
    float R[3][3];      
    RxRyRzFunction(pose1[3], pose1[4], pose1[5], R12);
    transpose(R12, R);

    // 完全按照matlab程序改写, 变量名保持一致
    float t12[3] = {pose1[0], pose1[1], pose1[2]};
    float temp[3]= {0 - t12[0], 0 - t12[1], 97 - t12[2]};   // [0,0,97]是理想platform的位置
    float t[3] = {0};

    // t = R * temp
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            t[i] += R[i][j] * temp[j];
        }
    }

    //根据xyz幸好旋转矩阵求欧拉角
    float sy = sqrt(R[1][2] * R[1][2] + R[2][2] * R[2][2]);
    float a = atan2(-R[1][2], R[2][2]) * 180 / M_PI;
    float b = atan2(R[0][2], sy) * 180 / M_PI;
    float c = atan2(-R[0][1], R[0][0]) * 180 / M_PI;

    pose2[0] = t[0];
    pose2[1] = t[1];
    pose2[2] = t[2];
    pose2[3] = a;
    pose2[4] = b;
    pose2[5] = c;

}