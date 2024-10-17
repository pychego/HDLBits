#include "PID_ILC.h"
#include "unstable.h"

void PID_ILC(bool zero_output, int kp, int ki, int kd,
         int target0, int target1, int target2, int target3, int target4, int target5,
         int ssi0, int ssi1, int ssi2, int ssi3, int ssi4, int ssi5,
         bit16 *control_output0, bit16 *control_output1, bit16 *control_output2,
         bit16 *control_output3, bit16 *control_output4, bit16 *control_output5)
{
    // 在 vitis 上传P，I，D为整数
    float kp_float = kp / 100000.0;
    float ki_float = ki / 100000.0;
    float kd_float = kd / 100000.0;

    // PID参数与位移相乘， 位移单位mm
    float data_target_mm[6] = {target0 / 1000.0f, target1 / 1000.0f, target2 / 1000.0f,
                               target3 / 1000.0f, target4 / 1000.0f, target5 / 1000.0f};
    float data_real_mm[6] = {(ssi0 + compensateLength) / 1000.0f, (ssi1 + compensateLength) / 1000.0f,
                             (ssi2 + compensateLength) / 1000.0f, (ssi3 + compensateLength) / 1000.0f,
                             (ssi4 + compensateLength) / 1000.0f, (ssi5 + compensateLength) / 1000.0f};

    // 使用static修饰很重要
    // 依次定义六个PID误差和输入量
    static float error[6] = {0, 0, 0, 0, 0, 0};
    static float error_p[6] = {0, 0, 0, 0, 0, 0};
    static float error_pp[6] = {0, 0, 0, 0, 0, 0};
    static float control_temp[6] = {0, 0, 0, 0, 0, 0};
    static float control_output_reg[6] = {0, 0, 0, 0, 0, 0};
    /*6个误差量定义完毕 */

    float param_k0 = kp_float + ki_float + kd_float;
    float param_k1 = kp_float + 2 * kd_float;
    float param_k2 = kd_float;

    // 将error_p赋值给error_pp
    for (int i = 0; i < 6; i++)
    {
        error_pp[i] = error_p[i];
    }
    // 将error赋值给error_p
    for (int i = 0; i < 6; i++)
    {
        error_p[i] = error[i];
    }

    // 计算error
    for (int i = 0; i < 6; i++)
    {
        error[i] = data_target_mm[i] - data_real_mm[i];
    }
    // 计算control_temp
    for (int i = 0; i < 6; i++)
    {
        control_temp[i] += param_k0 * error[i] - param_k1 * error_p[i] + param_k2 * error_pp[i];
    }

    for (int i = 0; i < 6; i++)
    {
        if (control_temp[i] > 32767)
        {
            control_output_reg[i] = 32767;
        }
        else if (control_temp[i] < -32768)
        {
            control_output_reg[i] = -32768;
        }
        else
        {
            control_output_reg[i] = control_temp[i];
        }
    }

    // 这个判断主要是为了vitis设置关闭程序后，让DAC输出电压为0
    if (zero_output == 1)
    {
        control_output_reg[0] = 0;
        control_output_reg[1] = 0;
        control_output_reg[2] = 0;
        control_output_reg[3] = 0;
        control_output_reg[4] = 0;
        control_output_reg[5] = 0;
    }

    *control_output0 = int(control_output_reg[0]) + 32768;
    *control_output1 = int(control_output_reg[1]) + 32768;
    *control_output2 = int(control_output_reg[2]) + 32768;
    *control_output3 = int(control_output_reg[3]) + 32768;
    *control_output4 = int(control_output_reg[4]) + 32768;
    *control_output5 = int(control_output_reg[5]) + 32768;
}
