#ifndef __PID_H__
#define __PID_H__

// #include "ap_int.h"

typedef unsigned short Bit_16;

void pid(bool zero_output, int kp, int ki, int kd, int data_target, int data_real, Bit_16 *control_output);

#endif
