#include "IdealPlatform2disturb.h"
#include <iostream>
#include "math.h"
#include "RxRyRxFunction.cpp"
#include "transpose.cpp"
#include "IdealPlatform2disturb.cpp"

int main(){
    float pose1[6] = {8.11, 2.11, 60, -5, 3.11, 4};
    float pose2[6] = {0};
    IdealPlatform2disturb(pose1, pose2);
    for(int i=0; i<6; i++){
        std::cout << pose2[i] << " ";
    }
    return 0;
}