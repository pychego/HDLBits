#ifndef __ZJGCompensation__
#define __ZJGCompensation__


#define N 6

#define NUM_ITERATIONS 20

#define DEG2RAD 0.017453

#define RAD2DEG 57.29578


/* 输入: pose 神经网络/迭代得到的位姿
        lengths 正解输入的腿长
   输出: f 满足迭代精度后的腿长与lengths的差值
*/

void cordic(float theta, float *s, float *c);


void Jacobian(float x, float y, float z, float a, float b, float c, float J[6][6]);

/* 输入: ReferPose      从BRAM中读取的目标位姿
        RealPose       正解得到的实时位姿
        InverseTargets 反解得到的目标腿长
   输出: AllTargets     补偿腿长 + 反解得到的目标腿长
*/
void  ZJGCompensation(float ReferPose[6], float RealPose[6], float InverseTargets[6], float AllTargets[6]);

# endif