#include "DirectSolution.cpp"
#include "MLP.cpp"
#include "IterationFunction.cpp"
#include "Jacobian.cpp"
#include "inverseMatrix.cpp"

#include "DirectSolution.h"
#include "unstable.h"
#include <iostream>

// 该函数用于紫金港实物的正解
int main()
{
    // float lengths[6] = {57.8268, 49.9773, 52.1388, 50.1579, 48.6781, 53.9514};
    // float lengths[6] = {57.7205,60.5218,	57.0952,	56.5405,	60.0804,	53.2883};
    float lengths[6] = {165, 165, 165, 165, 165, 165};
    // 此时实际位姿  {-8.3, 5.2, 55.2, 2.18, -3.6, 5.212}
    // float pose[6] = {-8.164, 5.178, 55.28, 2.158, -3.416, 5.127};

    float pose[6];
    DirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }

}