#ifndef _SHIFT_LED_H_

#define _SHIFT_LED_H_

// 加入设置int自定义位宽的头文件

#include "ap_int.h"


// 设置等半秒动一次，开发板时钟频率是100MHz
// # define MAX_CNT 1000/2   // 仅用于仿真，不然时间比较长
# define MAX_CNT 100000000

#define SHIFT_FLAG MAX_CNT-2

typedef int led_t;
typedef int cnt32_t;    // 计数器

void shift_led(led_t *led_o, led_t led_i);

#endif
