#ifndef __PID_H__
#define __PID_H__
#include <iostream>

typedef unsigned short Bit_16;

static int compensateLength = 1408300;   // 这个需要改  140.83 * 10000

void pid(bool zero_output, int kp, int ki, int kd,
		int target0, int target1, int target2, int target3, int target4, int target5,
		int ssi0, int ssi1, int ssi2, int ssi3, int ssi4, int ssi5,
		Bit_16 *control_output0, Bit_16 *control_output1, Bit_16 *control_output2,
		Bit_16 *control_output3, Bit_16 *control_output4, Bit_16 *control_output5);
# endif
