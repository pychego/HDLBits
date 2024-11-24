/*  2024.11.24 
    按照DAC81408_driver_new更新了这个代码, 在初始化过程中填入了0V
接口:
    start_init_dac 开始初始化信号, 该信号要超前于start
    start 控制系统开始信号  start 和 start_init_dac 都来自GPIO

    dac_cmd 传送给spi的数据
    dac_cmd_valid 声明此时的dac_cmd是有效的
    LDACn DAC芯片同步输出多通道电压信号, 低电平时输出电压同步更新
原理: 
    start 是整个系统的开始信号, start_init_dac 是初始化DAC的信号 都是电平信号, 先start_init_dac, 后start
    高的论文中有,当接收到来自PS端的start_init_dac信号时，进入初始化阶段，并用 init_done_flag信号
    指示初始化的完成与否，初始化完成并接收到来自PS端的start信号时才会进入正常工作阶段。
*/
module DAC81416_cmd_gen (
    input        clk,
    input        rst_n,
    input        start_init_dac,
    input        start,            // start 和 start_init_dac 都来自GPIO
    input [15:0] control_output0,  // Waiting to write to DAC register
    input [15:0] control_output1,
    input [15:0] control_output2,
    input [15:0] control_output3,

    output reg [23:0] dac_cmd,
    output reg        dac_cmd_valid,
    output reg        LDACn
);


    // localparam is used to define constants, which can not be passed as parameters to other modules
    // the address comes from the datasheet technical manual of DAC81416
    // 地址和偏移已经经过多次验证,没有问题
    localparam SPICONFIG_REG_ADDR = 6'b000011;  // offset   3h
    localparam GENCONFIG_REG_ADDR = 6'b000100;  // 4h
    localparam SYNCCONFIG_REG_ADDR = 6'b000110;  // 06h
    localparam DACPWDWN_REG_ADDR = 6'b001001;  // 9h
    localparam DACRANGE0_REG_ADDR = 6'b001010;  // Ah   
    localparam DACRANGE1_REG_ADDR = 6'b001011;  // Bh
    localparam DACRANGE2_REG_ADDR = 6'b001100;  // Ch
    localparam DACRANGE3_REG_ADDR = 6'b001101;  // Dh

    localparam DAC0_DATA_REG_ADDR = 6'b010000;  // 10h
    localparam DAC1_DATA_REG_ADDR = 6'b010001;  // 11h
    localparam DAC2_DATA_REG_ADDR = 6'b010010;  // 12h
    localparam DAC3_DATA_REG_ADDR = 6'b010011;  // 13h



    // this is a counter from 0 to 9999, which is used to generate a 10kHz clock
    // cnt的一个周期是0.1个控制周期
    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;  // if rst_n is low, reset the counter
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // frequency is 10kHz, so cycle is 0.1ms
    // count_10kHz从0~9,是一个控制周期,所有要求时序的模块该信号均相同
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    reg [13:0] cnt_spi;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_spi <= 14'd0;
        // 每个dac_cmd_valid持续500个clk
        else if (cnt_spi == 14'd499) cnt_spi <= 14'd0;
        else cnt_spi <= cnt_spi + 1'b1;
    end

    wire clk_spi_en;
    assign clk_spi_en = (cnt_spi == 14'd1);


    reg [13:0] state_for_spi;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_for_spi <= 4'd0;
        else if (clk_spi_en && count_10kHz == 8) begin
            // state_for_spi应该是在count_10Khz==8中从0~19左右
            state_for_spi <= state_for_spi + 1'b1;
        end else if (count_10kHz != 8) state_for_spi <= 4'd0;
    end

    // there is only one clk cycle make clk_10kHz_en high in 0.1ms,
    // count_10kHz_init_dac用于指示DAC81416初始化的时序
    reg [15:0] count_10kHz_init_dac;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz_init_dac <= 16'd0;
        else if (clk_10kHz_en && start_init_dac) begin
            if (count_10kHz_init_dac == 16'd10000 - 1)  // time costs to 1s, Right !
                count_10kHz_init_dac <= 16'd0;
            else count_10kHz_init_dac <= count_10kHz_init_dac + 1'b1;
        end
    end


    // 确保初始化仅一次, 初始化一次之后,init_done_flag置 1
    // 回头看DAC81416的手册, 是dac_cmd_valid不能连续, 发送一次就要停止一次
    reg init_done_flag = 1'b0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            init_done_flag <= 1'b0;
            dac_cmd <= 24'h0;
            dac_cmd_valid <= 1'b0;
        end else begin         // 高的代码中 这一行本来有 else if (clk_10kHz_en), 我把 if (clk_10kHz_en)删除了
            if (!start) begin  // if no start signal and no init, then begin to initialization
                if (!init_done_flag) begin  // if initialization is not done, do initialization
                    case (count_10kHz_init_dac)
                        // 16'd0: 因为默认就是在state=0,所以这个状态不能用
                        // 初始化之前首先在输出电压地址寄存器写入0V
                        16'd1: begin
                            dac_cmd <= {1'b0, 1'b0, DAC0_DATA_REG_ADDR, 16'd32768};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd2: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd3: begin
                            dac_cmd <= {1'b0, 1'b0, DAC1_DATA_REG_ADDR, 16'd32768};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd4: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd5: begin
                            dac_cmd <= {1'b0, 1'b0, DAC3_DATA_REG_ADDR, 16'd32768};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd6: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd7: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE0_REG_ADDR, 16'd32768};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd8: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd9: begin
                            dac_cmd <= {1'b0, 1'b0, SPICONFIG_REG_ADDR, 16'h0A84};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd10: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd11: begin
                            dac_cmd <= {1'b0, 1'b0, GENCONFIG_REG_ADDR, 16'h3F00};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd12: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd13: begin
                            dac_cmd <= {1'b0, 1'b0, DACPWDWN_REG_ADDR, 16'hFFF0};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd14: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd15: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE0_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd16: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd17: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE1_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd18: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd19: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE2_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd20: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd21: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE3_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd22: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd23: begin
                            dac_cmd <= {1'b0, 1'b0, SYNCCONFIG_REG_ADDR, 16'hFFFF};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd24: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd32: begin
                            init_done_flag <= 1'b1;  // initialization is done
                        end
                    endcase
                end
            end else begin
                // send start signal only after initialization is completed
                // if receive start from PS, then enter the normal working phase
                // count_10kHz 从0到9,每个状态持续0.1ms,总时间为1ms
                case (count_10kHz)
                    // 目前设置在count_10kHz=8时,开始发送dac_cmd, 此状态下state_for_spi大概0~19
                    // 每个状态持续500个clk, 最后在state_for_spi=18时设置LDACn=0进行同步更新
                    8: begin
                        case (state_for_spi)
                            1: begin
                                dac_cmd <= {1'b0, 1'b0, DAC0_DATA_REG_ADDR, control_output0};
                                dac_cmd_valid <= 1'b1;
                            end
                            2: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            3: begin
                                dac_cmd <= {1'b0, 1'b0, DAC1_DATA_REG_ADDR, control_output1};
                                dac_cmd_valid <= 1'b1;
                            end
                            4: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            5: begin
                                dac_cmd <= {1'b0, 1'b0, DAC2_DATA_REG_ADDR, control_output2};
                                dac_cmd_valid <= 1'b1;
                            end
                            6: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            7: begin
                                dac_cmd <= {1'b0, 1'b0, DAC3_DATA_REG_ADDR, control_output3};
                                dac_cmd_valid <= 1'b1;
                            end
                            8: begin
                                dac_cmd_valid <= 1'b0;
                            end
                        endcase
                    end
                    default: begin
                        dac_cmd <= 0;
                        dac_cmd_valid <= 0;
                    end
                endcase
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) LDACn <= 1'b1;
        else if (count_10kHz_init_dac == 16'd32)  // initialization is done
            LDACn <= 1'b0;
        else
            case (state_for_spi)
                18: begin
                    LDACn <= 1'b0;
                end
                default: LDACn <= 1'b1;
            endcase
    end

endmodule
