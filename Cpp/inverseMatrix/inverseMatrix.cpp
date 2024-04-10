#include <iostream>
#include <Eigen/Dense>

int main() {
    // 定义一个 float 类型的二维数组
    float arr[2][3] = {
        {1.0f, 2.0f, 3.0f},
        {4.0f, 5.0f, 6.0f}
    };

    // 使用 Eigen::Map 将二维数组转换为矩阵
    Eigen::Map<Eigen::Matrix<float, 2, 3>> matrix(arr[0]);

    // 打印矩阵
    std::cout << "Matrix:\n" << matrix << std::endl;

    return 0;
}