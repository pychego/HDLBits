#ifndef __JACOBIAN_OP__
#define __JACOBIAN_OP__

#define N 6

#define NUM_ITERATIONS 20

#define DEG2RAD 0.017453

#define RAD2DEG 57.29578


typedef float RTYPE;

typedef float THETA_TYPE;

typedef float COS_SIN_TYPE;




/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);


void CompensationJacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);



# endif