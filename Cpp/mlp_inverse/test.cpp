#include <iostream>

#define K_CONST 0.6072529350088812561694

double cordic_sqrt(double x) {
    if (x <= 0) {
        return 0.0;
    }

    int iterations = 20;
    double y = K_CONST;
    double z = 0.0;
    
    for (int i = 0; i < iterations; ++i) {
        double d = 1.0 / (1 << i);
        double t = y + (z + (1 << -i)) * (1 << -i);
        
        if (t * t <= x) {
            z = z + (1 << -i);
            y = t;
        }
    }
    
    return y;
}

int main() {
    double number = 25.0;
    double result = cordic_sqrt(number);
    std::cout << "Square root of " << number << " is: " << result << std::endl;
    return 0;
}