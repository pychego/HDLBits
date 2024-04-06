#ifndef __INVERSE_H__
#define __INVERSE_H__

// #include <ap_fixed.h>

typedef int INT_TYPE;


/* 输入: 六个位姿, 角度一律为度(deg),送入的是放大10000倍的整数
    pose[6] = {x, y, z, a, b, c}
 * 输出: 六根腿的长度,是实际长度放大了10000倍
 *
 * 例如: 位姿(1.5689, 3.3456, 180.9055, 1.2, 4.5, 5.67)
 * 则输入就是(15689, 33456, 1809055, 12000, 45000, 56700)
 * 可以直接在设计coe文件时扩大倍数成为整数
 * 如果实际腿长为1708.45, 则输出的就是170845
 */

void inverse(INT_TYPE pose[6], INT_TYPE lengths[6]);


#endif
