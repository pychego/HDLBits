#ifndef __PID_ILC_H__
#define __PID_ILC_H__
#include"math.h"
#include <iostream>

typedef unsigned short bit16;


/*
PID参数
	kp: 比例系数
	ki: 积分系数
	kd: 微分系数
ILC参数
	ILCK_p: ILC比例系数
	ILCK_d: ILC微分系数
	Ts: 采样周期
	maxILC: ILC最大输出,已经限制PID最大输出16384, ILC最大输出不能超过16384

计算时的error以mm为单位
*/
void PID_ILC(bool zero_output, int kp, int ki, int kd, // PID参数
			 int ILCK_p, int ILCK_d, int Ts, int maxILC, // ILC参数
			 int target0, int target1, int target2, int target3, int target4, int target5,
			 int ssi0, int ssi1, int ssi2, int ssi3, int ssi4, int ssi5,
			 float u[6],	// 测试接口, 综合时不要这个参数
			 bit16 *control_output0, bit16 *control_output1, bit16 *control_output2,
			 bit16 *control_output3, bit16 *control_output4, bit16 *control_output5);

#endif
