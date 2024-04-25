#ifndef __MLP_H__
#define __MLP_H__

#include <Eigen/Dense>

typedef float RTYPE;


void mlp(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void IterationFunction(Eigen::Matrix<float, 6, 1> pose, float lengths[6], Eigen::Matrix<float, 6, 1>& f);

void Jacobian(float x, float y, float z, float a, float b, float c, Eigen::Matrix<float, 6, 6>& J);

# endif