#include<iostream>
#include<vector>
#include"mlp.cpp"


using namespace std;

int main(){
    float x1[6] = {54.2754, 56.078, 55.0039, 60.4973, 59.2254, 52.8107};
    float y1[6] = {0, 0, 0, 0, 0, 0};
    mlp(x1, y1);
    for(int i=0;i<6;i++){
        cout<<y1[i]<<endl;
    }
}