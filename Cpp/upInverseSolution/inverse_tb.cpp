#include<iostream>
#include"upInverseSolution.h"
#include"upInverseSolution.cpp"

using namespace std;

int main(){

    float pose[6] = {-8, -4, 36, 4, -3, -3};
    float lengths[6] = {0, 0, 0, 0, 0, 0};

    // 这里传递的lengths就是地址
    upInverseSolution(pose, lengths);
    for(int i=0;i<6;i++){
        cout<<lengths[i]<<endl;
    }
}