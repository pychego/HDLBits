#include "pid.h"

/* PID控制代码已和Vitis HLS保持同步
 */
void pid(bool zero_output, int kp, int ki, int kd, int data_target, int data_real, Bit_16 *control_output)
{
    // #pragma HLS INTERFACE ap_ctrl_none port=return
    //  在 vitis 上传P，I，D为整数
    float kp_float = kp / 10000.0;
    float ki_float = ki / 10000.0;
    float kd_float = kd / 10000.0;

    // 使用static修饰很重要
    static int error = 0;
    static int error_p = 0;
    static int error_pp = 0;
    static float control_temp = 0;
    static float control_output_reg = 0;

    float param_k0 = kp_float + ki_float + kd_float;
    float param_k1 = kp_float + 2 * kd_float;
    float param_k2 = kd_float;

    error_pp = error_p;
    error_p = error;
    error = data_target - data_real;
    // 这里代码之前写错了，要和高的公式(4-6)一致
    control_temp += param_k0 * error - param_k1 * error_p + param_k2 * error_pp;
    if (control_temp > 32767)
    {
        control_output_reg = 32767;
    }
    else if (control_temp < -32768)
    {
        control_output_reg = -32768;
    }
    else
    {
        control_output_reg = control_temp;
    }

    // 这个判断主要是为了vitis设置关闭程序后，让DAC输出电压为0
    if (zero_output == 1)
    {
        control_output_reg = 0;
    }

    *control_output = int(control_output_reg) + 32768;
}
