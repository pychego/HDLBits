#include "pid.h"

void pid(int rst_n, int start, int kp, int ki, int kd, int data_target, int data_real, int *control_output)
{
    float kp_float = kp / 10000.0;
    float ki_float = ki / 10000.0;
    float kd_float = kd / 10000.0;

    int error;
    int error_p;
    int error_pp;
    float control_temp;
    float control_output_reg;

    float param_k0 = kp_float + ki_float + kd_float;
    float param_k1 = kp_float + 2 * kd_float;
    float param_k2 = kd_float;

    if ((rst_n == 0) || (start == 0))
    {
        error = 0;
        error_p = 0;
        error_pp = 0;
        control_temp = 0.0;
        control_output_reg = 0.0;
    }
    else
    {
        error_pp = error_p;
        error_p = error;
        error = data_target - data_real;
        control_temp += param_k0 * error + param_k1 * error_p + param_k2 * error_pp;
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
    }

    *control_output = int(control_output_reg) + 32768;
}