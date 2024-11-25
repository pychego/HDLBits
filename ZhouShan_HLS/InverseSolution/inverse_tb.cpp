#include <iostream>
#include "inverse.h"
// C Simulation不能包含 inverse.cpp, 不然会报错重复定义
#include "inverse.cpp"
#include "cordic.cpp"

using namespace std;

int main()
{
    // 输入为实际值(cm, deg)的10000倍

    int referX = 10000;
    int referY = 30000;
    int referZ = 20000;
    int referA = 40000;
    int referB = 40000;
    int referC = 20000;
    int centralZ = 1200000; // cm扩大了10000倍
    int target1, target2, target3, target4, target5, target6;

    inverse(referX, referY, referZ, referA, referB, referC, centralZ,
            &target1, &target2, &target3, &target4, &target5, &target6);

    std::cout << "targets:" << std::endl;
    std::cout << target1 << std::endl;
    std::cout << target2 << std::endl;
    std::cout << target3 << std::endl;
    std::cout << target4 << std::endl;
    std::cout << target5 << std::endl;
    std::cout << target6 << std::endl;
}
