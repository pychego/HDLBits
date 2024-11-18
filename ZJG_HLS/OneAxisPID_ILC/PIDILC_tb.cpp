#include "PID_ILC.h"
#include "unstable.h"
#include <iostream>
#include "PID_ILC.cpp"


int main()
{
    bool zero_output = 0;
    // ��pid����������ͬ,���target-ssiÿ��Ҳһ��,�ǿ������������ͬ��
    int kp = 0;
    int ki = 0;
    int kd = 0;
    bit16 control_output0;

    int num_samples = 4000;   // ���ݵ���, 3������
    int sampling_rate = 1000;  // ������ (Hz) ����
    float error[num_samples]; // ���ڴ洢���Ҳ��� error ����
    float time[num_samples];  // ���ڴ洢ʱ������

    // float u; // ���Խӿ�, �ۺ�ʱ��Ҫ�������

    // ����ʱ�������� error
    for (int i = 0; i < num_samples; i++)
    {
        time[i] = (float)i / sampling_rate;   // ʱ����������
        error[i] = sin(M_PI * time[i]); // �������Ҳ�
        // printf("�� %d ������,error= %.4f\n", i + 1, error[i]);
    }

    for (int i = 0; i < num_samples; i++)
    {
        PID_ILC(zero_output, kp, ki, kd,
                7000000, 20000000, 2, 100, // ILC����
                floor(error[i]*1000),
                0-compensateLength,
                &control_output0);
        
        // �˴�����Ǵ�ILC���,������PID���
        // std::cout << "control_output0: " << control_output0-32768 << std::endl;
        printf("�� %d �����,  control_output0: %d \n", i + 1,  control_output0-32768);
        // printf("�� %d �����, control_output0: %d \n", i + 1, control_output0-32768);
    }

    return 0;
}
