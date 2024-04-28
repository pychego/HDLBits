#include <iostream>
#include "Jacobian_cordic.cpp"
#include "cordic.cpp"

int main() {
    float pose[6] = {8, -2, 41, 3, 4, 5};
    float df[6][6];
    Jacobian_cordic(pose[0], pose[1], pose[2], pose[3], pose[4], pose[5], df);
    // 输出df
    for(int i=0; i<6; i++){
        for(int j=0; j<6; j++){
            std::cout << df[i][j] << std::endl;
        }
        std::cout << "\n" << std::endl;
    }
}