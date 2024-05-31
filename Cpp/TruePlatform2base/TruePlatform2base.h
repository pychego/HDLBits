#ifndef __2base_H__
#define __2base_H__


typedef float THETA_TYPE;
typedef float COS_SIN_TYPE;

#define NUM_ITERATIONS 20

// 输入角度制，输出旋转矩阵
void RxRyRzFunction(float a, float b, float c, float R[3][3]);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

/* 输入: pose1 disturb在base中的位姿
 *      pose2 实际platform在disturb中的位姿
 * 输出: pose3 实际disturb在base中的位姿(其中z高度是真是高度,算上了基础高度)
*/
void TruePlatform2base(float pose1[6], float pose2[6], float pose3[6]);

#endif
