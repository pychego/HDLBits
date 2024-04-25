#include "TruePlatform2base.h"
#include <iostream>
#include <math.h>
#include "TruePlatform2base.cpp"

int main()
{
    float pose1[6] = {8.11, 2.11, 60, -5, 3.11, 4};
    float pose2[6] = {-8, -4, 36, 4, -3, -3};
    float pose3[6];
    TruePlatform2base(pose1, pose2, pose3);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose3[i] << " ";
    }
    return 0;
}