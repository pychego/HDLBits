#ifndef __INVERSE_H__
#define __INVERSE_H__

//#include <ap_fixed.h>

struct Reference
{
    int X;
    int Y;
    int Z;
    int A;
    int B;
    int C;
};

struct Target
{
    int target1;
    int target2;
    int target3;
    int target4;
    int target5;
    int target6;
};


typedef int INT_TYPE;
// 这个module不要使用定点数,精度损失极多
// 将RTYPE 设置为 ap_fixed<28,8> 计算的结果完全错误
typedef float RTYPE;
typedef signed char int8_t;


typedef float THETA_TYPE;
typedef float COS_SIN_TYPE;

#define NUM_ITERATIONS  20
/* 输入: 六个位姿, 角度一律为度(deg),送入的是放大10000倍的整数
    pose[6] = {x, y, z, a, b, c}
 * 输出: 六根腿的长度,是实际长度放大了10000倍
 *
 * 例如: 位姿(1.5689, 3.3456, 180.9055, 1.2, 4.5, 5.67)
 * 则输入就是(15689, 33456, 1809055, 12000, 45000, 56700)
 * 可以直接在设计coe文件时扩大倍数成为整数
 * 如果实际腿长为1708.45, 则输出的就是170845
 */
void inverse(INT_TYPE pose[6], struct Target* target);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

#endif
