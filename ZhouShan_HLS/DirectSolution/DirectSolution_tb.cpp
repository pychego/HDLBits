#include "DirectSolution.cpp"
#include "MLP.cpp"
#include "IterationFunction.cpp"
#include "Jacobian.cpp"
#include "inverseMatrix.cpp"

#include "DirectSolution.h"
#include "unstable.h"
#include <iostream>

// 该函数用于舟山实物的正解 明天将补偿腿长放入接口
int main()
{
    
    /*
        T = [1; 3; 122];
        a = 4; b = 4; c = 2;
    */
    float lengths[6] = {127.1709, 134.8095, 134.6012, 136.5912, 136.1010, 131.0046};

    float pose[6];
    DirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }
}