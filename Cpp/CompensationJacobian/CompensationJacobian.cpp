/*
根据matlab Jacobian得到的C++代码
*/
#include "CompensationJacobian.h"
#include "math.h"
using namespace std;


// 注意, 此雅可比句矩阵后三列数据较大, 是弧度雅可比矩阵, 但是输入是角度, 没问题!! 这样会让角度误差减小
void CompensationJacobian(float x, float y, float z, float a, float b, float c, float J[6][6])
{

    COS_SIN_TYPE sina, sinb, sinc, cosa, cosb, cosc;

    cordic(a, &sina, &cosa);
    cordic(b, &sinb, &cosb);
    cordic(c, &sinc, &cosc);

    float x106, x105, x104, x103, x102, x101, x100, x99, x98, x97, x96,
        x95, x94, x93, x92, x91, x90, x89, x88, x87, x86, x85, x84, x83, x82,
        x81, x80, x79, x78, x77, x76, x75, x74, x73, x72, x71, x70, x69, x68, x67,
        x66, x65, x64, x63, x62, x61, x60, x59, x58, x57, x56, x55, x54, x53, x52, x51,
        x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x40, x39, x38, x37, x36, x35, x34,
        x33, x32, x31, x30, x29, x28, x27, x26, x25, x24, x23, x22, x21, x20, x19, x18, x17, x16,
        x15, x14, x13, x12, x11, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1;

    x106 = 14.7886 * cosb * sinc;
    x105 = 3.5337 * cosb * cosc;
    x104 = 14.7886 * cosc * sina;
    x103 = 3.5337 * sina * sinc;
    x102 = 3.5337 * cosa * cosc * sinb;
    x101 = 14.7886 * cosa * sinb * sinc;
    x100 = 4 * cosa * cosb;
    x99 = 14.7886 * cosa * cosc;
    x98 = 3.5337 * cosa * sinc;
    x97 = 3.5337 * cosc * sina * sinb;
    x96 = 14.7886 * sina * sinb * sinc;
    x95 = 4 * cosb * sina;
    x94 = 11.0404 * cosb * cosc;
    x93 = 10.4546 * cosb * sinc;
    x92 = 10.4546 * cosa * cosc;
    x91 = 11.0404 * cosa * sinc;
    x90 = 11.0404 * cosc * sina * sinb;
    x89 = 10.4546 * sina * sinb * sinc;
    x88 = 11.0404 * sina * sinc;
    x87 = 10.4546 * cosc * sina;
    x86 = 11.0404 * cosa * cosc * sinb;
    x85 = 10.4546 * cosa * sinb * sinc;
    x84 = 14.5742 * cosb * cosc;
    x83 = 4.334 * cosb * sinc;
    x82 = 14.5742 * cosa * sinc;
    x81 = 4.334 * cosa * cosc;
    x80 = 4.334 * sina * sinc * sinb;
    x79 = 14.5742 * cosc * sinb * sina;
    x78 = 14.5742 * sina * sinc;
    x77 = 4.334 * cosc * sina;
    x76 = 4.334 * cosa * sinb * sinc;
    x75 = 14.5742 * cosa * cosc * sinb;
    x74 = 4 * sinb - x + x106 - x105 + 18.111;
    x73 = z + x103 - x100 + x104 - x102 + x101 - 4;
    x72 = y + x99 + x95 + x98 + x97 - x96 - 17.526;
    x71 = x - 4 * sinb - x94 + x93 + 6.1219;
    x70 = y - x92 + x95 - x91 - x90 + x89 + 24.448;
    x69 = x88 - z + x100 + x87 - x86 + x85 + 4;
    x68 = x - 4 * sinb + x94 + x93 - 6.1219;
    x67 = y - x92 + x95 + x91 + x90 + x89 + 24.448;
    x66 = x100 - x88 - z + x87 + x86 + x85 + 4;
    x65 = -4 * sinb + x + x83 + x84 - 24.233;
    x64 = y - x81 + x95 + x82 + x79 + x80 - 6.9222;
    x63 = x100 - x78 - z + x77 + x76 + x75 + 4;
    x62 = 4 * sinb - x + x105 + x106 - 18.111;
    x61 = z - x103 - x100 + x104 + x102 + x101 - 4;
    x60 = x98 - x99 - x95 - y + x97 + x96 + 17.526;
    x59 = -4 * sinb + x - x84 + x83 + 24.233;
    x58 = x78 - z + x100 + x77 - x75 + x76 + 4;
    x57 = x81 - y - x95 + x82 + x79 - x80 + 6.9222;
    x56 = sqrt(pow(x74, 2) + pow(x73, 2) + pow(x72, 2));
    x55 = sqrt(pow(x69, 2) + pow(x71, 2) + pow(x70, 2));
    x54 = sqrt(pow(x66, 2) + pow(x68, 2) + pow(x67, 2));
    x53 = sqrt(pow(x65, 2) + pow(x64, 2) + pow(x63, 2));
    x52 = sqrt(pow(x62, 2) + pow(x61, 2) + pow(x60, 2));
    x51 = sqrt(pow(x57, 2) + pow(x59, 2) + pow(x58, 2));
    x50 = 10.4546 * sina * sinc;
    x49 = 10.4546 * sinb * sinc;
    x48 = 14.5742 * cosa * cosc;
    x47 = 14.7886 * cosb * cosc;
    x46 = 3.5337 * cosc * sina;
    x45 = 3.5337 * cosb * sinc;
    x44 = 3.5337 * cosc * sinb;
    x43 = 14.5742 * cosc * sina;
    x42 = 14.5742 * cosb * sinc;
    x41 = 14.5742 * cosc * sinb;
    x40 = 14.7886 * cosa * sinc;
    x39 = 14.7886 * sina * sinc;
    x38 = 14.7886 * sinb * sinc;
    x37 = 4.334 * cosb * cosc;
    x36 = 10.4546 * cosb * cosc;
    x35 = 4.334 * cosa * sinc;
    x34 = 11.0404 * cosa * cosc;
    x33 = 10.4546 * cosa * sinc;
    x32 = 4.334 * sina * sinc;
    x31 = 4.334 * sinb * sinc;
    x30 = 11.0404 * cosc * sina;
    x29 = 11.0404 * cosb * sinc;
    x28 = 11.0404 * cosc * sinb;
    x27 = 3.5337 * cosa * cosc;
    x26 = 4.334 * cosa * cosb * sinc;
    x25 = 4.334 * cosa * cosc * sinb;
    x24 = 11.0404 * cosa * cosb * cosc;
    x23 = 10.4546 * cosa * cosb * sinc;
    x22 = 10.4546 * cosa * cosc * sinb;
    x21 = 4.334 * cosb * sina * sinc;
    x20 = 4.334 * cosc * sina * sinb;
    x19 = 11.0404 * cosb * cosc * sina;
    x18 = 3.5337 * cosa * cosb * cosc;
    x17 = 10.4546 * cosb * sina * sinc;
    x16 = 10.4546 * cosc * sina * sinb;
    x15 = 14.5742 * cosa * cosb * cosc;
    x14 = 11.0404 * cosa * sinb * sinc;
    x13 = 3.5337 * cosb * cosc * sina;
    x12 = 14.5742 * cosb * cosc * sina;
    x11 = 14.7886 * cosa * cosb * sinc;
    x10 = 14.7886 * cosa * cosc * sinb;
    x9 = 11.0404 * sina * sinb * sinc;
    x8 = 3.5337 * cosa * sinb * sinc;
    x7 = 14.5742 * cosa * sinb * sinc;
    x6 = 14.7886 * cosb * sina * sinc;
    x5 = 14.7886 * cosc * sina * sinb;
    x4 = 3.5337 * sina * sinb * sinc;
    x3 = 14.5742 * sina * sinb * sinc;
    x2 = 4 * cosa * sinb;
    x1 = 4 * sina * sinb;

    J[0][0] = x68 / x54;
    J[0][1] = x67 / x54;
    J[0][2] = -x66 / x54;
    J[0][3] = -(x66 * (x95 - x92 + x91 + x90 + x89) - x67 * (x100 - x88 + x87 + x86 + x85)) / x54;
    J[0][4] = (x66 * (x24 - x2 + x23) - x68 * (4 * cosb + x49 + x28) + x67 * (x19 - x1 + x17)) / x54;
    J[0][5] = (x67 * (x34 + x33 + x16 - x9) - x66 * (x50 + x30 - x22 + x14) + x68 * (x36 - x29)) / x54;

    J[1][0] = x65 / x53;
    J[1][1] = x64 / x53;
    J[1][2] = -x63 / x53;
    J[1][3] = -(x63 * (x95 - x81 + x82 + x79 + x80) - x64 * (x100 - x78 + x77 + x75 + x76)) / x53;
    J[1][4] = (x64 * (x12 - x1 + x21) - x65 * (4 * cosb + x31 + x41) + x63 * (x15 - x2 + x26)) / x53;
    J[1][5] = (x64 * (x48 + x35 + x20 - x3) - x63 * (x32 + x43 - x25 + x7) + x65 * (x37 - x42)) / x53;

    J[2][0] = -x74 / x56;
    J[2][1] = x72 / x56;
    J[2][2] = x73 / x56;
    J[2][3] = (x73 * (x99 + x95 + x98 + x97 - x96) - x72 * (x103 - x100 + x104 - x102 + x101)) / x56;
    J[2][4] = (x73 * (x2 - x18 + x11) - x72 * (x1 - x13 + x6) + x74 * (4 * cosb - x38 + x44)) / x56;
    J[2][5] = (x73 * (x46 - x39 + x10 + x8) + x74 * (x47 + x45) - x72 * (x40 - x27 + x5 + x4)) / x56;

    J[3][0] = -x62 / x52;
    J[3][1] = -x60 / x52;
    J[3][2] = x61 / x52;
    J[3][3] = -(x61 * (x98 - x95 - x99 + x97 + x96) - x60 * (x104 - x100 - x103 + x102 + x101)) / x52;
    J[3][4] = (x60 * (x1 + x13 + x6) + x61 * (x2 + x18 + x11) - x62 * (x38 - 4 * cosb + x44)) / x52;
    J[3][5] = (x62 * (x47 - x45) - x61 * (x39 + x46 - x10 + x8) + x60 * (x27 + x40 + x5 - x4)) / x52;

    J[4][0] = x59 / x51;
    J[4][1] = -x57 / x51;
    J[4][2] = -x58 / x51;
    J[4][3] = -(x57 * (x78 + x100 + x77 - x75 + x76) - x58 * (x81 - x95 + x82 + x79 - x80)) / x51;
    J[4][4] = -(x59 * (4 * cosb + x31 - x41) - x57 * (x1 + x12 - x21) + x58 * (x2 + x15 - x26)) / x51;
    J[4][5] = (x58 * (x43 - x32 + x25 + x7) + x59 * (x37 + x42) - x57 * (x35 - x48 + x20 + x3)) / x51;

    J[5][0] = x71 / x55;
    J[5][1] = x70 / x55;
    J[5][2] = -x69 / x55;
    J[5][3] = (x69 * (x92 - x95 + x91 + x90 - x89) + x70 * (x88 + x100 + x87 - x86 + x85)) / x55;
    J[5][4] = -(x71 * (4 * cosb + x49 - x28) + x69 * (x2 + x24 - x23) + x70 * (x1 + x19 - x17)) / x55;
    J[5][5] = (x69 * (x30 - x50 + x22 + x14) + x70 * (x33 - x34 + x16 + x9) + x71 * (x36 + x29)) / x55;
}
