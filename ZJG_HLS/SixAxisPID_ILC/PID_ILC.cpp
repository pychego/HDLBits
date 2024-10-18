#include "PID_ILC.h"
#include "unstable.h"
#include "math.h"

void PID_ILC(bool zero_output, int kp, int ki, int kd,         // PID参数
             int ILCK_p, int ILCK_d, int Ts, int maxILCoutput, // ILC参数
             int target0, int target1, int target2, int target3, int target4, int target5,
             int ssi0, int ssi1, int ssi2, int ssi3, int ssi4, int ssi5,
             float u[6],	// 测试接口, 综合时不要这个参数
             bit16 *control_output0, bit16 *control_output1, bit16 *control_output2,
             bit16 *control_output3, bit16 *control_output4, bit16 *control_output5)
{
    // PID参数与位移相乘，位移单位mm
    float target_length_mm[6] = {target0 / 1000.0f, target1 / 1000.0f, target2 / 1000.0f,
                                 target3 / 1000.0f, target4 / 1000.0f, target5 / 1000.0f};
    float real_length_mm[6] = {(ssi0 + compensateLength) / 1000.0f, (ssi1 + compensateLength) / 1000.0f,
                               (ssi2 + compensateLength) / 1000.0f, (ssi3 + compensateLength) / 1000.0f,
                               (ssi4 + compensateLength) / 1000.0f, (ssi5 + compensateLength) / 1000.0f};

    // 依次定义六个PID误差和输入量
    static float error[6] = {0, 0, 0, 0, 0, 0};
    static float error_p[6] = {0, 0, 0, 0, 0, 0};
    static float error_pp[6] = {0, 0, 0, 0, 0, 0};

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
        error[i] = target_length_mm[i] - real_length_mm[i];
    }

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

    // 设置存放数组, 由于static修饰不能使用变长数组,这里先设置一个较大的值,最长周期10s
    static float ILC_control[6][10000] = {0};
    static float Error_history[6][10000] = {0};
    static float Error_diff[6][10000] = {0};
    static int counter = 0; // 由于matlab从1开始，这里从0开始

    if (counter > N-1)
    {
        for (int i = 0; i < 6; i++)
        {
            u[i] = 0;
        }
    }
    else
    {
        for (int i = 0; i < 6; i++)
        {
            u[i] = ILC_control[i][counter];
        }
    }

    if (counter > 0)
    {
        for (int i = 0; i < 6; i++)
        {
            Error_history[i][counter - 1] = error[i];
        }
    }
    if (counter == N-1 )
    {
        for (int i = 0; i < 6; i++)
        {
            Error_history[i][counter] = Error_history[i][counter - 1];
        }
    }

    // 计算误差差分
    for (int i = 0; i < 6; i++)
    {
        Error_diff[i][0] = Error_history[i][1] - Error_history[i][0];
        for (int j = 1; j < N; j++)
        {
            Error_diff[i][j] = Error_history[i][j] - Error_history[i][j - 1];
        }
    }

    // 增加计数器
    counter++;

    // 如果一轮迭代完成，更新ILC控制信号
    if (counter > N-1)
    {
        for (int i = 0; i < 6; ++i)
        {
            for (int j = 0; j < N; ++j)
            {
                ILC_control[i][j] += ILCK_p_float * Error_history[i][j] + ILCK_d_float * Error_diff[i][j];
                // 限制ILC控制输出
                if (ILC_control[i][j] > maxILCoutput)
                {
                    ILC_control[i][j] = maxILCoutput;
                }
                else if (ILC_control[i][j] < -maxILCoutput)
                {
                    ILC_control[i][j] = -maxILCoutput;
                }
            }
        }
        // // 输出ILC_control[1]
        // for (int j = 0; j < N; ++j){
        //     printf("Error_history[1][%d]: %.4f\n", j, Error_history[1][j]);
        // }
        counter = 0; // 计数器重置为0
    }

    // 以下为PID控制部分=======================================================================================================
    // 使用static修饰很重要
    static float PID_control[6] = {0, 0, 0, 0, 0, 0};
    static float control_output_reg[6] = {0, 0, 0, 0, 0, 0};
    /*6个误差量定义完毕 */

    float param_k0 = kp_float + ki_float + kd_float;
    float param_k1 = kp_float + 2 * kd_float;
    float param_k2 = kd_float;

    // 计算PID_control
    for (int i = 0; i < 6; i++)
    {
        PID_control[i] += param_k0 * error[i] - param_k1 * error_p[i] + param_k2 * error_pp[i];
    }

    for (int i = 0; i < 6; i++)
    {
        if (PID_control[i] > 16384)        // 将单独PID输出现在在-5V到5V之间
        {
            control_output_reg[i] = 16384 + u[i];
        }
        else if (PID_control[i] < -16383)
        {
            control_output_reg[i] = -16383 + u[i];
        }
        else
        {
            control_output_reg[i] = PID_control[i] + u[i];
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
