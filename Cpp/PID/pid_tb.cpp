#include "pid.h"
#include "pid.cpp"
#include <iostream>
int main()
{

    bool zero_output = 0;
    // 当pid三个参数相同,如果target-ssi每次也一样,那控制输出就是相同的
    int kp = 1500;
    int ki = 1500;
    int kd = 1500;
    int data_target = 200000;
    int data_real = 180000;
    Bit_16 control_output;

    pid(zero_output, kp, ki, kd, data_target, data_real, &control_output);
    std::cout << "first control_output: " << control_output << " \n";

    pid(zero_output, kp, ki, kd, data_target, data_real, &control_output);
    std::cout << "second control_output: " << control_output << " \n";

    pid(1, kp, ki, kd, data_target, data_real, &control_output);
    std::cout << "third control_output: " << control_output << " \n";

    return 0;
}
