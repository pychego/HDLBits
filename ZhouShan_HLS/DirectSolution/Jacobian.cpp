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

    x108 = 33.1552 * cosb * cosc;
    x107 = 37.4264 * cosb * sinc;
    x106 = 37.4264 * cosa * cosc;
    x105 = 33.1552 * cosa * sinc;
    x104 = 33.1552 * cosc * sina * sinb;
    x103 = 37.4264 * sina * sinb * sinc;
    x102 = 37.4264 * cosc * sina;
    x101 = 33.1552 * sina * sinc;
    x100 = 33.1552 * cosa * cosc * sinb;
    x99 = 37.4264 * cosa * sinb * sinc;
    x98 = 15.8346 * cosb * cosc;
    x97 = 47.4264 * cosb * sinc;
    x96 = 15.8346 * sina * sinc;
    x95 = 47.4264 * cosc * sina;
    x94 = 47.4264 * cosa * sinb * sinc;
    x93 = 15.8346 * cosa * cosc * sinb;
    x92 = 15.8346 * cosa * sinc;
    x91 = 47.4264 * cosa * cosc;
    x90 = 47.4264 * sina * sinb * sinc;
    x89 = 15.8346 * cosc * sina * sinb;
    x88 = 10.0 * cosb * sinc;
    x87 = 48.9898 * cosb * cosc;
    x86 = 48.9898 * sina * sinc;
    x85 = 10.0 * cosc * sina;
    x84 = 10.0 * cosa * sinb * sinc;
    x83 = 48.9898 * cosa * cosc * sinb;
    x82 = 10.0 * cosa * cosc;
    x81 = 48.9898 * cosa * sinc;
    x80 = 10.0 * sina * sinb * sinc;
    x79 = 48.9898 * cosc * sina * sinb;
    x78 = x + x108 - x107 - 79.3725;
    x77 = y + x106 + x105 + x104 - x103 - 10;
    x76 = z + x101 + x102 - x100 + x99;
    x75 = x + x98 - x97 + 31.026;
    x74 = z + x96 + x95 - x93 + x94;
    x73 = y + x91 + x92 + x89 - x90 - 73.7386;
    x72 = x - x87 + x88 + 48.3465;
    x71 = x86 - z + x85 - x83 + x84;
    x70 = y - x82 - x81 - x79 + x80 + 63.7386;
    x69 = x - x87 - x88 + 48.3465;
    x68 = z - x86 + x85 + x83 + x84;

    x67 = x81 - x82 - y + x79 + x80 + 63.7386;
    x66 = x + x108 + x107 - 79.3725;
    x65 = y - x106 + x105 + x104 + x103 + 10;
    x64 = x102 - x101 - z + x100 + x99;
    x63 = x + x98 + x97 + 31.026;
    x62 = x95 - x96 - z + x93 + x94;
    x61 = y - x91 + x92 + x89 + x90 + 73.7386;
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

    x48 = 15.8346 * cosa * cosc;
    x47 = 47.4264 * sina * sinc;
    x46 = 47.4264 * sinb * sinc;
    x45 = 15.8346 * cosc * sina;
    x44 = 15.8346 * cosb * sinc;
    x43 = 15.8346 * cosc * sinb;
    x42 = 33.1552 * cosa * cosc;
    x41 = 37.4264 * cosb * cosc;
    x40 = 10.0 * cosb * cosc;
    x39 = 33.1552 * cosc * sina;
    x38 = 33.1552 * cosb * sinc;
    x37 = 33.1552 * cosc * sinb;
    x36 = 37.4264 * cosa * sinc;
    x35 = 47.4264 * cosb * cosc;
    x34 = 10.0 * cosa * sinc;
    x33 = 48.9898 * cosa * cosc;
    x32 = 37.4264 * sina * sinc;
    x31 = 37.4264 * sinb * sinc;
    x30 = 47.4264 * cosa * sinc;
    x29 = 10.0 * sina * sinc;
    x28 = 10.0 * sinb * sinc;
    x27 = 48.9898 * cosc * sina;
    x26 = 48.9898 * cosb * sinc;
    x25 = 48.9898 * cosc * sinb;
    x24 = 33.1552 * cosa * cosb * cosc;
    x23 = 33.1552 * cosb * cosc * sina;
    x22 = 37.4264 * cosa * cosb * sinc;
    x21 = 37.4264 * cosa * cosc * sinb;
    x20 = 10.0 * cosa * cosb * sinc;
    x19 = 10.0 * cosa * cosc * sinb;
    x18 = 48.9898 * cosa * cosb * cosc;
    x17 = 33.1552 * cosa * sinb * sinc;
    x16 = 37.4264 * cosb * sina * sinc;
    x15 = 37.4264 * cosc * sina * sinb;
    x14 = 47.4264 * cosa * cosb * sinc;
    x13 = 47.4264 * cosa * cosc * sinb;
    x12 = 10.0 * cosb * sina * sinc;
    x11 = 10.0 * cosc * sina * sinb;
    x10 = 48.9898 * cosb * cosc * sina;
    x9 = 33.1552 * sina * sinb * sinc;
    x8 = 15.8346 * cosa * cosb * cosc;
    x7 = 47.4264 * cosb * sina * sinc;
    x6 = 47.4264 * cosc * sina * sinb;
    x5 = 48.9898 * cosa * sinb * sinc;
    x4 = 15.8346 * cosb * cosc * sina;
    x3 = 48.9898 * sina * sinb * sinc;
    x2 = 15.8346 * cosa * sinb * sinc;
    x1 = 15.8346 * sina * sinb * sinc;

    float x51_180, x52_180, x53_180, x54_180, x50_180, x49_180;
    x54_180 = x54 * RAD2DEG;
    x53_180 = x53 * RAD2DEG;
    x52_180 = x52 * RAD2DEG;
    x51_180 = x51 * RAD2DEG;
    x50_180 = x50 * RAD2DEG;
    x49_180 = x49 * RAD2DEG;

    J[0][0] = x66 / x50;
    J[0][1] = x65 / x50;
    J[0][2] = -x64 / x50;
    J[0][3] = -(x64 * (x105 - x106 + x104 + x103) - x65 * (x102 - x101 + x100 + x99)) / x50_180;
    J[0][4] = (x65 * (x23 + x16) - x66 * (x31 + x37) + x64 * (x24 + x22)) / x50_180;
    J[0][5] = (x66 * (x41 - x38) - x64 * (x32 + x39 - x21 + x17) + x65 * (x42 + x36 + x15 - x9)) / x50_180;

    J[1][0] = x78 / x54;
    J[1][1] = x77 / x54;
    J[1][2] = x76 / x54;
    J[1][3] = (x76 * (x106 + x105 + x104 - x103) - x77 * (x101 + x102 - x100 + x99)) / x54_180;
    J[1][4] = (x78 * (x31 - x37) + x77 * (x23 - x16) - x76 * (x24 - x22)) / x54_180;
    J[1][5] = -(x78 * (x41 + x38) - x76 * (x39 - x32 + x21 + x17) + x77 * (x36 - x42 + x15 + x9)) / x54_180;

    J[2][0] = x75 / x53;
    J[2][1] = x73 / x53;
    J[2][2] = x74 / x53;
    J[2][3] = (x74 * (x91 + x92 + x89 - x90) - x73 * (x96 + x95 - x93 + x94)) / x53_180;
    J[2][4] = (x75 * (x46 - x43) - x74 * (x8 - x14) + x73 * (x4 - x7)) / x53_180;
    J[2][5] = -(x75 * (x35 + x44) - x74 * (x45 - x47 + x13 + x2) + x73 * (x30 - x48 + x6 + x1)) / x53_180;

    J[3][0] = x69 / x51;
    J[3][1] = -x67 / x51;
    J[3][2] = x68 / x51;
    J[3][3] = -(x68 * (x81 - x82 + x79 + x80) - x67 * (x85 - x86 + x83 + x84)) / x51_180;
    J[3][4] = (x68 * (x18 + x20) + x67 * (x10 + x12) + x69 * (x28 + x25)) / x51_180;
    J[3][5] = -(x68 * (x29 + x27 - x19 + x5) - x67 * (x33 + x34 + x11 - x3) + x69 * (x40 - x26)) / x51_180;

    J[4][0] = x72 / x52;
    J[4][1] = x70 / x52;
    J[4][2] = -x71 / x52;
    J[4][3] = (x70 * (x86 + x85 - x83 + x84) + x71 * (x82 + x81 + x79 - x80)) / x52_180;
    J[4][4] = -(x70 * (x10 - x12) + x71 * (x18 - x20) + x72 * (x28 - x25)) / x52_180;
    J[4][5] = (x70 * (x34 - x33 + x11 + x3) + x71 * (x27 - x29 + x19 + x5) + x72 * (x40 + x26)) / x52_180;

    J[5][0] = x63 / x49;
    J[5][1] = x61 / x49;
    J[5][2] = -x62 / x49;
    J[5][3] = -(x62 * (x92 - x91 + x89 + x90) - x61 * (x95 - x96 + x93 + x94)) / x49_180;
    J[5][4] = (x62 * (x8 + x14) - x63 * (x46 + x43) + x61 * (x4 + x7)) / x49_180;
    J[5][5] = (x63 * (x35 - x44) - x62 * (x47 + x45 - x13 + x2) + x61 * (x48 + x30 + x6 - x1)) / x49_180;
}
