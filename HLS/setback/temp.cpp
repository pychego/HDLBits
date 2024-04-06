#include<iostream>
#include"math.h"

int  main(){

    // 计算45度的sin和cos并输出
    double sin45 = sin(45.0/180.0*M_PI);
    double cos45 = cos(45.0/180.0*M_PI);
    std::cout<<"sin45: "<<sin45<<std::endl;
    std::cout<<"cos45: "<<cos45<<std::endl;
};