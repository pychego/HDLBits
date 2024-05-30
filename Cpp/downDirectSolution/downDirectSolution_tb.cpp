#include "downDirectSolution.cpp"
#include "downMLP.cpp"
#include "downIterationFunction.cpp"
#include "downJacobian.cpp"
#include "inverseMatrix.cpp"

#include "downDirectSolution.h"
#include "unstable.h"
#include <iostream>

int main()
{
    // float lengths[6] = {57.8268, 49.9773, 52.1388, 50.1579, 48.6781, 53.9514};
    // float lengths[6] = {57.7205,60.5218,	57.0952,	56.5405,	60.0804,	53.2883};
    float lengths[6] = {58.4536, 50.3413, 52.2402, 50.1538, 48.7386, 54.2602};
    // 此时实际位姿  {-8.3, 5.2, 55.2, 2.18, -3.6, 5.212}
    // float pose[6] = {-8.164, 5.178, 55.28, 2.158, -3.416, 5.127};

    float pose[6];
    downDirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }

}