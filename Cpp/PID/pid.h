#ifndef __PID_H__
#define __PID_H__

#define N 6


void pid(int kp, int ki, int kd, int data_target, int data_real, int *control_output);



# endif