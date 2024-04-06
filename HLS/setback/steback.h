#ifndef __STEBACK_H_
#define __STEBACK_H_

#include <ap_fixed.h>

//typedef ap_fixed<32,24, AP_RND, AP_SAT>  DATA_TYPE;
typedef float DATA_TYPE;
typedef int INT_TYPE;

void steBack(INT_TYPE cos[3], INT_TYPE sin[3], INT_TYPE trans[3], INT_TYPE ret[6]);

#endif
