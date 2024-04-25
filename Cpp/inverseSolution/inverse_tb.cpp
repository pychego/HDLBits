#include<iostream>
#include"inverse.h"
#include"inverse.cpp"

using namespace std;

int main(){
    // 输入为实际值的10000倍
    // INT_TYPE pose[6] = {80000, -20000, 410000, 30000, 60000, 90000};
    INT_TYPE pose[6] = {83410, 45320, 564100, 21800, -36000, -52120};
    INT_TYPE lengths[6] = {0, 0, 0, 0, 0, 0};

    // 这里传递的lengths就是地址
    inverse(pose, lengths);
    for(int i=0;i<6;i++){
        cout<<lengths[i]<<endl;
    }
}