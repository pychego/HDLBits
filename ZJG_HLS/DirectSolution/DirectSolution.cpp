#include "DirectSolution.h"
#include "unstable.h"
#include "math.h"
#include <iostream>

void DirectSolution(float lengths[6], float pose[6])
{
    // 通过神经网络获取迭代初始位姿
    MLP(lengths, pose);
    // 输出pose
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << pose[i] << std::endl;
    // }

    int maxIteratrion = MAX_ITERATION; // 最大迭代次数
    int flag = 0;                      // 判断是否迭代成功
    float eps = EPS;                   // 约定的迭代精度

    float f[6];

    // 定义一个 6*1 的矩阵
    float df[6][6];
    float df_inv[6][6];
    float new_pose[6];

    for (int i = 0; i < maxIteratrion; i++)
    {
        // 用temp 存放df_inv * f
        float temp[6];
        float error_abs[6];
        float error_max = 0;

        // f = 迭代初始位姿求解出的腿长 - 正解输入的腿长
        IterationFunction(pose, lengths, f);
        // 求雅可比矩阵df
        Jacobian(pose[0], pose[1], pose[2], pose[3], pose[4], pose[5], df);
        // 求df的逆矩阵
        inverseMatrix(df, df_inv);

        for (int i = 0; i < 6; i++)
        {
            temp[i] = 0;
            for (int j = 0; j < 6; j++)
            {
                temp[i] += df_inv[i][j] * f[j];
            }
            // new_pose[i] = roundf((pose[i] - temp[i]) * 10000) / 10000;
            new_pose[i] = pose[i] - temp[i];
        }
        // new_pose = pose - df.inverse() * f;

        for (int i = 0; i < 6; i++)
        {
            error_abs[i] = fabs(new_pose[i] - pose[i]);
            if (error_abs[i] > error_max)
            {
                error_max = error_abs[i];
            }
        }
        if (error_max < eps)
        {
            std::cout << "ok, 迭代次数i = " << i << std::endl;
            flag = 1;
            for (int i = 0; i < 6; i++)
            {
                pose[i] = roundf(new_pose[i]*10000) / 10000;
                // pose[i] = new_pose[i];
            }
            break;
        }
        else
        {
            // pose = new_pose;
            for (int i = 0; i < 6; i++)
            {
                // 这里其实有问题, 应该在最后一次迭代结束后再四舍五入  好像没问题
                // 这个和Vitis HLS中写的有点差别, 但是精确度都已经足够高了, 两个都没问题, 不用修改
                pose[i] = roundf(new_pose[i] * 10000) / 10000;
                // pose[i] = new_pose[i];
            }
        }
    }
}