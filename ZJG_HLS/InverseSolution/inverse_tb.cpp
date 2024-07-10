#include <iostream>
#include "inverse.h"
// C Simulation不能包含 inverse.cpp, 不然会报错重复定义
#include "inverse.cpp"
#include "cordic.cpp"

using namespace std;

int main()
{
    // 输入为实际值(cm, deg)的10000倍
    int pose[6] = {100000, 100000, 100000, 80000, 80000, 80000};
    // INT_TYPE pose[6] = {80000, 50000, 600000, 20000, 20000, 10000};
    int lengths[6] = {0, 0, 0, 0, 0, 0};

    int referX = 100000;
    int referY = 100000;
    int referZ = 100000;
    int referA = 80000;
    int referB = 80000;
    int referC = 80000;
    int target1, target2, target3, target4, target5, target6;

    inverse(referX, referY, referZ, referA, referB, referC,
            &target1, &target2, &target3, &target4, &target5, &target6);

    std::cout << "targets:" << std::endl;
    std::cout << target1 << std::endl;
    std::cout << target2 << std::endl;
    std::cout << target3 << std::endl;
    std::cout << target4 << std::endl;
    std::cout << target5 << std::endl;
    std::cout << target6 << std::endl;
}
