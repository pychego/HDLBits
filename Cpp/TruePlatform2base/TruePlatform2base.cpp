#include "TruePlatform2base.h"
#include <math.h>
#include "RxRyRxFunction.cpp"

void TruePlatform2base(float pose1[6], float pose2[6], float pose3[6])
{
    float R12[3][3]={0}, R23[3][3]={0};
    // float R12[3][3], R23[3][3];  这样定义得出错误结果
    // 使用RxRyRzFunction函数时, 需要在外面将R12, R23初始化为0
    RxRyRzFunction(pose1[3], pose1[4], pose1[5], R12);
    RxRyRzFunction(pose2[3], pose2[4], pose2[5], R23);

    // R = R12 * R23
    float R[3][3] = {0};
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            for (int k = 0; k < 3; k++)
            {
                R[i][j] += R12[i][k] * R23[k][j];
            }
        }
    }

    float t12[3] = {pose1[0], pose1[1], pose1[2]};
    float t23[3] = {pose2[0], pose2[1], pose2[2]};
    float t[3] = {0};
    // t = R12 * t23 + t12
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            t[i] += R12[i][j] * t23[j];
        }
        t[i] += t12[i];
    }

    pose3[0] = t[0];
    pose3[1] = t[1];
    pose3[2] = t[2];

    // 计算姿态
    float sy = sqrt(R[1][2] * R[1][2] + R[2][2] * R[2][2]);
    float a = atan2(-R[1][2], R[2][2]) * 180 / M_PI;
    float b = atan2(R[0][2], sy) * 180 / M_PI;
    float c = atan2(-R[0][1], R[0][0]) * 180 / M_PI;

    pose3[3] = a;
    pose3[4] = b;
    pose3[5] = c;

}