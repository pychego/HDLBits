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
    // ReferPose 当前下发的参考位姿
    // RealPose 当前周期的实际位姿
    // RealPose和ReferPose都是相对于动平台参考系而言的
    float RealPose[6] = {0, 0, -3.52, 0, 0.2, 0};
    float ReferPose[6] = {0, 0, 5, 0, 3, 1};

    // 反解得到的目标值
    float InverseTargets[6] = {134.1161,134.8635,134.9980,138.7659,138.0837,135.5982};
    // 定义补偿后的总目标腿长度
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
