#include<iostream>
#include<vector>
#include"downDirectSolution.cpp"
#include"downDirectSolution.h"
#include "IterationFunction.cpp"
#include "downJacobian.cpp"
#include "inverseMatrix.cpp"
#include"downMLP.cpp"


using namespace std;

int main(){
    // float x1[6] = {54.2754, 56.078, 55.0039, 60.4973, 59.2254, 52.8107};
    float x1[6] = {57.8268, 49.9773, 52.1388, 50.1579, 48.6781, 53.9514};
    float y1[6] = {0, 0, 0, 0, 0, 0};
    downMLP(x1, y1);
    for(int i=0;i<6;i++){
        cout<<y1[i]<<endl;
    }
}