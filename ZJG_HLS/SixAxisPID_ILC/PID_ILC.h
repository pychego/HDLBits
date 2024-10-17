#ifndef __PID_H__
#define __PID_H__
#include <iostream>

typedef unsigned short bit16;

void PID_ILC(bool zero_output, int kp, int ki, int kd, // PID参数
			 int target0, int target1, int target2, int target3, int target4, int target5,
			 int ssi0, int ssi1, int ssi2, int ssi3, int ssi4, int ssi5,
			 bit16 *control_output0, bit16 *control_output1, bit16 *control_output2,
			 bit16 *control_output3, bit16 *control_output4, bit16 *control_output5);
#endif
