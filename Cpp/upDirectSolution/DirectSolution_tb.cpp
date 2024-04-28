#include "DirectSolution.cpp"
#include "mlp.cpp"
#include "IterationFunction.cpp"
#include "Jacobian_cordic.cpp"
#include "inverseMatrix.cpp"
#include "mlp.h"
#include <iostream>

int main()
{
    // float lengths[6] = {43.8448,	38.5162,	38.7187,	43.2164,	41.2477,	39.5129};
    // float lengths[6] = {38.3798,36.0734,35.1059,40.2248,39.5909,33.8097};

    float lengths[6] = {42.4942,41.0681,40.0866,44.5299,43.8046,38.0115};
    // float pose[6] = {-8.164, 5.178, 55.28, 2.158, -3.416, 5.127};
    float pose[6];
    DirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }

}