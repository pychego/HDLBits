#ifndef __IDEAL2DISTURB_H__
#define __IDEAL2DISTURB_H__


typedef float THETA_TYPE;
typedef float COS_SIN_TYPE;

#define NUM_ITERATIONS 20

/* 输入: a,b,c XYZ欧拉角，单位（角度）
 * 输出: R 旋转矩阵
*/
void RxRyRzFunction(float a, float b, float c, float R[3][3]);

/* 输入: R 3x3矩阵
 * 输出: Rt R的转置
*/
void transpose(float R[3][3], float Rt[3][3]);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

/* 输入: pose1 实际diaturb在base下的位姿
 * 输出: pose2 理想platform在disturb下的位姿
    !!! 注意, 理想platform的位姿是自己指定的，仿真这里默认为[0,0,97,0,0,0]
*/
void IdealPlatform2disturb(float pose1[6], float pose2[6]);

#endif
