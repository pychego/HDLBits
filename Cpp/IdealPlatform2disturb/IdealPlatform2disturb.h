#ifndef __IDEAL2DISTURB_H__
#define __IDEAL2DISTURB_H__


typedef float THETA_TYPE;
typedef float COS_SIN_TYPE;

#define NUM_ITERATIONS 26

// 输入角度制，输出旋转矩阵
void RxRyRzFunction(float a, float b, float c, float R[3][3]);

void transpose(float R[3][3], float Rt[3][3]);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

void IdealPlatform2disturb(float pose1[6], float pose2[6]);

#endif
