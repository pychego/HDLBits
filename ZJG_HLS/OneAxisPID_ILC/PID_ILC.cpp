#include "PID_ILC.h"
#include "unstable.h"
#include "math.h"

void PID_ILC(bool zero_output, int kp, int ki, int kd,         // PID参数
             int ILCK_p, int ILCK_d, int Ts, int maxILCoutput, // ILC参数
             int target0,
             int ssi0,
            //  float * u, // 测试接口, 综合时不要这个参数
             bit16 *control_output0)
{
    // PID参数与位移相乘，位移单位mm
    float target_length_mm = target0 / 1000.0f;
    float real_length_mm = (ssi0 + compensateLength) / 1000.0f;

    // 依次定义六个PID误差和输入量
    static float error = 0;
    static float error_p = 0;
    static float error_pp = 0;

    // 将error_p赋值给error_pp
    error_pp = error_p;

    // 将error赋值给error_p
    error_p = error;

    // 计算error
    error = target_length_mm - real_length_mm;

    // 在 vitis 上传P，I，D为整数
    float kp_float = kp / 100000.0;
    float ki_float = ki / 100000.0;
    float kd_float = kd / 100000.0;

    // 设置 ILC参数
    float ILCK_p_float = ILCK_p / 100000.0;
    float ILCK_d_float = ILCK_d / 100000.0;

    float Duration = Ts;
    float SampleTime = 0.001;             // 与控制周期1ms匹配
    int N = round(Duration / SampleTime); // 一个周期内的采样点数

    // 设置存放数组, static修饰不能使用变长数组,这里先设置一个较大的值,最长周期10s
    static short ILC_control[10000] = {0};
    static float Error_history[10000] = {0};
    static float Error_diff[10000] = {0};
    static float u = 0;
    static int counter = 0; // 由于matlab从1开始，这里从0开始

    if (counter > N - 1)
    {
        u = 0;
    }
    else
    {
        u = ILC_control[counter];
    }

    if (counter > 0)
    {
        Error_history[counter - 1] = error;
    }
    if (counter == N - 1)
    {
        Error_history[counter] = Error_history[counter - 1];
    }

    // 以下两个判断语句求diff, 将diff的计算打散,平均分配到每个运行周期中以减小Latency
    if (counter > 1)
    {
        Error_diff[counter - 1] = Error_history[counter - 1] - Error_history[counter - 2];
        if (counter == 2)
        {
            Error_diff[0] = Error_diff[1];
        }
    }
    if (counter == N - 1)
    {
        Error_diff[counter] = Error_history[counter] - Error_history[counter - 1];
    }

    // 以下是将ILC_control的计算分散到每个控制周期
    if (counter == 2)
    {
        ILC_control[counter - 2] = ILC_control[counter - 2] + ILCK_p_float * Error_history[counter - 2] + ILCK_d_float * Error_diff[counter - 2];
        // 限制ILC控制输出
        if (ILC_control[counter - 2] > maxILCoutput)
        {
            ILC_control[counter - 2] = maxILCoutput;
        }
        else if (ILC_control[counter - 2] < -maxILCoutput)
        {
            ILC_control[counter - 2] = -maxILCoutput;
        }
    }
    if (counter >= 2)
    {
        ILC_control[counter - 1] = ILC_control[counter - 1] + ILCK_p_float * Error_history[counter - 1] + ILCK_d_float * Error_diff[counter - 1];
        // 限制ILC控制输出
        if (ILC_control[counter - 1] > maxILCoutput)
        {
            ILC_control[counter - 1] = maxILCoutput;
        }
        else if (ILC_control[counter - 1] < -maxILCoutput)
        {
            ILC_control[counter - 1] = -maxILCoutput;
        }
    }
    if (counter == N - 1)
    {
        ILC_control[counter] = ILC_control[counter] + ILCK_p_float * Error_history[counter] + ILCK_d_float * Error_diff[counter];
        // 限制ILC控制输出
        if (ILC_control[counter] > maxILCoutput)
        {
            ILC_control[counter] = maxILCoutput;
        }
        else if (ILC_control[counter] < -maxILCoutput)
        {
            ILC_control[counter] = -maxILCoutput;
        }
    }

    // 增加计数器
    counter++;
    if (counter > N - 1)
    {
        counter = 0;
    }

    // 以下为PID控制部分=======================================================================================================
    // 使用static修饰很重要
    static float PID_control = 0;
    static float control_output_reg = 0;
    /*6个误差量定义完毕 */

    float param_k0 = kp_float + ki_float + kd_float;
    float param_k1 = kp_float + 2 * kd_float;
    float param_k2 = kd_float;

    // 计算PID_control
    PID_control += param_k0 * error - param_k1 * error_p + param_k2 * error_pp;

    if (PID_control > 16384) // 将单独PID输出现在在-5V到5V之间
    {
        control_output_reg = 16384 + u;
    }
    else if (PID_control < -16383)
    {
        control_output_reg = -16383 + u;
    }
    else
    {
        control_output_reg = PID_control + u;
    }

    // 这个判断主要是为了vitis设置关闭程序后，让DAC输出电压为0
    if (zero_output == 1)
    {
        control_output_reg = 0;
    }

    *control_output0 = round(control_output_reg) + 32768;
}
