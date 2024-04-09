#ifndef __ITERATIONFUNCTION_H__
#define __ITERATIONFUNCTION_H__

/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/
void IteationFunction(float pose[6], float lengths[6], float f[6]);

#endif