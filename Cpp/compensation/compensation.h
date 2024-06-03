#ifndef __COMPENSATION_H__
#define __COMPENSATION_H__

#define N 6                // 矩阵维度

#define MAX_ITERATION 3    // 正解最大迭代次数

#define EPS 0.0001         // 正解迭代精度

#define NUM_ITERATIONS 20  // CORDIC求解正余弦的迭代次数

#define DEG2RAD 0.01745329

#define RAD2DEG 57.2958

#define pi M_PI


void cordic(float theta, float *s, float *c);

/* 以下4个函数是一体的,尽量不进行改动
   前三个是 inverseMatrix 的子函数
   输入: mat  待求逆的矩阵
   输出: inv  逆矩阵
*/
void luDecomposition(float mat[N][N], float lower[N][N], float upper[N][N], int pivot[N]);
void forwardSubstitution(float lower[N][N], float b[N], float y[N]);
void backwardSubstitution(float upper[N][N], float y[N], float x[N]);
void inverseMatrix(float mat[N][N], float inv[N][N]);

void RxRyRzFunction(float a, float b, float c, float R[3][3]);

void TruePlatform2base(float pose1[6], float pose2[6], float pose3[6]);

void transpose(float R[3][3], float Rt[3][3]);

void IdealPlatform2disturb(float pose1[6], float pose2[6]);

void compensation(float downLengths[6], float upLengths[6], float target[6]);


# endif