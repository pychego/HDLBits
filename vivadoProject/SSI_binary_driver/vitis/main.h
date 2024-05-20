/*
 * main.h
 *
 *  Created on: 2021年12月23日
 *      Author: hetaodi
 */

#ifndef SRC_MAIN_H_
#define SRC_MAIN_H_


#define FUNCTION_FORCE_VALUE					0x10F9
#define FUNCTION_ACCELERATION_VALUE				0x10FA
#define FUNCTION_VELOCITY_VALUE					0x10FB
#define FUNCTION_DISPLACEMENT_VALUE				0x10FC
#define FUNCTION_COMMAND						0x1101
#define FUNCTION_CTRL_METHOD					0x1102
#define FUNCTION_DISPLACEMENT_PID				0x1103
#define FUNCTION_VELOCITY_PID					0x1104
#define FUNCTION_ACCELERATION_PID				0x1105
#define FUNCTION_DISPLACEMENT_REF_WAVEFORM		0x1106
#define FUNCTION_VELOCITY_REF_WAVEFORM			0x1107
#define FUNCTION_ACCELERATION_REF_WAVEFORM		0x1108
#define FUNCTION_CTRL_VARIABLE					0x110F
#define FUNCTION_SINE_WAVEFORM_PARAM			0x1110
#define FUNCTION_STATIC_VOLTAGE					0x1111


#define PARAM_ADDR_ROM_COUNT					XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR
#define PARAM_ADDR_BRAM_COUNT					XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 4
#define PARAM_ADDR_AD7606_CONFIG				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 12
#define PARAM_ADDR_CTRL_METHOD_MUX				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 20
#define PARAM_ADDR_DISPLACEMENT_KP				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 32
#define PARAM_ADDR_DISPLACEMENT_KI				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 36
#define PARAM_ADDR_DISPLACEMENT_KD				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 40
#define PARAM_ADDR_ACCELERATION_KP				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 44
#define PARAM_ADDR_ACCELERATION_KI				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 48
#define PARAM_ADDR_ACCELERATION_KD				XPAR_PARAM_DISTRIBUTOR_0_S00_AXI_BASEADDR + 52



#endif /* SRC_MAIN_H_ */