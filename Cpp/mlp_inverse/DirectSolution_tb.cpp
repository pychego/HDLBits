#include "DirectSolution.cpp"
#include "mlp.cpp"
#include "IterationFunction.cpp"
#include "Jacobian_cordic.cpp"
#include "inverseMatrix.cpp"
#include "mlp.h"
#include <iostream>

int main()
{
    // float lengths[6] = {57.8268, 49.9773, 52.1388, 50.1579, 48.6781, 53.9514};
    float lengths[6] = {58.4536, 50.3413, 52.2402, 50.1538, 48.7386, 54.2602};
    // 此时实际位姿  {-8.3, 5.2, 55.2, 2.18, -3.6, 5.212}
    // float pose[6] = {-8.164, 5.178, 55.28, 2.158, -3.416, 5.127};
    float pose[6];
    DirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }

}