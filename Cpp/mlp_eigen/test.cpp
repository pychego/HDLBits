#include <iostream>
#include "math.h"
#include "Jacobian.cpp"
#include <Eigen/Dense>

using namespace std;

int main()
{
    float x = 1.2;
    float y = 2.4;
    float z = 56.6;
    float a = 4.5;
    float b = 5.6;
    float c = 5.4;
    Eigen::Matrix<float, 6, 6> J;
    float f[6] = {1, 2, 3, 4, 5, 6};
    Jacobian(x, y, z, a, b, c, J);
    cout << J << endl;

    // 将二维数组转化为矩阵
    // Eigen::RowMajor保证了和原始数组的顺序一致, 不进行转置

    // Eigen::Map<Eigen::Matrix<float, 6, 1>> f_matrix(f);

    // std::cout << "雅可比矩阵 Matrix:\n" << matrix << std::endl;

    // std::cout << "雅可比矩阵的逆矩阵 Matrix:\n" << matrix.inverse() << std::endl;

    // std::cout << "结果矩阵 Matrix:\n" << matrix.inverse() * f_matrix << std::endl;



}