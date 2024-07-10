// 完全复制SSI_binary_driver.v而来
// 适用于紫金港六自由度平台
module Six_SSI_binary_driver (
    input clk,
    input rst_n,
    input SSI_data0,  // 传感器差分信号经MAX3077变为单端信号，给zynq
    input SSI_data1,
    input SSI_data2,
    input SSI_data3,
    input SSI_data4,
    input SSI_data5,

    output reg SSI_clk0,  // output to sensor
    output     SSI_clk1,  // output to sensor
    output     SSI_clk2,  // output to sensor
    output     SSI_clk3,  // output to sensor
    output     SSI_clk4,  // output to sensor
    output     SSI_clk5,  // output to sensor

    output [31:0] loc_data0,  // 31bit, 为了和后面的模块数据对齐
    output [31:0] loc_data1,
    output [31:0] loc_data2,
    output [31:0] loc_data3,
    output [31:0] loc_data4,
    output [31:0] loc_data5
);
    // 根据SSI时序可知，SSI_clk0每来一个上升沿传感器就送入一个SSI_data0 因此要设计在SSI_clk0下降沿读取SSI_data0

    // 根据cnt计数设计1MHz信号
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 8'd0;
        else if (cnt == 8'd99) cnt <= 8'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_1MHz_en;
    assign clk_1MHz_en = (cnt == 8'd1);

    // count_1MHz from 0 to 72, 73 states in total
    // count_1MHz在每个状态停留的时间是 1 / 1MHz
    reg [7:0] count_1MHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_1MHz <= 8'd0;
        else if (clk_1MHz_en) begin
            count_1MHz <= count_1MHz + 1'b1;
            if (count_1MHz > 8'd71) count_1MHz <= 8'd0;
        end
    end

    // SSI_clk0's frequency is 1Mhz / 2 = 500kHz
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_clk0 <= 1'b1;
        else if (clk_1MHz_en) begin
            if (count_1MHz < 20) SSI_clk0 <= 1'b1;
            else if (count_1MHz == 20) SSI_clk0 <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk0 <= ~SSI_clk0;
            else SSI_clk0 <= SSI_clk0;
        end
    end

    // SSI_flag is used to indicate the SSI_clk0 is in the period of 22~71
    reg SSI_flag;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_flag <= 1'b0;
        else if (clk_1MHz_en) begin
            if (count_1MHz <= 20) SSI_flag <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz < 71) SSI_flag <= 1'b1;
            else if (count_1MHz == 71) SSI_flag <= 1'b0;
            else SSI_flag <= 1'b0;
        end
    end

    // 25 SSI_clk0 neg edge
    reg [7:0] count_SSIclk;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end

    assign SSI_clk1 = SSI_clk0;
    assign SSI_clk2 = SSI_clk0;
    assign SSI_clk3 = SSI_clk0;
    assign SSI_clk4 = SSI_clk0;
    assign SSI_clk5 = SSI_clk0;
    /* 以上为时钟输出信号的设置 ****************************************/


    /* 设置通道输出 loc_data0 ****************************************/
    (*mark_DEBUG = "TRUE"*)reg [24:0] data_buffer0;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data0_gray;
    // SSI_data0 in the negedge od SSI_clk0 is stable
    // 由于SSI_clk 6个完全相同,这里直接统一用了SSI_clk0
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data0_gray <= 25'd0;
            data_buffer0   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer0 <= {data_buffer0[23:0], SSI_data0};
        end else if (count_SSIclk == 8'd25) begin
            // time is count_SSIclk from 25 to 0
            // 如果是二进制的位移传感器, 那得到loc_data0_gray程序就结束了
            loc_data0_gray <= data_buffer0;
            data_buffer0   <= 25'd0;
        end
    end

    // 这里使用了低位宽数据给高位宽数据赋值,应该是没啥问题
    assign loc_data0 = loc_data0_gray;


    /* 设置通道输出 loc_data1 ****************************************/
    (*mark_DEBUG = "TRUE"*)reg [24:0] data_buffer1;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data1_gray;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data1_gray <= 25'd0;
            data_buffer1   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer1 <= {data_buffer1[23:0], SSI_data1};
        end else if (count_SSIclk == 8'd25) begin
            loc_data1_gray <= data_buffer1;
            data_buffer1   <= 25'd0;
        end
    end

    assign loc_data1 = loc_data1_gray;


    /* 设置通道输出 loc_data2 ****************************************/
    reg [24:0] data_buffer2;
    reg [24:0] loc_data2_gray;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data2_gray <= 25'd0;
            data_buffer2   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer2 <= {data_buffer2[23:0], SSI_data2};
        end else if (count_SSIclk == 8'd25) begin
            loc_data2_gray <= data_buffer2;
            data_buffer2   <= 25'd0;
        end
    end

    assign loc_data2 = loc_data2_gray;


    /* 设置通道输出 loc_data3 ****************************************/
    reg [24:0] data_buffer3;
    reg [24:0] loc_data3_gray;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data3_gray <= 25'd0;
            data_buffer3   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer3 <= {data_buffer3[23:0], SSI_data3};
        end else if (count_SSIclk == 8'd25) begin
            loc_data3_gray <= data_buffer3;
            data_buffer3   <= 25'd0;
        end
    end

    assign loc_data3 = loc_data3_gray;

    /* 设置通道输出 loc_data4 ****************************************/
    reg [24:0] data_buffer4;
    reg [24:0] loc_data4_gray;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data4_gray <= 25'd0;
            data_buffer4   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer4 <= {data_buffer4[23:0], SSI_data4};
        end else if (count_SSIclk == 8'd25) begin
            loc_data4_gray <= data_buffer4;
            data_buffer4   <= 25'd0;
        end
    end

    assign loc_data4 = loc_data4_gray;

    /* 设置通道输出 loc_data5 ****************************************/
    reg [24:0] data_buffer5;
    reg [24:0] loc_data5_gray;
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data5_gray <= 25'd0;
            data_buffer5   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer5 <= {data_buffer5[23:0], SSI_data5};
        end else if (count_SSIclk == 8'd25) begin
            loc_data5_gray <= data_buffer5;
            data_buffer5   <= 25'd0;
        end
    end

    assign loc_data5 = loc_data5_gray;


endmodule
/*
此为二进制传感器的驱动模块，输出是二进制的位移数据[24:0] loc_data0 但我需要知道这25位代表的实际位移是多少

我改动的部分，在case刚进入0的时候，保存下来loc_data0_gray为loc_data0_gray_r，在case的0-25这一轮，loc_data0_gray_r
保持不变，这样可保证loc_data0_binary_r不会出现不稳定的暂态

通过时序图可知 loc_data0 大概73us更新一次，1ms内更新13次，完全够用的; loc_data0虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data0
*/

