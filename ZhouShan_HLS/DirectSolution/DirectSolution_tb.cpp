#include "DirectSolution.cpp"
#include "MLP.cpp"
#include "IterationFunction.cpp"
#include "Jacobian.cpp"
#include "inverseMatrix.cpp"

#include "DirectSolution.h"
#include "unstable.h"
#include <iostream>

// 该函数用于舟山小平台的正解 
/* 输入为六根腿的总长度, 单位为cm, 
   输出为平台的实际位姿, 单位为cm和deg */

int main()
{
    

    float lengths[6] = {127.1709, 134.8095, 134.6012, 136.5912, 136.1010, 131.0046};

    float pose[6];
    DirectSolution(lengths, pose);
    for (int i = 0; i < 6; i++)
    {
        std::cout << pose[i] << std::endl;
    }
}