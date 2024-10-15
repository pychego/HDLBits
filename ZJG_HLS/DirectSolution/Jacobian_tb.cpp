#include<iostream>
#include<vector>

#include "Jacobian.cpp"
#include "cordic.cpp"


using namespace std;

int main(){
    // float x1[6] = {54.2754, 56.078, 55.0039, 60.4973, 59.2254, 52.8107};
    float x,y,z, a, b,c;
    x = 8;
    y = 8;
    z = 158;
    a = 8;
    b = 8;
    c = 8;

    float J[6][6];
    Jacobian(x, y, z, a, b, c, J);
    
    // 格式化输出J 对齐
    for(int i=0; i<6; i++){
        for(int j=0; j<6; j++){
            cout<<J[i][j]<<" ";
        }
        cout<<endl;
    }
}