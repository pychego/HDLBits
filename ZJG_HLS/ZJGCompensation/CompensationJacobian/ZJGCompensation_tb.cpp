// 二分法求正数的平方根 尝试一下部署到HLS
#include <iostream>
#include <iomanip>
using namespace std;
#include "math.h"
#include "ZJGCompensation.h"
#include "ZJGCompensation.cpp"
#include "Jacobian.cpp"
#include "cordic.cpp"

// 该雅可比矩阵对上平台的target进行补偿
int main()
{
    float RealPose[6] = {0, 0, -14.1164, 0, 0, 0};
    float ReferPose[6] = {0, 0, 5, 0, 0, 0};
    // 反解得到的目标值
    float InverseTargets[6] = {169.6182, 169.6182, 169.6182, 169.6182, 169.6182, 169.6182};

    float AllTargets[6] = {0};

    ZJGCompensation(ReferPose, RealPose, InverseTargets, AllTargets);

    // 输出AllTargets
    cout << "AllTargets:" << endl;
    for (int i = 0; i < 6; i++)
    {
        cout << AllTargets[i] << endl;
    }

    // 输出AllTargets - InverseTargets
    cout << "AllTargets - InverseTargets:" << endl;
    for (int i = 0; i < 6; i++)
    {
        cout << AllTargets[i] - InverseTargets[i] << endl;
    }
}
