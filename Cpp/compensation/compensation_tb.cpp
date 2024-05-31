#include "compensation.h"
#include "unstable.h"

#include "upDirectSolution.cpp"
#include "upIterationFunction.cpp"
#include "upJacobian.cpp"
#include "upMLP.cpp"
#include "downDirectSolution.cpp"
#include "downIterationFunction.cpp"
#include "downJacobian.cpp"
#include "downMLP.cpp"

#include "TruePlatform2base.cpp"
#include "IdealPlatform2disturb.cpp"
#include "upInverseSolution.cpp"

#include "compensation.cpp"
#include "inverseMatrix.cpp"
#include "RxRyRxFunction.cpp"
#include "transpose.cpp"
#include "cordic.cpp"
#include <iostream>

int main()
{

    float downLengths[6] = {54.1028, 54.1633, 54.7477, 58.7832, 62.2644, 54.9194};
    float upLengths[6] = {29.9174, 38.7245, 38.7654, 30.5619, 30.6836, 32.7377};
    float target[6] = {0};

    compensation(downLengths, upLengths, target);

    return 0;
}