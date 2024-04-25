#include <iostream>
#include <Eigen/Dense>
#include "math.h"
#include "mlp.h"
#include "Jacobian.cpp"
#include "IterationFunction.cpp"

int main()
{
    int flag = 0;
    Eigen::Matrix<float, 6, 1> eps;
    eps << 0.001, 0.001, 0.001, 0.001, 0.001, 0.001;

    // 测试代码时应该将lengths和pose一起改, pose是迭代的初始值
    // float lengths[6] = {54.2754, 56.078, 55.0039, 60.4973, 59.2254, 52.8107};
    float lengths[6] = {56.2754, 56.078, 55.0039, 60.4973,59.2254, 52.8107};

    // 定义一个 6*1 的矩阵
    Eigen::Matrix<float, 6, 1> f;
    Eigen::Matrix<float, 6, 6> df;
    Eigen::Matrix<float, 6, 1> pose;
    pose << 8.582, 3.029, 59.73, 0.7555, 3.193, 0.9335;

    Eigen::Matrix<float, 6, 1> new_pose;

    int i;
    for (i = 0; i < 10; i++)
    {
        IterationFunction(pose, lengths, f);
        Jacobian(pose(0, 0), pose(1, 0), pose(2, 0), pose(3, 0), pose(4, 0), pose(5, 0), df);
        new_pose = pose - df.inverse() * f;

        Eigen::Matrix<float, 6, 1> error = (new_pose - pose).cwiseAbs();
        Eigen::Matrix<int, 6, 1> comparison = (error.array() < eps.array()).cast<int>();
        if ((comparison.array() == 1).all())
        {
            std::cout << "ok" << std::endl;
            flag = 1; 
            break;
        }
        else
        {
            pose = new_pose;
        }
    }
    std::cout << "i = " << i << std::endl;
    std::cout << pose << std::endl;
}