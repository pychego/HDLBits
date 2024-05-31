#ifndef __INVERSE_H__
#define __INVERSE_H__

float up_B[6][3] = {
    {6.1219f, -24.4478f, 4.0000f},
    {24.2334f, 6.9222f, 4.0000f},
    {18.1115f, 17.5257f, 4.0000f},
    {-18.1115f, 17.5257f, 4.0000f},
    {-24.2334f, 6.9222f, 4.0000f},
    {-6.1219f, -24.4478f, 4.0000f}};

// 上 stwart 的参数
// 定义六个腿的平台坐标(在platform随体坐标系下)
float up_P[6][3] = {
    {11.0404f, -10.4546f, -4.0000f},
    {14.5742f, -4.3340f, -4.0000f},
    {3.5337f, 14.7886f, -4.0000f},
    {-3.5337f, 14.7886f, -4.0000f},
    {-14.5742f, -4.3340f, -4.0000f},
    {-11.0404f, -10.4546f, -4.0000f}};

typedef int INT_TYPE;
// 这个module不要使用定点数,精度损失极多
// 将RTYPE 设置为 ap_fixed<28,8> 计算的结果完全错误
typedef float RTYPE;
typedef signed char int8_t;


typedef float THETA_TYPE;
typedef float COS_SIN_TYPE;

#define NUM_ITERATIONS  20

/*  输入: pose 位姿
    输出: lengths 腿长
*/
void upInverseSolution(float pose[6], float lengths[6]);

void cordic(float theta, float *s, float *c);

#endif
