#ifndef __MLP_H__
#define __MLP_H__


typedef float RTYPE;


void mlp(float x[6], float y[6]);

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
float * IteationFunction(float pose[6], float lengths[6]);

float ** Jacobian(float x, float y, float z, float a, float b, float c);

# endif