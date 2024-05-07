// what is the position of this module in the entire design?
module SSI_gray_driver (
    input clk,
    input rst_n,
    (*mark_DEBUG = "TRUE"*) input SSI_data,            // 传感器差分信号经MAX3077变为单端信号，给zynq

    (*mark_DEBUG = "TRUE"*) output reg        SSI_clk,  // output to sensor
    (*mark_DEBUG = "TRUE"*) output     [24:0] loc_data  // 25bit
);
    // 根据SSI时序可知，SSI_clk每来一个上升沿传感器就送入一个SSI_data 因此要设计在SSI_clk下降沿读取SSI_data

    // 根据cnt计数设计1MHz信号
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 8'd0;
        else if (cnt == 8'd99) cnt <= 8'd0;
        else cnt <= cnt + 1'b1;
    end

    (*mark_DEBUG = "TRUE"*) wire clk_1MHz_en;
    assign clk_1MHz_en = (cnt == 8'd1);

    // count_1MHz from 0 to 72, 73 states in total
    // count_1MHz在每个状态停留的时间是 1 / 1MHz
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_1MHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_1MHz <= 8'd0;
        else if (clk_1MHz_en) begin
            count_1MHz <= count_1MHz + 1'b1;
            if (count_1MHz > 8'd71) count_1MHz <= 8'd0;
        end
    end

    // SSI_clk's frequency is 1Mhz / 2 = 500kHz
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_clk <= 1'b1;
        else if (clk_1MHz_en) begin
            if (count_1MHz < 20) SSI_clk <= 1'b1;
            else if (count_1MHz == 20) SSI_clk <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk <= ~SSI_clk;
            else SSI_clk <= SSI_clk;
        end
    end

    // SSI_flag is used to indicate the SSI_clk is in the period of 22~71
    (*mark_DEBUG = "TRUE"*) reg SSI_flag;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_flag <= 1'b0;
        else if (clk_1MHz_en) begin
            if (count_1MHz <= 20) SSI_flag <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz < 71) SSI_flag <= 1'b1;
            else if (count_1MHz == 71) SSI_flag <= 1'b0;
            else SSI_flag <= 1'b0;
        end
    end

    // 25 SSI_clk neg edge
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_SSIclk;
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end

    (*mark_DEBUG = "TRUE"*)reg [24:0] data_buffer;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_gray;
    // SSI_data in the negedge od SSI_clk is stable
    // 在SSI_clk的下降沿读取SSI_data, 实际综合时用SSI_clk下降沿作为触发信号合适吗
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_gray <= 25'd0;
            data_buffer   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer <= {data_buffer[23:0], SSI_data};
        end else if (count_SSIclk == 8'd25) begin
            // time is count_SSIclk from 25 to 0
            loc_data_gray <= data_buffer;
            data_buffer   <= 25'd0;
        end
    end

    reg [ 4:0] i = 0;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_binary;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_binary_r;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_gray_r;

    // ???
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) i <= 5'd0;
        else begin
            i <= i + 1'b1;
            case (i)  // gray格雷码 to binary principle
                // Force Serial 其实是强制转换为串行操作了，
                // 看仿真知道高的代码loc_data_binary_r也有暂态， 原因是在下面的转换过程中loc_data_gray也可能会变化
                5'd0: begin
                    loc_data_binary[24] <= loc_data_gray[24];
                    loc_data_gray_r <= loc_data_gray;
                end
                5'd1: loc_data_binary[23] <= loc_data_binary[24] ^ loc_data_gray_r[23];
                5'd2: loc_data_binary[22] <= loc_data_binary[23] ^ loc_data_gray_r[22];
                5'd3: loc_data_binary[21] <= loc_data_binary[22] ^ loc_data_gray_r[21];
                5'd4: loc_data_binary[20] <= loc_data_binary[21] ^ loc_data_gray_r[20];
                5'd5: loc_data_binary[19] <= loc_data_binary[20] ^ loc_data_gray_r[19];
                5'd6: loc_data_binary[18] <= loc_data_binary[19] ^ loc_data_gray_r[18];
                5'd7: loc_data_binary[17] <= loc_data_binary[18] ^ loc_data_gray_r[17];
                5'd8: loc_data_binary[16] <= loc_data_binary[17] ^ loc_data_gray_r[16];
                5'd9: loc_data_binary[15] <= loc_data_binary[16] ^ loc_data_gray_r[15];
                5'd10: loc_data_binary[14] <= loc_data_binary[15] ^ loc_data_gray_r[14];
                5'd11: loc_data_binary[13] <= loc_data_binary[14] ^ loc_data_gray_r[13];
                5'd12: loc_data_binary[12] <= loc_data_binary[13] ^ loc_data_gray_r[12];
                5'd13: loc_data_binary[11] <= loc_data_binary[12] ^ loc_data_gray_r[11];
                5'd14: loc_data_binary[10] <= loc_data_binary[11] ^ loc_data_gray_r[10];
                5'd15: loc_data_binary[9] <= loc_data_binary[10] ^ loc_data_gray_r[9];
                5'd16: loc_data_binary[8] <= loc_data_binary[9] ^ loc_data_gray_r[8];
                5'd17: loc_data_binary[7] <= loc_data_binary[8] ^ loc_data_gray_r[7];
                5'd18: loc_data_binary[6] <= loc_data_binary[7] ^ loc_data_gray_r[6];
                5'd19: loc_data_binary[5] <= loc_data_binary[6] ^ loc_data_gray_r[5];
                5'd20: loc_data_binary[4] <= loc_data_binary[5] ^ loc_data_gray_r[4];
                5'd21: loc_data_binary[3] <= loc_data_binary[4] ^ loc_data_gray_r[3];
                5'd22: loc_data_binary[2] <= loc_data_binary[3] ^ loc_data_gray_r[2];
                5'd23: loc_data_binary[1] <= loc_data_binary[2] ^ loc_data_gray_r[1];
                5'd24: loc_data_binary[0] <= loc_data_binary[1] ^ loc_data_gray_r[0];
                5'd25: begin
                    // 这个地方是为了解决loc_data_binary的不稳定状态
                    // 加了一个时序和一个寄存器， 保证loc_data_binary_r存放的都是稳定的位移数据
                    // 看loc_data_binary_r改变的频率就是位移数据改变的频率了
                    loc_data_binary_r <= loc_data_binary;
                    i <= 5'd0;
                end
                default: i <= 5'd0;
            endcase
        end
    end

    assign loc_data = loc_data_binary_r;

    // 需不需要设置复位？ 感觉不需要

endmodule
/*
此为格雷码传感器的驱动模块，输出是二进制的位移数据[24:0] loc_data 但我需要知道这25位代表的实际位移是多少

我改动的部分，在case刚进入0的时候，保存下来loc_data_gray为loc_data_gray_r，在case的0-25这一轮，loc_data_gray_r
保持不变，这样可保证loc_data_binary_r不会出现不稳定的暂态

通过时序图可知 loc_data 大概73us更新一次，1ms内更新13次，完全够用的; loc_data虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data
*/

