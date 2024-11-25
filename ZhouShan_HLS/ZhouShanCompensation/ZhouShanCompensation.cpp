#include "ZhouShanCompensation.h"
#include "unstable.h"
#include "math.h"
#include <iostream>

void ZhouShanCompensation(float ReferPose[6], float RealPose[6], float InverseTargets[6], float AllTargets[6])
{

    float df[6][6];
    Jacobian(RealPose[0], RealPose[1], RealPose[2]+central_Z, RealPose[3], RealPose[4], RealPose[5], df);

    float error_pose[6];
    for (int i = 0; i < 6; i++)
    {
        error_pose[i] = ReferPose[i] - RealPose[i];
    }

    float SmallTargets[6] = {0};
    // 矩阵相乘 SmallTargets = df * error_pose
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 6; j++)
        {
            SmallTargets[i] += df[i][j] * error_pose[j];
        }
    }

    // AllTargets = SmallTargets + InverseTargets
    for (int i = 0; i < 6; i++)
    {
        AllTargets[i] = SmallTargets[i] + InverseTargets[i];
    }
}
