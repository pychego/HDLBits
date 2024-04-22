/*
根据matlab Jacobian得到的C++代码
*/
#include "Jacobian_op.h"
#include "math.h"
using namespace std;

void Jacobian_op(float x, float y, float z, float a, float b, float c, float J[6][6])
{

    // a = a * 3.141592653589793 / 180;
    // b = b * 3.141592653589793 / 180;
    // c = c * 3.141592653589793 / 180;
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

    x106 = 18.111 * cosb * cosc;
    x105 = 17.526 * cosb * sinc;
    x104 = 17.526 * cosc * sina;
    x103 = 18.111 * sina * sinc;
    x102 = 18.111 * cosa * cosc * sinb;
    x101 = 17.526 * cosa * sinb * sinc;
    x100 = 4.0 * cosa * cosb;
    x99 = 17.526 * cosa * cosc;
    x98 = 18.111 * cosa * sinc;
    x97 = 18.111 * cosc * sina * sinb;
    x96 = 17.526 * sina * sinb * sinc;
    x95 = 4.0 * cosb * sina;
    x94 = 6.1219 * cosb * cosc;
    x93 = 24.448 * cosb * sinc;
    x92 = 24.448 * cosa * cosc;
    x91 = 6.1219 * cosa * sinc;
    x90 = 6.1219 * cosc * sina * sinb;
    x89 = 24.448 * sina * sinb * sinc;
    x88 = 6.1219 * sina * sinc;
    x87 = 24.448 * cosc * sina;
    x86 = 6.1219 * cosa * cosc * sinb;
    x85 = 24.448 * cosa * sinb * sinc;
    x84 = 6.9222 * cosb * sinc;
    x83 = 24.233 * cosb * cosc;
    x82 = 6.9222 * cosc * sina;
    x81 = 24.233 * sina * sinc;
    x80 = 24.233 * cosa * cosc * sinb;
    x79 = 6.9222 * cosa * sinb * sinc;
    x78 = 6.9222 * cosa * cosc;
    x77 = 24.233 * cosa * sinc;
    x76 = 24.233 * cosc * sina * sinb;
    x75 = 6.9222 * sina * sinb * sinc;
    x74 = 4 * sinb - x - x106 + x105 + 9.2278;
    x73 = z + x103 - x100 + x104 - x102 + x101 - 4;
    x72 = y + x99 + x95 + x98 + x97 - x96 - 36.039;
    x71 = x - 4 * sinb - x94 + x93 + 26.597;
    x70 = y - x92 + x95 - x91 - x90 + x89 + 26.011;
    x69 = x88 - z + x100 + x87 - x86 + x85 + 4;
    x68 = x - 4 * sinb + x94 + x93 - 26.597;
    x67 = y - x92 + x95 + x91 + x90 + x89 + 26.011;
    x66 = x100 - x88 - z + x87 + x86 + x85 + 4;
    x65 = 4 * sinb - x + x83 + x84 - 35.825;
    x64 = z - x81 - x100 + x82 + x80 + x79 - 4;
    x63 = y + x78 + x95 - x77 - x76 - x75 + 10.028;
    x62 = 4 * sinb - x - x83 + x84 + 35.825;
    x61 = z + x81 - x100 + x82 - x80 + x79 - 4;
    x60 = y + x78 + x95 + x77 + x76 - x75 + 10.028;
    x59 = 4 * sinb - x + x106 + x105 - 9.2278;
    x58 = z - x103 - x100 + x104 + x102 + x101 - 4;
    x57 = x98 - x99 - x95 - y + x97 + x96 + 36.039;
    x56 = sqrt(pow(x74, 2) + pow(x73, 2) + pow(x72, 2));
    x55 = sqrt(pow(x69, 2) + pow(x71, 2) + pow(x70, 2));
    x54 = sqrt(pow(x66, 2) + pow(x68, 2) + pow(x67, 2));
    x53 = sqrt(pow(x65, 2) + pow(x64, 2) + pow(x63, 2));
    x52 = sqrt(pow(x62, 2) + pow(x61, 2) + pow(x60, 2));
    x51 = sqrt(pow(x57, 2) + pow(x59, 2) + pow(x58, 2));
    x50 = 6.9222 * cosa * sinc;
    x49 = 24.448 * sina * sinc;
    x48 = 24.448 * sinb * sinc;
    x47 = 6.9222 * sina * sinc;
    x46 = 6.9222 * sinb * sinc;
    x45 = 17.526 * cosb * cosc;
    x44 = 18.111 * cosa * cosc;
    x43 = 17.526 * cosa * sinc;
    x42 = 18.111 * cosc * sina;
    x41 = 18.111 * cosb * sinc;
    x40 = 18.111 * cosc * sinb;
    x39 = 24.233 * cosa * cosc;
    x38 = 6.1219 * cosa * cosc;
    x37 = 24.448 * cosb * cosc;
    x36 = 17.526 * sina * sinc;
    x35 = 17.526 * sinb * sinc;
    x34 = 6.9222 * cosb * cosc;
    x33 = 24.233 * cosc * sina;
    x32 = 24.448 * cosa * sinc;
    x31 = 24.233 * cosb * sinc;
    x30 = 24.233 * cosc * sinb;
    x29 = 6.1219 * cosc * sina;
    x28 = 6.1219 * cosb * sinc;
    x27 = 6.1219 * cosc * sinb;
    x26 = 18.111 * cosa * cosb * cosc;
    x25 = 17.526 * cosa * cosb * sinc;
    x24 = 17.526 * cosa * cosc * sinb;
    x23 = 18.111 * cosb * cosc * sina;
    x22 = 24.233 * cosa * cosb * cosc;
    x21 = 6.1219 * cosa * cosb * cosc;
    x20 = 17.526 * cosb * sina * sinc;
    x19 = 17.526 * cosc * sina * sinb;
    x18 = 18.111 * cosa * sinb * sinc;
    x17 = 24.233 * cosb * cosc * sina;
    x16 = 24.448 * cosa * cosb * sinc;
    x15 = 24.448 * cosa * cosc * sinb;
    x14 = 6.1219 * cosb * cosc * sina;
    x13 = 18.111 * sina * sinb * sinc;
    x12 = 6.9222 * cosa * cosb * sinc;
    x11 = 6.9222 * cosa * cosc * sinb;
    x10 = 24.233 * cosa * sinb * sinc;
    x9 = 24.448 * cosb * sina * sinc;
    x8 = 24.448 * cosc * sina * sinb;
    x7 = 6.1219 * cosa * sinb * sinc;
    x6 = 6.9222 * cosb * sina * sinc;
    x5 = 6.9222 * cosc * sina * sinb;
    x4 = 24.233 * sina * sinb * sinc;
    x3 = 6.1219 * sina * sinb * sinc;
    x2 = 4 * cosa * sinb;
    x1 = 4 * sina * sinb;

    J[0][0] = -x62 / x52;
    J[0][1] = x60 / x52;
    J[0][2] = x61 / x52;
    J[0][3] = -DEG2RAD*(x60 * (x81 - x100 + x82 - x80 + x79) - x61 * (x78 + x95 + x77 + x76 - x75)) / x52;
    J[0][4] = DEG2RAD*(x62 * (4 * cosb - x46 + x30) - x60 * (x1 - x17 + x6) + x61 * (x2 - x22 + x12)) / x52;
    J[0][5] = DEG2RAD*(x62 * (x34 + x31) + x61 * (x33 - x47 + x11 + x10) - x60 * (x50 - x39 + x5 + x4)) / x52;

    J[1][0] = -x74 / x56;
    J[1][1] = x72 / x56;
    J[1][2] = x73 / x56;
    J[1][3] = DEG2RAD*(x73 * (x99 + x95 + x98 + x97 - x96) - x72 * (x103 - x100 + x104 - x102 + x101)) / x56;
    J[1][4] = DEG2RAD*(x73 * (x2 - x26 + x25) - x72 * (x1 - x23 + x20) + x74 * (4 * cosb - x35 + x40)) / x56;
    J[1][5] = DEG2RAD*(x73 * (x42 - x36 + x24 + x18) - x72 * (x43 - x44 + x19 + x13) + x74 * (x45 + x41)) / x56;

    J[2][0] = -x59 / x51;
    J[2][1] = -x57 / x51;
    J[2][2] = x58 / x51;
    J[2][3] = -DEG2RAD*(x58 * (x98 - x95 - x99 + x97 + x96) - x57 * (x104 - x100 - x103 + x102 + x101)) / x51;
    J[2][4] = DEG2RAD*(x57 * (x1 + x23 + x20) + x58 * (x2 + x26 + x25) - x59 * (x35 - 4 * cosb + x40)) / x51;
    J[2][5] = DEG2RAD*(x59 * (x45 - x41) - x58 * (x36 + x42 - x24 + x18) + x57 * (x44 + x43 + x19 - x13)) / x51;

    J[3][0] = -x65 / x53;
    J[3][1] = x63 / x53;
    J[3][2] = x64 / x53;
    J[3][3] = -DEG2RAD*(x63 * (x82 - x100 - x81 + x80 + x79) + x64 * (x77 - x95 - x78 + x76 + x75)) / x53;
    J[3][4] = -DEG2RAD*(x63 * (x1 + x17 + x6) + x65 * (x46 - 4 * cosb + x30) - x64 * (x2 + x22 + x12)) / x53;
    J[3][5] = -DEG2RAD*(x64 * (x47 + x33 - x11 + x10) - x65 * (x34 - x31) + x63 * (x39 + x50 + x5 - x4)) / x53;

    J[4][0] = x71 / x55;
    J[4][1] = x70 / x55;
    J[4][2] = -x69 / x55;
    J[4][3] = DEG2RAD*(x70 * (x88 + x100 + x87 - x86 + x85) + x69 * (x92 - x95 + x91 + x90 - x89)) / x55;
    J[4][4] = -DEG2RAD*(x70 * (x1 + x14 - x9) + x71 * (4 * cosb + x48 - x27) + x69 * (x2 + x21 - x16)) / x55;
    J[4][5] = DEG2RAD*(x69 * (x29 - x49 + x15 + x7) + x70 * (x32 - x38 + x8 + x3) + x71 * (x37 + x28)) / x55;

    J[5][0] = x68 / x54;
    J[5][1] = x67 / x54;
    J[5][2] = -x66 / x54;
    J[5][3] = DEG2RAD*(x67 * (x100 - x88 + x87 + x86 + x85) - x66 * (x95 - x92 + x91 + x90 + x89)) / x54;
    J[5][4] = DEG2RAD*(x67 * (x14 - x1 + x9) - x68 * (4 * cosb + x48 + x27) + x66 * (x21 - x2 + x16)) / x54;
    J[5][5] = DEG2RAD*(x67 * (x38 + x32 + x8 - x3) - x66 * (x49 + x29 - x15 + x7) + x68 * (x37 - x28)) / x54;
}

THETA_TYPE cordic_phase[NUM_ITERATIONS] = {
    45, 26.5650, 14.0362, 7.1250, 3.5763, 1.7891, 0.8952, 0.4476, 0.2238, 0.1119, 0.05595, 0.02797, 0.01398822714, 0.00699, 0.003497};

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c)
{
    // Set the initial vector that we will rotate
    // current_cos = I;current = Q
    COS_SIN_TYPE current_cos = 0.60725;
    COS_SIN_TYPE current_sin = 0;

    // Factor is the 2^(-L) value
    COS_SIN_TYPE factor = 1.0;

    // This loop iteratively rotates the initial vector to find the
    // sine and cosine value corresponding to the input theta angle
    for (int j = 0; j < NUM_ITERATIONS; j++)
    {
        // Determine if we are rotating by a positive or negative angle
        int sigma = (theta < 0) ? -1 : 1;

        // Save the current_cos,so that it can be used in the sine calculation
        COS_SIN_TYPE temp_cos = current_cos;

        // Perform the rotation
        current_cos = current_cos - current_sin * sigma * factor;
        current_sin = temp_cos * sigma * factor + current_sin;

        // Determine the new theta
        theta = theta - sigma * cordic_phase[j];

        // Calculata next 2^(-L) value
        factor = factor / 2;
    }

    // Set the final sine and cosine values
    *s = current_sin;
    *c = current_cos;
}

float Sqrt(float k)
{
    float l = 0.0, r, mid;
    if (k >= 1)
        r = k; // 若输入正数大于1，则右端点设为 k
    if (k < 1)
        r = 1; // 若输入整数小于1，则右端点设为 1

    while (fabs(l - k / l) > Sqrt_eps)
    {
        mid = l + (r - l) / 2;
        if (mid < k / mid)
        {
            l = mid;
        }
        else
        {
            r = mid;
        }
    }

    return l;
}
