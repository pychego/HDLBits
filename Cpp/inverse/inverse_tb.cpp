#include<iostream>
#include"inverse.h"
#include"inverse.cpp"

using namespace std;

int main(){
    // 输入为实际值的10000倍
    // INT_TYPE pose[6] = {80000, -20000, 410000, 30000, 60000, 90000};
    INT_TYPE pose[6] = {82330, -22300, 434500, 31000, 63210, -94300};
    INT_TYPE lengths[6] = {0, 0, 0, 0, 0, 0};

    inverse(pose, lengths);
    for(int i=0;i<6;i++){
        cout<<lengths[i]<<endl;
    }
}