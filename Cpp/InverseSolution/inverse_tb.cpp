#include <iostream>
#include "inverse.h"
#include "inverse.cpp"
#include "cordic.cpp"
// c simulation不能包含 inverse.cpp, 不然会报错重复定义

using namespace std;

int main()
{
    // 输入为实际值的10000倍
    INT_TYPE pose[6] = {83410, 45320, 564100, 21800, -36000, -52120};
    // INT_TYPE pose[6] = {80000, 50000, 600000, 20000, 20000, 10000};
    INT_TYPE lengths[6] = {0, 0, 0, 0, 0, 0};

    struct Target target = {0, 0, 0, 0, 0, 0};

    inverse(pose, &target);
    // for (int i = 0; i < 6; i++)
    // {
    //     cout << lengths[i] << endl;
    // }
    // 输出target的值
    cout << "target1: " << target.target1 << endl;
    cout << "target2: " << target.target2 << endl;
    cout << "target3: " << target.target3 << endl;
    cout << "target4: " << target.target4 << endl;
    cout << "target5: " << target.target5 << endl;
    cout << "target6: " << target.target6 << endl;
}
