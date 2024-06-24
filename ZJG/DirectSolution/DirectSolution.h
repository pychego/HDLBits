#ifndef __DirectSolution_H__
#define __DirectSolution_H__

#define N 6                // 矩阵维度

#define MAX_ITERATION 3    // 正解最大迭代次数

#define EPS 0.0001         // 正解迭代精度

#define NUM_ITERATIONS 20  // CORDIC求解正余弦的迭代次数

#define DEG2RAD 0.01745329

#define RAD2DEG 57.2958

typedef float RTYPE;

typedef float THETA_TYPE;

typedef float COS_SIN_TYPE;

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

void luDecomposition(float mat[N][N], float lower[N][N], float upper[N][N], int pivot[N]);

void forwardSubstitution(float lower[N][N], float b[N], float y[N]);

void backwardSubstitution(float upper[N][N], float y[N], float x[N]);

void inverseMatrix(float mat[N][N], float inv[N][N]);


#endif