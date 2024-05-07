#include "TruePlatform2base.h"
#include <iostream>
#include <math.h>
#include "TruePlatform2base.cpp"

int main()
{   
    // pose1 是实际disturb相对于base的位姿
    float pose1[6] = {8.11, 2.11, 60, -5, 3.11, 4};
    // pose2 是实际platform在base下的位姿
    // float pose2[6] = {-10.4348, -4.6101, 36.1813, 4.7796, -3.4395, -3.7206};
    float pose2[6] = {-10.4348, -4.6101, 36.1813, 4.7796, -3.4395, -3.7206};
    // pose3 是实际platform在base下的位姿, 需根据此结果判断控制效果
    float pose3[6];
    TruePlatform2base(pose1, pose2, pose3);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose3[i] << " ";
    }
    return 0;
}