#include <iostream>
#include <Eigen/Geometry>
#include <Eigen/Core>
#include "math.h"

using namespace std;
int main()
{
    Eigen::Vector3d ea(2.0 / 180 * M_PI, -3.0 / 180 * M_PI, 5.0 / 180 * M_PI);

    // 3.1 欧拉角转换为旋转矩阵
    Eigen::AngleAxisd rollAngle(Eigen::AngleAxisd(ea(0), Eigen::Vector3d::UnitX()));
    Eigen::AngleAxisd pitchAngle(Eigen::AngleAxisd(ea(1), Eigen::Vector3d::UnitY()));
    Eigen::AngleAxisd yawAngle(Eigen::AngleAxisd(ea(2), Eigen::Vector3d::UnitZ()));
    Eigen::Matrix3d rotation_vector;
    rotation_vector = rollAngle * yawAngle * pitchAngle;

    cout << "rotation matrix =\n"
         << rotation_vector << endl;
         // 可以算出来旋转矩阵,但是精度和matlab差的有点多
    cout << ea(0) << " " << ea(1) << " " << ea(2) << endl;
}
