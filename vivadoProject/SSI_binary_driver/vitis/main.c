#include "sleep.h"
#include "xgpiops.h"
#include "main.h"

int main()
{
	static XGpioPs psGpioInstancePtr;
	XGpioPs_Config* GpioConfigPtr;
	int xStatus;

	//-- (E)MIO的初始化
    GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
	if(GpioConfigPtr == NULL)
		return XST_FAILURE;

	xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr, GpioConfigPtr->BaseAddr);
	if(XST_SUCCESS != xStatus)
		print(" PS GPIO INIT FAILED \n\r");
	//-- (E)MIO初始化结束


 	// EMIO的输入输出方向, 方向设置为输出
 	XGpioPs_SetDirectionPin(&psGpioInstancePtr, 54,1);  // 54 对应 param_change_flag
 	XGpioPs_SetDirectionPin(&psGpioInstancePtr, 55,1);  // 55 start_init_dac
 	XGpioPs_SetDirectionPin(&psGpioInstancePtr, 56,1);	// 56 start
 	// 使能EMIO输出
 	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, 54,1);
 	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, 55,1);
 	XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, 56,1);

     // 设置PS向PL下发的参数 param_distributor
     /******配置PID参数相关寄存器******/
 	Xil_Out32(PARAM_ADDR_ROM_COUNT, 4096);					//参考波形的点数
    Xil_Out32(PARAM_ADDR_DISPLACEMENT_KP, 100);			//初始位移Kp的值。不要超过；小数点后位相当于是无效的
    Xil_Out32(PARAM_ADDR_DISPLACEMENT_KI, 200);				//初始位移Ki的值
    Xil_Out32(PARAM_ADDR_DISPLACEMENT_KD, 300);				//初始位移Kd的值

     // 没问题
    int kp = Xil_In32(PARAM_ADDR_DISPLACEMENT_KP);
    int ki = Xil_In32(PARAM_ADDR_DISPLACEMENT_KI);
    int kd = Xil_In32(PARAM_ADDR_DISPLACEMENT_KD);

    xil_printf("before give param_chang_flag\n");
    xil_printf("kp: %d\n", kp);
    xil_printf("ki: %d\n", ki);
    xil_printf("kd: %d\n", kd);

    	// 这里是操作Psgpio
    	XGpioPs_WritePin(&psGpioInstancePtr, 54, 1);	//param_change_flag, 使上述参数改变生效
    	sleep(1);  //延时一会儿，必要么？  还是延时一下比较稳妥
    	// param_change_flag只需要高电平持续一段时间就可以了吗; 对的
    	XGpioPs_WritePin(&psGpioInstancePtr, 54, 0);
    	sleep(1); // 延时1s
    	XGpioPs_WritePin(&psGpioInstancePtr, 56, 1);	//启动start信号，开始工作
    	xil_printf("-----Start Working------\r\n");

    	while(1){
    		xil_printf("当前的位移数据: %d\r\n", Xil_In32(XPAR_AXI_B) );
            sleep(0.01);
        }

        return 0;

}