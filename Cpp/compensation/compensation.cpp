#include "compensation.h"
#include "unstable.h"
#include "math.h"
#include <iostream>

void compensation(float downLengths[6], float upLengths[6], float targets[6])
{
    float pose1[6];
    float pose2[6];

    downDirectSolution(downLengths, pose1);
    // 以上没问题
    // 输出pose1
    // std::cout << "pose1:" << std::endl;
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << pose1[i] << std::endl;
    // }

    upDirectSolution(upLengths, pose2);
    // 以上没问题
    // std::cout << "pose2:" << std::endl;
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << pose2[i] << std::endl;
    // }

    // 这个是需要存放输出的实际位姿
    float pose3[6];

    TruePlatform2base(pose1, pose2, pose3);
    // 以上没问题
    // std::cout << "pose3:" << std::endl;
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << pose3[i] << std::endl;
    // }

    float pose4[6];     // 理想platform在disturb下的位姿
    IdealPlatform2disturb(pose1, pose4);
    // 以上没问题
    // std::cout << "pose4:" << std::endl;
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << pose4[i] << std::endl;
    // }

    float Approaching_targets[6];
    upInverseSolution(pose4, Approaching_targets);
    // 以上没问题
    // std::cout << "Approaching_targets:" << std::endl;
    // for (int i = 0; i < 6; i++)
    // {
    //     std::cout << Approaching_targets[i] << std::endl;
    // }

    float Compensation_J[6][6];
    float error_pose[6];
    // error_pose = Approaching_targets - pose2;
    for (int i = 0; i < 6; i++)
    {
        error_pose[i] = pose4[i] - pose2[i];
    }

    upJacobian(pose2[0], pose2[1], pose2[2], pose2[3], pose2[4], pose2[5], Compensation_J);
    // 请注意，以上得到的Compensation_J后三列没有扩大，仿真显示后三列扩大 180/ pi 倍效果更好

    float Compensation_targets[6] = {0};
    // 矩阵相乘 Compensation_targets = Compensation_J * error_pose
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 6; j++)
        {
            Compensation_targets[i] += Compensation_J[i][j] * error_pose[j];
        }
    }

    // targets = Approaching_targets + Compensation_targets
    for (int i = 0; i < 6; i++)
    {
        targets[i] = Approaching_targets[i] + Compensation_targets[i];
    }
    // 输出 Compensation_targets
    std::cout << "Compensation_targets:" << std::endl;
    for (int i = 0; i < 6; i++)
    {
        std::cout << Compensation_targets[i] << std::endl;
    }
    // 输出 targets
    std::cout << "targets:" << std::endl;
    for (int i = 0; i < 6; i++)
    {
        std::cout << targets[i] << std::endl;
    }

}
