#include "steback.h"
#include "math.h"

// 输入: cosine[3]是 旋转角的余弦值   sine[3]同理
// 		 trans[3] 是 l = T + R*P - B; 里面的 T

// 输出: ret[i]是 第i条腿长度的平方
void steBack(INT_TYPE cosine[3], INT_TYPE sine[3], INT_TYPE trans[3], INT_TYPE ret[6])
{
    float cosine_float[3];
    float sine_float[3];
    float trans_float[3];
    float ret_float[6];

    for (int i = 0; i < 3; i++)
    {
        cosine_float[i] = cosine[i] / 10000.0;
        sine_float[i] = sine[i] / 10000.0;
        trans_float[i] = trans[i] / 10000.0;
    }

    DATA_TYPE platpos[6][3] = {
        {491.4635, -631.2398, 0},
        {491.4635, 631.2398, 0},
        {300.9379, 741.2398, 0},
        {-792.4014, 110.0000, 0},
        {-792.4014, -110.0000, 0},
        {300.9379, -741.2398, 0}};
    DATA_TYPE basepos[6][3] = {
        {990.1515, -140.0000, 0},
        {990.1515, 140.0000, 0},
        {-373.8322, 927.4964, 0},
        {-616.3193, 787.4964, 0},
        {-616.3193, -787.4964, 0},
        {-373.8322, -927.4964, 0}};
    DATA_TYPE rx[3][3] = {
        {1, 0, 0},
        {0, cosine_float[0], -1 * sine_float[0]},
        {0, sine_float[0], cosine_float[0]}};
    DATA_TYPE ry[3][3] = {
        {cosine_float[1], 0, sine_float[1]},
        {0, 1, 0},
        {-1 * sine_float[1], 0, cosine_float[1]}};
    DATA_TYPE rz[3][3] = {
        {cosine_float[2], -1 * sine_float[2], 0},
        {sine_float[2], cosine_float[2], 0},
        {0, 0, 1}};

    // tmp[3][3]存放Rz * Ry
    DATA_TYPE tmp[3][3] = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
    // r[3][3]存放 Rz * Ry * Rx
    DATA_TYPE r[3][3] = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};

    DATA_TYPE legpoint[3] = {0, 0, 0};
    DATA_TYPE homepos = 1600;

    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
        steBack_label0:
            for (int k = 0; k < 3; k++)
            {
                tmp[i][j] += rz[i][k] * ry[k][j];
            }
        }
    }
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
        steBack_label1:
            for (int k = 0; k < 3; k++)
            {
                r[i][j] += tmp[i][k] * rx[k][j];
            }
        }
    }

    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 3; j++)
        {
#pragma HLS UNROLL
            legpoint[j] = 0;
            for (int k = 0; k < 3; k++)
            {
                legpoint[j] += r[j][k] * platpos[i][k];
            }
            if (j == 2)
            {
                // 这里是将stewart初始状态(标准状态下)两个台面的高度单独拿了出来作为homepos
                legpoint[j] += trans_float[j] + homepos - basepos[i][j];
                // ret[i]是 第i条腿长度的平方
                ret_float[i] = (legpoint[0] * legpoint[0] + legpoint[1] * legpoint[1] + legpoint[2] * legpoint[2]);
            }
            else
                // j=0时 计算出了腿长向量的第一个分量
                legpoint[j] += trans_float[j] - basepos[i][j];
        }
    }

    for (int i = 0; i < 6; i++)
    {
    	ret_float[i] = sqrt(ret_float[i]);
    	// 保留两位小数,并扩大为整数
        ret[i] = (int)(ret_float[i]*100 + 0.5);
    }
}
