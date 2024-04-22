#ifndef __MLP_H__
#define __MLP_H__

#define N 6

#define NUM_ITERATIONS 15

#define DEG2RAD 0.017453

#define RAD2DEG 57.2958

typedef float RTYPE;

typedef float THETA_TYPE;

typedef float COS_SIN_TYPE;



void mlp(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void IterationFunction(float pose[6], float lengths[6], float f[6]);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

void Jacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);

void Jacobian_cordic(float x, float y, float z, float a, float b, float c, float J[6][6]);

void luDecomposition(float mat[N][N], float lower[N][N], float upper[N][N], int pivot[N]);

void forwardSubstitution(float lower[N][N], float b[N], float y[N]);

void backwardSubstitution(float upper[N][N], float y[N], float x[N]);

void inverseMatrix(float mat[N][N], float inv[N][N]);

# endif