#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "sleep.h"


#define AXIGPIO_CHANNEL_1    1U
#define AXIGPIO_CHANNEL_2    2U

#define AXIGPIO_IRQ_TYPE_HIGH   1U
#define AXIGPIO_IRQ_TYPE_PEDGE  3U

#define AXIGPIO_IRQ_PRIORITY  128U


XGpio axiGpio0;
XScuGic scuGic;

void axiGpio0_Handler(void *CallbackRef);

int axiGpio0_intrFlag = 0;


int main(void)
{
	// 初始化AXI GPIO
	XGpio_Initialize(&axiGpio0, XPAR_GPIO_0_DEVICE_ID);

	// 打开系统的中断处理功能
	Xil_ExceptionInit(); // 初始化异常句柄，只在很早版本的bsp中需要，此处为了兼容性保留
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &scuGic);
	Xil_ExceptionEnable(); // 使能系统中断

	// 初始化中断控制器
	XScuGic_Config *scuGicConfig;
	scuGicConfig = XScuGic_LookupConfig(XPAR_XSCUTIMER_0_DEVICE_ID); // 根据器件ID查找配置
	XScuGic_CfgInitialize(&scuGic, scuGicConfig, scuGicConfig->CpuBaseAddress);

	// 设置对应ID中断的的优先级与触发类型
	XScuGic_SetPriorityTriggerType(&scuGic, XPAR_FABRIC_GPIO_0_VEC_ID, AXIGPIO_IRQ_PRIORITY, AXIGPIO_IRQ_TYPE_HIGH);
	// 连接中断ID与中断服务函数
	XScuGic_Connect(&scuGic, XPAR_FABRIC_GPIO_0_VEC_ID, (Xil_InterruptHandler)axiGpio0_Handler, &axiGpio0);
	// 启用对应中断ID的中断源
	XScuGic_Enable(&scuGic, XPAR_FABRIC_GPIO_0_VEC_ID);

	// 启动AXI GPIO中断
	XGpio_InterruptGlobalEnable(&axiGpio0);
	// 使能对应通道的中断
	XGpio_InterruptEnable(&axiGpio0, AXIGPIO_CHANNEL_1);

	while(1)
	{
		sleep(1);

		if (axiGpio0_intrFlag)
		{
			xil_printf("This is axiGpio0 interrupt!");

			axiGpio0_intrFlag = 0; // 复原中断标志
			XGpio_InterruptEnable(&axiGpio0, AXIGPIO_CHANNEL_1); // 重新使能中断
		}

		sleep(1);
	}

	return 0;
}


void axiGpio0_Handler(void *CallbackRef)
{
	XGpio *axiGpioPtr = (XGpio *)CallbackRef;

	axiGpio0_intrFlag = 1;

	// 关闭中断
	XGpio_InterruptDisable(axiGpioPtr, AXIGPIO_CHANNEL_1);

	// 清除中断寄存器，不清除无法再次进入中断
	XGpio_InterruptClear(axiGpioPtr, AXIGPIO_CHANNEL_1);
}

