#include "upDirectSolution.h"
#include "math.h"
#include <iostream>
#include <iomanip>
#include <cmath>

void luDecomposition(float mat[N][N], float lower[N][N], float upper[N][N], int pivot[N])
{
    for (int i = 0; i < N; i++)
    {
        pivot[i] = i;
    }

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            lower[i][j] = (i == j) ? 1 : 0;
            upper[i][j] = mat[i][j];
        }
    }

    for (int i = 0; i < N - 1; i++)
    {
        int maxIndex = i;
        float maxValue = 0;
        for (int k = i; k < N; k++)
        {
            if (std::abs(upper[k][i]) > maxValue)
            {
                maxValue = std::abs(upper[k][i]);
                maxIndex = k;
            }
        }

        if (maxIndex != i)
        {
            std::swap(pivot[maxIndex], pivot[i]);
            for (int j = 0; j < N; j++)
            {
                std::swap(upper[maxIndex][j], upper[i][j]);
                if (j < i)
                {
                    std::swap(lower[maxIndex][j], lower[i][j]);
                }
            }
        }

        for (int j = i + 1; j < N; j++)
        {
            lower[j][i] = upper[j][i] / upper[i][i];
            for (int k = i; k < N; k++)
            {
                upper[j][k] -= lower[j][i] * upper[i][k];
            }
        }
    }
}

void forwardSubstitution(float lower[N][N], float b[N], float y[N])
{
    for (int i = 0; i < N; i++)
    {
        y[i] = b[i];
        for (int j = 0; j < i; j++)
        {
            y[i] -= lower[i][j] * y[j];
        }
    }
}

void backwardSubstitution(float upper[N][N], float y[N], float x[N])
{
    for (int i = N - 1; i >= 0; i--)
    {
        x[i] = y[i];
        for (int j = i + 1; j < N; j++)
        {
            x[i] -= upper[i][j] * x[j];
        }
        x[i] /= upper[i][i];
    }
}

void inverseMatrix(float mat[N][N], float inv[N][N])
{
    float lower[N][N];
    float upper[N][N];
    int pivot[N];
    luDecomposition(mat, lower, upper, pivot);

    float b[N];
    float y[N];
    float x[N];

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            b[j] = (i == j) ? 1 : 0;
        }

        forwardSubstitution(lower, b, y);
        backwardSubstitution(upper, y, x);

        for (int j = 0; j < N; j++)
        {
            x[j] = fabs(x[j]) < 1e-4 ? 0 : x[j];
            inv[j][pivot[i]] = x[j];
        }
    }
}