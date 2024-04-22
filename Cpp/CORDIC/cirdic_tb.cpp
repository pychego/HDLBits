#include<iostream>
#include"cordic.h"
#include"cordic.cpp"
#include<math.h>

using namespace std;

int main(){
    COS_SIN_TYPE s, c;
    // 输入测试的角度 单位为度
    THETA_TYPE theta = 66;
    cordic(theta, &s, &c);
    // 输出结果与math.h中的sin和cos函数的结果进行比较
    cout<<"实际sin "<<sin(theta/180*M_PI)<<endl;
    cout<<"实际cos "<<cos(theta/180*M_PI)<<endl;
    cout<<"cordic计算的sin "<<s<<endl;
    cout<<"cordic计算的cos "<<c<<endl;
    cout<<"误差sin: "<<s-sin(theta/180*M_PI)<<endl;
    cout<<"误差cos: "<<c-cos(theta/180*M_PI)<<endl;
}