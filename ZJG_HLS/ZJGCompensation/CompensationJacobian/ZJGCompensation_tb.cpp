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
    float RealPose[6] = {4, 6, 158, 0.8, 1.4, 4.5};
    float ReferPose[6] = {5, 7, 159.5, 1, 2, 5};
    // 反解得到的目标值
    float InverseTargets[6] = {165.8135, 177.5144, 173.2968, 176.4219, 175.9109, 177.9603};

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
