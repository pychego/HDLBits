/*  2024.11.22 规范了代码写法, 复习了SSI驱动
端口: 
    SSI_data  传感器差分信号经MAX3077变为单端信号，给zynq
    SSI_clk   输出(单端) => MAX3077(差分) => 传感器
    loc_data  并行位移数据, 为了与后面后面接口一致,用0扩充到32bits,仅低25bit有用

原理:
    根据SSI时序可知，SSI_clk每来一个上升沿,传感器就送入一个SSI_data 因此要设计在SSI_clk下降沿读取SSI_data
    通过25个SSI_clk的下降沿, 读取25个串行SSI_data
时序:
    通过时序图可知 loc_data 大概73us更新一次，1ms内更新13次，完全够用的; 
*/

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
    output reg SSI_clk1,  // output to sensor
    output reg SSI_clk2,  // output to sensor
    output reg SSI_clk3,  // output to sensor
    output reg SSI_clk4,  // output to sensor
    output reg SSI_clk5,  // output to sensor

    output [31:0] loc_data0,  // 31bit, 为了和后面的模块数据对齐
    output [31:0] loc_data1,
    output [31:0] loc_data2,
    output [31:0] loc_data3,
    output [31:0] loc_data4,
    output [31:0] loc_data5
);

    // 根据cnt计数设计1MHz信号(实验室开发板时钟为100Mhz)
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 8'd0;
        else if (cnt == 8'd99) cnt <= 8'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_1MHz_en;
    assign clk_1MHz_en = (cnt == 8'd1);

    // count_1MHz 从0到72循环, 一共73个状态
    // count_1MHz在每个状态停留的时间是 1 / 1MHz
    reg [7:0] count_1MHz;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) count_1MHz <= 8'd0;
        else if (clk_1MHz_en) begin
            if (count_1MHz > 8'd71) count_1MHz <= 0;
            else count_1MHz <= count_1MHz + 1;
        end
    end

    /*  SSI_clk's frequency is 1Mhz / 2 = 500kHz
        if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk翻转了51次
        由于第一次翻转前是0, 翻转51次产生了25个上升沿, 同时最后保持高电平1
    */
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            SSI_clk0 <= 1'b1;
            SSI_clk1 <= 1'b1;
            SSI_clk2 <= 1'b1;
            SSI_clk3 <= 1'b1;
            SSI_clk4 <= 1'b1;
            SSI_clk5 <= 1'b1;
        end else if (clk_1MHz_en) begin
            if (count_1MHz < 20) begin
                SSI_clk0 <= 1'b1;
                SSI_clk1 <= 1'b1;
                SSI_clk2 <= 1'b1;
                SSI_clk3 <= 1'b1;
                SSI_clk4 <= 1'b1;
                SSI_clk5 <= 1'b1;
            end else if (count_1MHz == 20) begin
                SSI_clk0 <= 1'b0;
                SSI_clk1 <= 1'b0;
                SSI_clk2 <= 1'b0;
                SSI_clk3 <= 1'b0;
                SSI_clk4 <= 1'b0;
                SSI_clk5 <= 1'b0;
            end else if (count_1MHz > 20 && count_1MHz <= 71) begin
                SSI_clk0 <= ~SSI_clk0;
                SSI_clk1 <= ~SSI_clk1;
                SSI_clk2 <= ~SSI_clk2;
                SSI_clk3 <= ~SSI_clk3;
                SSI_clk4 <= ~SSI_clk4;
                SSI_clk5 <= ~SSI_clk5;
            end else begin
                SSI_clk0 <= SSI_clk0;
                SSI_clk1 <= SSI_clk1;
                SSI_clk2 <= SSI_clk2;
                SSI_clk3 <= SSI_clk3;
                SSI_clk4 <= SSI_clk4;
                SSI_clk5 <= SSI_clk5;
            end
        end
    end

    /* SSI_flag is used to indicate the SSI_clk is in the period of 22~71
       SSI_flag 用来指示这段时间的SSI_clk的下降沿可用, 是用来取data的,
       SSI_flag 在22_71状态下为1, 这段时间有25个完整的下降沿
    */
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

    // 25 SSI_clk neg edge
    reg [7:0] count_SSIclk;
    always @(negedge SSI_clk0, negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end
    // 以上为时钟设置




    /* 设置通道输出 loc_data0 ****************************************/
    reg [24:0] data_buffer0;
    reg [24:0] loc_data_25bit0;
    // SSI_data0 in the negedge od SSI_clk0 is stable
    // 由于SSI_clk 6个完全相同,这里直接统一用了SSI_clk0
    always @(negedge SSI_clk0 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit0 <= 25'd0;
            data_buffer0   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer0 <= {data_buffer0[23:0], SSI_data0};
        end else if (count_SSIclk == 8'd25) begin
            // time is count_SSIclk from 25 to 0
            // 如果是二进制的位移传感器, 那得到loc_data0_gray程序就结束了
            loc_data_25bit0 <= data_buffer0;
            data_buffer0   <= 25'd0;
        end
    end

    assign loc_data0 = {{7{1'b0}}, loc_data_25bit0};


    /* 设置通道输出 loc_data1 ****************************************/
    reg [24:0] data_buffer1;
    reg [24:0] loc_data_25bit1;
    always @(negedge SSI_clk1 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit1 <= 25'd0;
            data_buffer1   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer1 <= {data_buffer1[23:0], SSI_data1};
        end else if (count_SSIclk == 8'd25) begin
            loc_data_25bit1 <= data_buffer1;
            data_buffer1   <= 25'd0;
        end
    end

    assign loc_data1 = {{7{1'b0}}, loc_data_25bit1};


    /* 设置通道输出 loc_data2 ****************************************/
    reg [24:0] data_buffer2;
    reg [24:0] loc_data_25bit2;
    always @(negedge SSI_clk2 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit2 <= 25'd0;
            data_buffer2   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer2 <= {data_buffer2[23:0], SSI_data2};
        end else if (count_SSIclk == 8'd25) begin
            loc_data_25bit2 <= data_buffer2;
            data_buffer2   <= 25'd0;
        end
    end

    assign loc_data2 = {{7{1'b0}}, loc_data_25bit2};


    /* 设置通道输出 loc_data3 ****************************************/
    reg [24:0] data_buffer3;
    reg [24:0] loc_data_25bit3;
    always @(negedge SSI_clk3 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit3 <= 25'd0;
            data_buffer3   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer3 <= {data_buffer3[23:0], SSI_data3};
        end else if (count_SSIclk == 8'd25) begin
            loc_data_25bit3 <= data_buffer3;
            data_buffer3   <= 25'd0;
        end
    end

    assign loc_data3 = {{7{1'b0}}, loc_data_25bit3};


    /* 设置通道输出 loc_data4 ****************************************/
    reg [24:0] data_buffer4;
    reg [24:0] loc_data_25bit4;
    always @(negedge SSI_clk4 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit4 <= 25'd0;
            data_buffer4   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer4 <= {data_buffer4[23:0], SSI_data4};
        end else if (count_SSIclk == 8'd25) begin
            loc_data_25bit4 <= data_buffer4;
            data_buffer4   <= 25'd0;
        end
    end

    assign loc_data4 = {{7{1'b0}}, loc_data_25bit4};


    /* 设置通道输出 loc_data5 ****************************************/
    reg [24:0] data_buffer5;
    reg [24:0] loc_data_25bit5;
    always @(negedge SSI_clk5 or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_25bit5 <= 25'd0;
            data_buffer5   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer5 <= {data_buffer5[23:0], SSI_data5};
        end else if (count_SSIclk == 8'd25) begin
            loc_data_25bit5 <= data_buffer5;
            data_buffer5   <= 25'd0;
        end
    end

    assign loc_data5  = {{7{1'b0}}, loc_data_25bit5};

endmodule
/*
loc_data虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data
*/

