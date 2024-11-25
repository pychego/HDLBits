/*
根据matlab Jacobian得到的C++代码
*/
#include "DirectSolution.h"
#include "math.h"
using namespace std;

void Jacobian(float x, float y, float z, float a, float b, float c, float J[6][6])
{

    // a = a * 3.141592653589793 / 180;
    // b = b * 3.141592653589793 / 180;
    // c = c * 3.141592653589793 / 180;
    float sina, sinb, sinc, cosa, cosb, cosc;

    cordic(a, &sina, &cosa);
    cordic(b, &sinb, &cosb);
    cordic(c, &sinc, &cosc);
    float x108, x107, x106, x105, x104, x103, x102, x101, x100, x99, x98, x97, x96,
        x95, x94, x93, x92, x91, x90, x89, x88, x87, x86, x85, x84, x83, x82,
        x81, x80, x79, x78, x77, x76, x75, x74, x73, x72, x71, x70, x69, x68, x67,
        x66, x65, x64, x63, x62, x61, x60, x59, x58, x57, x56, x55, x54, x53, x52, x51,
        x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x40, x39, x38, x37, x36, x35, x34,
        x33, x32, x31, x30, x29, x28, x27, x26, x25, x24, x23, x22, x21, x20, x19, x18, x17, x16,
        x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1;

    x108 = 63.124 * cosb * sinc;
    x107 = 49.146 * cosb * cosc;
    x106 = 63.124 * cosa * cosc;
    x105 = 49.146 * cosa * sinc;
    x104 = 49.146 * cosc * sina * sinb;
    x103 = 63.124 * sina * sinb * sinc;
    x102 = 49.146 * sina * sinc;
    x101 = 63.124 * cosc * sina;
    x100 = 49.146 * cosa * cosc * sinb;
    x99 = 63.124 * cosa * sinb * sinc;
    x98 = 30.094 * cosb * cosc;
    x97 = 74.124 * cosb * sinc;
    x96 = 30.094 * sina * sinc;
    x95 = 74.124 * cosc * sina;
    x94 = 74.124 * cosa * sinb * sinc;
    x93 = 30.094 * cosa * cosc * sinb;
    x92 = 30.094 * cosa * sinc;
    x91 = 74.124 * cosa * cosc;
    x90 = 74.124 * sina * sinb * sinc;
    x89 = 30.094 * cosc * sina * sinb;
    x88 = 79.24 * cosb * cosc;
    x87 = 11.0 * cosb * sinc;
    x86 = 11.0 * cosc * sina;
    x85 = 79.24 * sina * sinc;
    x84 = 79.24 * cosa * cosc * sinb;
    x83 = 11.0 * cosa * sinb * sinc;
    x82 = 11.0 * cosa * cosc;
    x81 = 79.24 * cosa * sinc;
    x80 = 79.24 * cosc * sina * sinb;
    x79 = 11.0 * sina * sinb * sinc;
    x78 = x + x107 - x108 - 99.015;
    x77 = y + x106 + x105 + x104 - x103 - 14;
    x76 = z + x102 + x101 - x100 + x99;
    x75 = x + x98 - x97 + 37.383;
    x74 = z + x96 + x95 - x93 + x94;
    x73 = y + x91 + x92 + x89 - x90 - 92.75;
    x72 = x + x107 + x108 - 99.015;
    x71 = y - x106 + x105 + x104 + x103 + 14;
    x70 = x101 - x102 - z + x100 + x99;
    x69 = x + x98 + x97 + 37.383;
    x68 = x95 - x96 - z + x93 + x94;

    x67 = y - x91 + x92 + x89 + x90 + 92.75;
    x66 = x - x88 + x87 + 61.632;
    x65 = x85 - z + x86 - x84 + x83;
    x64 = y - x82 - x81 - x80 + x79 + 78.75;
    x63 = x - x88 - x87 + 61.632;
    x62 = z - x85 + x86 + x84 + x83;
    x61 = x81 - x82 - y + x80 + x79 + 78.75;
    x60 = 1;
    x59 = 1;
    x58 = 1;
    x57 = 1;
    x56 = 1;
    x55 = 1;
    x54 = sqrt(pow(x78, 2) + pow(x76, 2) + pow(x77, 2));
    x53 = sqrt(pow(x75, 2) + pow(x74, 2) + pow(x73, 2));
    x52 = sqrt(pow(x70, 2) + pow(x72, 2) + pow(x71, 2));
    x51 = sqrt(pow(x69, 2) + pow(x67, 2) + pow(x68, 2));
    x50 = sqrt(pow(x66, 2) + pow(x64, 2) + pow(x65, 2));
    x49 = sqrt(pow(x61, 2) + pow(x62, 2) + pow(x63, 2));

    x48 = 11.0 * sina * sinc;
    x47 = 30.094 * cosa * cosc;
    x46 = 11.0 * sinb * sinc;
    x45 = 63.124 * cosb * cosc;
    x44 = 30.094 * cosc * sina;
    x43 = 30.094 * cosb * sinc;
    x42 = 30.094 * cosc * sinb;
    x41 = 63.124 * cosa * sinc;
    x40 = 63.124 * sina * sinc;
    x39 = 63.124 * sinb * sinc;
    x38 = 74.124 * cosb * cosc;
    x37 = 79.24 * cosa * cosc;
    x36 = 11.0 * cosb * cosc;
    x35 = 74.124 * cosa * sinc;
    x34 = 79.24 * cosc * sina;
    x33 = 79.24 * cosb * sinc;
    x32 = 79.24 * cosc * sinb;
    x31 = 49.146 * cosa * cosc;
    x30 = 11.0 * cosa * sinc;
    x29 = 74.124 * sina * sinc;
    x28 = 74.124 * sinb * sinc;
    x27 = 49.146 * cosc * sina;
    x26 = 49.146 * cosb * sinc;
    x25 = 49.146 * cosc * sinb;
    x24 = 79.24 * cosa * cosb * cosc;
    x23 = 74.124 * cosa * cosb * sinc;
    x22 = 74.124 * cosa * cosc * sinb;
    x21 = 79.24 * cosb * cosc * sina;
    x20 = 49.146 * cosa * cosb * cosc;
    x19 = 11.0 * cosa * cosb * sinc;
    x18 = 11.0 * cosa * cosc * sinb;
    x17 = 74.124 * cosb * sina * sinc;
    x16 = 74.124 * cosc * sina * sinb;
    x15 = 79.24 * cosa * sinb * sinc;
    x14 = 49.146 * cosb * cosc * sina;
    x13 = 11.0 * cosb * sina * sinc;
    x12 = 11.0 * cosc * sina * sinb;
    x11 = 30.094 * cosa * cosb * cosc;
    x10 = 79.24 * sina * sinb * sinc;
    x9 = 49.146 * cosa * sinb * sinc;
    x8 = 30.094 * cosb * cosc * sina;
    x7 = 63.124 * cosa * cosb * sinc;
    x6 = 63.124 * cosa * cosc * sinb;
    x5 = 49.146 * sina * sinb * sinc;
    x4 = 30.094 * cosa * sinb * sinc;
    x3 = 63.124 * cosb * sina * sinc;
    x2 = 63.124 * cosc * sina * sinb;
    x1 = 30.094 * sina * sinb * sinc;

    float x51_180, x52_180, x53_180, x54_180, x50_180, x49_180;
    x54_180 = x54 * RAD2DEG;
    x53_180 = x53 * RAD2DEG;
    x52_180 = x52 * RAD2DEG;
    x51_180 = x51 * RAD2DEG;
    x50_180 = x50 * RAD2DEG;
    x49_180 = x49 * RAD2DEG;

    J[0][0] = x72 / x52;
    J[0][1] = x71 / x52;
    J[0][2] = -x70 / x52;
    J[0][3] = (x71 * (x101 - x102 + x100 + x99) - x70 * (x105 - x106 + x104 + x103)) / x52_180;
    J[0][4] = (x71 * (x14 + x3) - x72 * (x39 + x25) + x70 * (x20 + x7)) / x52_180;
    J[0][5] = (x71 * (x31 + x41 + x2 - x5) + x72 * (x45 - x26) - x70 * (x40 + x27 - x6 + x9)) / x52_180;

    J[1][0] = x78 / x54;
    J[1][1] = x77 / x54;
    J[1][2] = x76 / x54;
    J[1][3] = -(x77 * (x102 + x101 - x100 + x99) - x76 * (x106 + x105 + x104 - x103)) / x54_180;
    J[1][4] = (x77 * (x14 - x3) - x76 * (x20 - x7) + x78 * (x39 - x25)) / x54_180;
    J[1][5] = -(x77 * (x41 - x31 + x2 + x5) - x76 * (x27 - x40 + x6 + x9) + x78 * (x45 + x26)) / x54_180;

    J[2][0] = x75 / x53;
    J[2][1] = x73 / x53;
    J[2][2] = x74 / x53;
    J[2][3] = -(x73 * (x96 + x95 - x93 + x94) - x74 * (x91 + x92 + x89 - x90)) / x53_180;
    J[2][4] = (x73 * (x8 - x17) - x74 * (x11 - x23) + x75 * (x28 - x42)) / x53_180;
    J[2][5] = -(x73 * (x35 - x47 + x16 + x1) - x74 * (x44 - x29 + x22 + x4) + x75 * (x38 + x43)) / x53_180;

    J[3][0] = x63 / x49;
    J[3][1] = -x61 / x49;
    J[3][2] = x62 / x49;
    J[3][3] = (x61 * (x86 - x85 + x84 + x83) - x62 * (x81 - x82 + x80 + x79)) / x49_180;
    J[3][4] = (x63 * (x46 + x32) + x61 * (x21 + x13) + x62 * (x24 + x19)) / x49_180;
    J[3][5] = -(x63 * (x36 - x33) - x61 * (x37 + x30 + x12 - x10) + x62 * (x48 + x34 - x18 + x15)) / x49_180;

    J[4][0] = x66 / x50;
    J[4][1] = x64 / x50;
    J[4][2] = -x65 / x50;
    J[4][3] = (x65 * (x82 + x81 + x80 - x79) + x64 * (x85 + x86 - x84 + x83)) / x50_180;
    J[4][4] = -(x66 * (x46 - x32) + x65 * (x24 - x19) + x64 * (x21 - x13)) / x50_180;
    J[4][5] = (x65 * (x34 - x48 + x18 + x15) + x64 * (x30 - x37 + x12 + x10) + x66 * (x36 + x33)) / x50_180;

    J[5][0] = x69 / x51;
    J[5][1] = x67 / x51;
    J[5][2] = -x68 / x51;
    J[5][3] = (x67 * (x95 - x96 + x93 + x94) - x68 * (x92 - x91 + x90 + x89)) / x51_180;
    J[5][4] = (x67 * (x8 + x17) + x68 * (x11 + x23) - x69 * (x28 + x42)) / x51_180;
    J[5][5] = (x67 * (x47 + x35 + x16 - x1) - x68 * (x29 + x44 - x22 + x4) + x69 * (x38 - x43)) / x51_180;
}
