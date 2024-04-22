// 二分法求正数的平方根 尝试一下部署到HLS
#include<iostream>
using namespace std;
#include"math.h"
#include"Jacobian_op.h"
#include"Jacobian_op.cpp"
int main()
{
    float pose[6] = {3, 1, 55, 60, 45, 60};

    float df[6][6];
    Jacobian_op(pose[0], pose[1], pose[2], pose[3], pose[4], pose[5], df);

    // 输出雅可比矩阵df
    for(int i=0; i<6; i++)
    {
        for(int j=0; j<6; j++)
        {
            cout << df[i][j] << " ";
        }
        // 换行
        cout << endl;
    }
}
