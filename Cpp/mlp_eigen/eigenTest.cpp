#include <iostream>
#include <Eigen/Dense>

int main() {
    // 定义一个 float 类型的二维数组
    float arr[2][3] = {
        {1.0f, 2.0f, 3.0f},
        {4.0f, 5.0f, 6.0f}
    };

    // 可以实现判别了
    // 使用 Eigen::Map 将二维数组转换为矩阵
    Eigen::Matrix<float, 3, 1> a;
    a << -3.0f, 0.0f, 0.0f;
    Eigen::Matrix<float, 3, 1> b;
    b << 2.0f, 1.0f, 1.0f;
    Eigen::Vector3f abs_a = a.array().abs();
    Eigen::Vector3i comparison = (abs_a.array() < b.array()).cast<int>();
    if ((comparison.array() == 1).all()) {
        std::cout << "ok" << std::endl;
    } else {
        std::cout << "no" << std::endl;
    }
    // 打印矩阵

    return 0;
}