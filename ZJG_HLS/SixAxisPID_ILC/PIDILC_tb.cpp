#include "PID_ILC.h"
#include "unstable.h"
#include <iostream>
#include "PID_ILC.cpp"


int main()
{
    bool zero_output = 0;
    // 当pid三个参数相同,如果target-ssi每次也一样,那控制输出就是相同的
    int kp = 0;
    int ki = 0;
    int kd = 0;
    int data_target[6] = {200000, 200000, 200000, 200000, 200000, 200000};
    int ssi[6] = {180000, 180000, 180000, 180000, 180000, 180000};
    bit16 control_output0;
    bit16 control_output1;
    bit16 control_output2;
    bit16 control_output3;
    bit16 control_output4;
    bit16 control_output5;

    int num_samples = 4000;   // 数据点数, 3个周期
    int sampling_rate = 1000;  // 采样率 (Hz) 不变
    float error[num_samples]; // 用于存储正弦波的 error 数组
    float time[num_samples];  // 用于存储时间向量

    float u[6]; // 测试接口, 综合时不要这个参数

    // 生成时间向量和 error
    for (int i = 0; i < num_samples; i++)
    {
        time[i] = (float)i / sampling_rate;   // 时间向量计算
        error[i] = sin(M_PI * time[i]); // 计算正弦波
        // printf("第 %d 次输入,error= %.4f\n", i + 1, error[i]);
    }

    for (int i = 0; i < num_samples; i++)
    {
        PID_ILC(zero_output, kp, ki, kd,
                7000000, 20000000, 2, 100, // ILC参数
                floor(error[i]*1000), floor(error[i]*1000), floor(error[i]*1000), floor(error[i]*1000), floor(error[i]*1000), floor(error[i]*1000),
                0-compensateLength, 0-compensateLength, 0-compensateLength, 0-compensateLength, 0-compensateLength, 0-compensateLength,
                // u,
                &control_output0, &control_output1, &control_output2, &control_output3, &control_output4, &control_output5);
        
        // 此处输出是纯ILC输出,不包含PID输出
        // std::cout << "control_output0: " << control_output0-32768 << std::endl;
        // printf("第 %d 次输出,u= %.2f    control_output0: %d \n", i + 1, u[0], control_output0-32768);
        printf("第 %d 次输出, control_output0: %d \n", i + 1, control_output0-32768);
    }

    return 0;
}
