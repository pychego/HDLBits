#ifndef __COMPENSATION_H__
#define __COMPENSATION_H__

// N: 矩阵的维度
#define N 6

// CORDIC求解sin和cos的迭代次数
#define NUM_ITERATIONS 26

#define DEG2RAD M_PI / 180

#define RAD2DEG 57.2958

#define pi M_PI

typedef float RTYPE;

typedef float THETA_TYPE;

typedef float COS_SIN_TYPE;



void mlp(float x[6], float y[6]);

/* 输入: pose    神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void IterationFunction(float pose[6], float lengths[6], float f[6]);

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c);

// 使用的是这个
void Jacobian_cordic(float x, float y, float z, float a, float b, float c, float J[6][6]);


/* 以下4个函数是一体的,尽量不进行改动
   前三个是 inverseMatrix 的子函数
   输入: mat  待求逆的矩阵
   输出: inv  逆矩阵
*/
void luDecomposition(float mat[N][N], float lower[N][N], float upper[N][N], int pivot[N]);
void forwardSubstitution(float lower[N][N], float b[N], float y[N]);
void backwardSubstitution(float upper[N][N], float y[N], float x[N]);
void inverseMatrix(float mat[N][N], float inv[N][N]);

/* 下平台正解模块
    输入: lengths 6个腿长
    输出: pose    位姿{x, y, z, a, b, c}  姿态角位XYZ欧拉角, 输出角度
*/
void downDirectSolution(float lengths[6], float pose[6]);

/* 上平台正解模块(接口同上)
    输入: lengths 6个腿长
    输出: pose    位姿{x, y, z, a, b, c}  姿态角位XYZ欧拉角, 输出角度
*/
void upDirectSolution(float lengths[6], float pose[6]);

# endif