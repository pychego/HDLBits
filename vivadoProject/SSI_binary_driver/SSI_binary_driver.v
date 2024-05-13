// what is the position of this module in the entire design?
// 为了方便与AXI总线传输, 将输出设置成32bit, 但是实际只有25bit有用
module SSI_binary_driver (
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
            // 如果是二进制的位移传感器, 那得到loc_data_gray程序就结束了
            loc_data_gray <= data_buffer;
            data_buffer   <= 25'd0;
        end
    end

    assign loc_data = loc_data_gray;

    // 需不需要设置复位？ 感觉不需要

endmodule
/*
此为格雷码传感器的驱动模块，输出是二进制的位移数据[24:0] loc_data 但我需要知道这25位代表的实际位移是多少

我改动的部分，在case刚进入0的时候，保存下来loc_data_gray为loc_data_gray_r，在case的0-25这一轮，loc_data_gray_r
保持不变，这样可保证loc_data_binary_r不会出现不稳定的暂态

通过时序图可知 loc_data 大概73us更新一次，1ms内更新13次，完全够用的; loc_data虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data
*/

