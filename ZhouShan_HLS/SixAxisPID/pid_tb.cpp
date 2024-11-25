#include "pid.h"
#include <iostream>

#include "pid.cpp"
int main()
{
    bool zero_output = 0;
    // 当pid三个参数相同,如果target-ssi每次也一样,那控制输出就是相同的
    int kp = 1500;
    int ki = 1200;
    int kd = 1000;
    int data_target[6] = {200000, 200000, 200000, 200000, 200000, 200000};
    int ssi[6] = {180000, 180000, 180000, 180000, 180000, 180000};
    Bit_16 control_output0;
    Bit_16 control_output1;
    Bit_16 control_output2;
    Bit_16 control_output3;
    Bit_16 control_output4;
    Bit_16 control_output5;

    pid(zero_output, kp, ki, kd, data_target[0], data_target[1], data_target[2], data_target[3], data_target[4], data_target[5],
        ssi[0], ssi[1], ssi[2], ssi[3], ssi[4], ssi[5],
        &control_output0, &control_output1, &control_output2, &control_output3, &control_output4, &control_output5);
    std::cout << "first control_output: "<< " \n";
    // 输出control_output
    std::cout << "control_output0: " << control_output0 << " \n";
    std::cout << "control_output1: " << control_output1 << " \n";
    std::cout << "control_output2: " << control_output2 << " \n";
    std::cout << "control_output3: " << control_output3 << " \n";
    std::cout << "control_output4: " << control_output4 << " \n";
    std::cout << "control_output5: " << control_output5 << " \n";

    //	ssi = 150000;
    pid(zero_output, kp, ki, kd, data_target[0], data_target[1], data_target[2], data_target[3], data_target[4], data_target[5],
        ssi[0], ssi[1], ssi[2], ssi[3], ssi[4], ssi[5],
        &control_output0, &control_output1, &control_output2, &control_output3, &control_output4, &control_output5);
    std::cout << "second control_output: " << " \n";
    std::cout << "control_output0: " << control_output0 << " \n";
    std::cout << "control_output1: " << control_output1 << " \n";
    std::cout << "control_output2: " << control_output2 << " \n";
    std::cout << "control_output3: " << control_output3 << " \n";
    std::cout << "control_output4: " << control_output4 << " \n";
    std::cout << "control_output5: " << control_output5 << " \n";


    // 找到问题了。。。。。。，调试
    pid(zero_output, kp, ki, kd, data_target[0], data_target[1], data_target[2], data_target[3], data_target[4], data_target[5],
        ssi[0], ssi[1], ssi[2], ssi[3], ssi[4], ssi[5],
        &control_output0, &control_output1, &control_output2, &control_output3, &control_output4, &control_output5);
    std::cout << "third control_output: " << " \n";
    std::cout << "control_output0: " << control_output0 << " \n";
    std::cout << "control_output1: " << control_output1 << " \n";
    std::cout << "control_output2: " << control_output2 << " \n";
    std::cout << "control_output3: " << control_output3 << " \n";
    std::cout << "control_output4: " << control_output4 << " \n";
    std::cout << "control_output5: " << control_output5 << " \n";

    return 0;
}
