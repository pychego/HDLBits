#include "compensation.h"
#include "math.h"

void compensation(float leg1, float leg2, float leg3, float leg4, float leg5, float leg6,
                  float leg7, float leg8, float leg9, float leg10, float leg11, float leg12,
                  float target1, float target2, float target3, float target4, float target5, float target6)
{
    float downLengths[6] = {leg1, leg2, leg3, leg4, leg5, leg6};
    float upLengths[6] = {leg7, leg8, leg9, leg10, leg11, leg12};
    float pose1[6] = {0};
    float pose2[6] = {0};

    downDirectSolution(downLengths, pose1);


}