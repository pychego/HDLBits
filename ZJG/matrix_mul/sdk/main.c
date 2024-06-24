#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "stdio.h"
#include "xil_io.h"
#include "xparameters.h"
#include "xmatrix_mul_hw.h"
#include "xmatrix_mul.h"

int main()
{
	int data;
	int state;
	// 如果不使用大括号，会出现这个错误：missing braces around initializer
	char A[4][4] = {{0,1,2,3},{4,5,6,7},{8,9,10,11},{12,13,14,15}};
    char B[4][4] = {{0,1,2,3},{4,5,6,7},{8,9,10,11},{12,13,14,15}};
	short C[4][4];

	// 定义一个XMatrix_mul类型的变量xmatrix_mul，该变量为自动生成的。
	XMatrix_mul xmatrix_mul;
    init_platform();
	
	// 将HLS生成的IP赋值给xmatrix_mul，用于后续操作，并将状态信息赋值给state，用于判断是否初始化成功。
    state = XMatrix_mul_Initialize(&xmatrix_mul, XPAR_MATRIX_MUL_0_DEVICE_ID);
    if(state != XST_SUCCESS)
    {
    	print("XMatrix_mul_Initialize fail!!\n\r");
    	return XST_FAILURE;
    }

	// 由于A是将一行组合成一个数据进行存储，所以接下来是将组合好的新的数值写进RAM。
	// 这个是和之前进行RESHAPE操作相匹配的，输入的数据是32位的。
	// Xil_Out32函数是将一个32位的值，写入到一个特定的地址中去。
	// XMATRIX_MUL_AXILITES_ADDR_A_V_BASE是matrix_mul模块内addr寄存器的偏置地址
	// XPAR_MATRIX_MUL_0_S_AXI_AXILITES_BASEADDR是matrix_mul模块内addr寄存器的基地址
	// 基地址+偏置地址，就可以完成对该地址的操作。
	for(int i=0;i<4;i++)
	{
		u32 tp = 0;
		tp = A[i][0] + (A[i][1] << 8) + (A[i][2] << 16) + (A[i][3] << 24);
		Xil_Out32((XMATRIX_MUL_AXILITES_ADDR_A_V_BASE+XPAR_MATRIX_MUL_0_S_AXI_AXILITES_BASEADDR) + (i*4), (tp));
	}

	// 由于B是将一列组成一个数据进行存储，所以接下来是将组合好的新的数值写进RAM。
	for(int i=0;i<4;i++)
	{
		u32 tp = 0;
		tp = B[0][i] + (B[1][i] << 8) + (B[2][i] << 16) + (B[3][i] << 24);
		Xil_Out32((XMATRIX_MUL_AXILITES_ADDR_B_V_BASE+XPAR_MATRIX_MUL_0_S_AXI_AXILITES_BASEADDR) + (i*4), (tp));
	}

	// 第一次启动后可以自启动，不必再初始化。
    XMatrix_mul_EnableAutoRestart(&xmatrix_mul);
    // 启动电路，将ap_start置为1，开始计算。
    XMatrix_mul_Start(&xmatrix_mul);
    print("Test Start!!!\n\r");

	// 数据输出
	// 判断计算完成的条件是ap_done为1，当不是1时说明还尚未完成，就一直读取判断，直至算完。
    data  = XMatrix_mul_IsDone(&xmatrix_mul);
    while(data != 1)
    {
    	data  = XMatrix_mul_IsDone(&xmatrix_mul);

    }

    for(int i =0;i<4;i++)
    {
    	int tp;
    	for(int j =0;j<2;j++)
    	{
    		tp = XMatrix_mul_ReadReg((XMATRIX_MUL_AXILITES_ADDR_C_V_BASE + XPAR_MATRIX_MUL_0_S_AXI_AXILITES_BASEADDR),4*(2*i+j));
    		C[i][2*j+1] = tp >> 16;
    		C[i][2*j]   = tp - C[i][2*j+1] * 65536;
    	}

    }

    for(int i=0;i<4;i++)
    {
    	for(int j=0;j<4;j++)
    	{
    		printf("C[%d][%d]：%d\n",i,j,C[i][j]);
    	}
    }

    print("Test End!!!\n\r");
    cleanup_platform();
    return 0;
}
