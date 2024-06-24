#include "inverse.h"

// tan-1(2^(-i))
THETA_TYPE cordic_phase[NUM_ITERATIONS] = {45, 26.56505118, 14.03624347, 7.12506349, 3.576334375, 1.789910608,
                                           0.8951737102, 0.4476141709, 0.2238105004, 0.1119056771, 0.05595289189, 0.02797645262, 0.01398822714,
                                           0.006994113675, 0.003497851056, 0.001748528427, 0.0008742642137, 0.0004371321069, 0.0002185660534,
                                           0.0001092830267};

void cordic(THETA_TYPE theta, COS_SIN_TYPE *s, COS_SIN_TYPE *c)
{
    // Set the initial vector that we will rotate
    // current_cos = I;current = Q
    COS_SIN_TYPE current_cos = 0.60725607252935;
    ;
    COS_SIN_TYPE current_sin = 0;

    // Factor is the 2^(-L) value
    COS_SIN_TYPE factor = 1.0;

    // This loop iteratively rotates the initial vector to find the
    // sine and cosine value corresponding to the input theta angle
    for (int8_t j = 0; j < NUM_ITERATIONS; j++)
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
