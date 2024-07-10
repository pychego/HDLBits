#include <iostream>
#include "math.h"
#include "DirectSolution.h"
#include "Jacobian.cpp"
#include "Jacobian_cordic.cpp"
#include "IterationFunction.cpp"
#include "inverseMatrix.cpp"

int main()
{
    // 判断是否迭代成功
    int flag = 0;
    // 约定的迭代精度
    float eps = 0.001;

    // 测试代码时应该将lengths和pose一起改, lengths是正解输入的腿长, pose是迭代的初始值
    // float lengths[6] = {56.2754, 56.078, 55.0039, 60.4973,59.2254, 52.8107};
    // float pose[6] = {8.582, 3.029, 59.73, 0.7555, 3.193, 0.9335};

    float lengths[6] = {58.4536, 50.3413, 52.2402, 50.1538, 48.7386, 54.2602};
    // 此时实际位姿  {-8.3, 5.2, 55.2, 2.18, -3.6, 5.212}
    float pose[6] = {-8.164, 5.178, 55.28, 2.158, -3.416, 5.127};


    // float lengths[6] = {57.8268, 49.9773, 52.1388, 50.1579, 48.6781, 53.9514};
    // float pose[6] = {-7.881, 4.983, 55.06, 1.977, -2.859, 4.925};

    float f[6];

    // 定义一个 6*1 的矩阵
    float df[6][6];
    float df_inv[6][6];

    float new_pose[6];

    int i;
    for (i = 0; i < 10; i++)
    {
        // 用temp 存放df_inv * f
        float temp[6];
        float error_abs[6];
        float error_max = 0;
        
        IterationFunction(pose, lengths, f);
        Jacobian_cordic(pose[0], pose[1], pose[2], pose[3], pose[4], pose[5], df);
        inverseMatrix(df, df_inv);

        for(int i=0; i<6; i++)
        {
            temp[i] = 0;
            for(int j=0; j<6; j++)
            {
                temp[i] += df_inv[i][j] * f[j];
            }
            new_pose[i] = roundf((pose[i] - temp[i]) * 10000) / 10000;
            // new_pose[i] = pose[i] - temp[i];
        }
        // new_pose = pose - df.inverse() * f;

        for(int i=0; i<6; i++)
        {
            error_abs[i] = fabs(new_pose[i] - pose[i]);
            if(error_abs[i] > error_max)
            {
                error_max = error_abs[i];
            }
        }
        if(error_max < eps)
        {
            std::cout << "ok" << std::endl;
            flag = 1;
            break;
        }
        else
        {
            // pose = new_pose;
            for(int i=0; i<6; i++)
            {
                pose[i] = new_pose[i];
            }
        }
    }
    std::cout << "i = " << i << std::endl;
    for(int i=0; i<6; i++)
    {
        std::cout << pose[i] << std::endl;
    }
}