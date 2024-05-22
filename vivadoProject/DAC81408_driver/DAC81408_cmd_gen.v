module DAC81408_cmd_gen (
    input        clk,
    input        rst_n,
    input        start_init_dac,
    input        start,             // start 和 start_init_dac 都来自GPIO
    input [15:0] control_output4,   // Waiting to write to DAC register
    input [15:0] control_output5,
    input [15:0] control_output6,
    input [15:0] control_output7,
    input [15:0] control_output8,
    input [15:0] control_output9,
    input [15:0] control_output10,
    input [15:0] control_output11,
    output reg [23:0] dac_cmd,        // the two signals are passed to DAC81416_spi
    output reg        dac_cmd_valid,  // 声明此时的dac_cmd是有效的
    output reg        LDACn
);


    // 配置DAC81408的寄存器地址, 注意是08, 不是16
    localparam SPICONFIG_REG_ADDR = 6'b000011;  // offset   3h
    localparam GENCONFIG_REG_ADDR = 6'b000100;  // 04h
    localparam SYNCCONFIG_REG_ADDR = 6'b000110; // 06h
    localparam DACPWDWN_REG_ADDR = 6'b001001;   // 09h
    localparam DACRANGE0_REG_ADDR = 6'b001011;  // 0Bh
    localparam DACRANGE1_REG_ADDR = 6'b001100;  // 0Ch

    localparam DAC0_DATA_REG_ADDR = 6'b010100;  // 14h
    localparam DAC1_DATA_REG_ADDR = 6'b010101;  // 15h
    localparam DAC2_DATA_REG_ADDR = 6'b010110;  // 16h
    localparam DAC3_DATA_REG_ADDR = 6'b010111;  // 17h
    localparam DAC4_DATA_REG_ADDR = 6'b011000;  // 18h
    localparam DAC5_DATA_REG_ADDR = 6'b011001;  // 19h
    localparam DAC6_DATA_REG_ADDR = 6'b011010;  // 1Ah
    localparam DAC7_DATA_REG_ADDR = 6'b011011;  // 1Bh



    // this is a counter from 0 to 9999, which is used to generate a 10kHz clock
    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;  // if rst_n is low, reset the counter
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // count_10kHz from 0 to 9, which is a control cycle, 1ms
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

    // test this signal,
    // there is only one clk cycle make clk_10kHz_en high in 0.1ms,
    // count_10kHz_init_dac is used to indicate the time order of DAC initialization
    // count_10kHz_init_dac
    reg [15:0] count_10kHz_init_dac;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz_init_dac <= 16'd0;
        else if (clk_10kHz_en && start_init_dac) begin
            if (count_10kHz_init_dac == 16'd10000 - 1)  // time costs to 1s, Right !
                count_10kHz_init_dac <= 16'd0;
            else count_10kHz_init_dac <= count_10kHz_init_dac + 1'b1;
        end
    end

    // this code can make sure initialization only once
    // 初始化一次之后,init_done_flag 置 1
    reg init_done_flag = 1'b0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            init_done_flag <= 1'b0;
            dac_cmd <= 24'h0;
            dac_cmd_valid <= 1'b0;
        end else begin
            if (!start) begin  // if no start signal and no init, then begin to initialization
                if (!init_done_flag) begin  // if initialization is not done, do initialization
                    case (count_10kHz_init_dac)
                        // 16'd0: 因为默认就是在state=0,所以这个状态不能用
                        16'd1: begin
                            dac_cmd <= {1'b0, 1'b0, SPICONFIG_REG_ADDR, 16'h0A84};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd2: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd3: begin
                            dac_cmd <= {1'b0, 1'b0, GENCONFIG_REG_ADDR, 16'h3F00};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd4: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd5: begin
                            dac_cmd <= {1'b0, 1'b0, DACPWDWN_REG_ADDR, 16'hF00F};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd6: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd7: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE0_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd8: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd9: begin
                            dac_cmd <= {1'b0, 1'b0, DACRANGE1_REG_ADDR, 16'hAAAA};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd10: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd11: begin
                            dac_cmd <= {1'b0, 1'b0, SYNCCONFIG_REG_ADDR, 16'h0FF0};
                            dac_cmd_valid <= 1'b1;
                        end
                        16'd12: begin
                            dac_cmd_valid <= 1'b0;
                        end
                        16'd20: begin
                            init_done_flag <= 1'b1;  // initialization is done
                        end
                    endcase
                end
            end else begin
                // 传输 DAC 电压信号
                case (count_10kHz)
                    8: begin
                        // 目前设置在count_10kHz=8时,开始发送dac_cmd, 此状态下state_for_spi大概0~19
                        // 每个状态持续500个clk, 最后在state_for_spi=18时设置LDACn=0进行同步更新
                        case (state_for_spi)
                            1: begin
                                dac_cmd <= {1'b0, 1'b0, DAC0_DATA_REG_ADDR, control_output4};
                                dac_cmd_valid <= 1'b1;
                            end
                            2: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            3: begin
                                dac_cmd <= {1'b0, 1'b0, DAC1_DATA_REG_ADDR, control_output5};
                                dac_cmd_valid <= 1'b1;
                            end
                            4: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            5: begin
                                dac_cmd <= {1'b0, 1'b0, DAC2_DATA_REG_ADDR, control_output6};
                                dac_cmd_valid <= 1'b1;
                            end
                            6: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            7: begin
                                dac_cmd <= {1'b0, 1'b0, DAC3_DATA_REG_ADDR, control_output7};
                                dac_cmd_valid <= 1'b1;
                            end
                            8: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            9: begin
                                dac_cmd <= {1'b0, 1'b0, DAC4_DATA_REG_ADDR, control_output8};
                                dac_cmd_valid <= 1'b1;
                            end
                            10: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            11: begin
                                dac_cmd <= {1'b0, 1'b0, DAC5_DATA_REG_ADDR, control_output9};
                                dac_cmd_valid <= 1'b1;
                            end
                            12: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            13: begin
                                dac_cmd <= {1'b0, 1'b0, DAC6_DATA_REG_ADDR, control_output10};
                                dac_cmd_valid <= 1'b1;
                            end
                            14: begin
                                dac_cmd_valid <= 1'b0;
                            end
                            15: begin
                                dac_cmd <= {1'b0, 1'b0, DAC7_DATA_REG_ADDR, control_output11};
                                dac_cmd_valid <= 1'b1;
                            end
                            16: begin
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

    // 此处和DAC81416的LDACn信号是一样的
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) LDACn <= 1'b1;
        else
            case (state_for_spi)
                18: begin
                    LDACn <= 1'b0;
                end
                default: LDACn <= 1'b1;
            endcase
    end

endmodule
