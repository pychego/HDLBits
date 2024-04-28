#include<iostream>
#include<vector>
#include"mlp.cpp"


using namespace std;

int main(){
    // float x1[6] = {54.2754, 56.078, 55.0039, 60.4973, 59.2254, 52.8107};
    float x1[6] = {38.3798,36.0734,	35.1059,40.2248,39.5909,33.8097};
    float y1[6] = {0, 0, 0, 0, 0, 0};
    mlp(x1, y1);
    for(int i=0;i<6;i++){
        cout<<y1[i]<<endl;
    }
}