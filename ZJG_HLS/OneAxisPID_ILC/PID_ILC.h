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
	ILCK_d: ILC微分系数(以上五个系数在PS上传时都放大了100000倍)
	Ts: 采样周期(单位s) 最大为10s
	maxILC: ILC最大输出,已经限制PID最大输出16384, ILC最大输出不能超过16384

计算时的error以mm为单位
*/
void PID_ILC(bool zero_output, int kp, int ki, int kd, // PID参数
			 int ILCK_p, int ILCK_d, int Ts, int maxILC, // ILC参数
			 int target0,
			 int ssi0,
			//  float * u,	// 测试接口, 综合时不要这个参数
			 bit16 *control_output0);

#endif
