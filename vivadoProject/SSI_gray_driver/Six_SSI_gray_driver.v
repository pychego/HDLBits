// 2024.11.22写
module Six_SSI_gray_driver (
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

    output reg [31:0] loc_data_gray0,  // 31bit, 为了和后面的模块数据对齐
    output reg [31:0] loc_data_gray1,
    output reg [31:0] loc_data_gray2,
    output reg [31:0] loc_data_gray3,
    output reg [31:0] loc_data_gray4,
    output reg [31:0] loc_data_gray5
);

    parameter WIDTH = 25;

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

    reg  [WIDTH-1:0] buffer0;  // 存放原始的gray数据
    reg  [WIDTH-1:0] buffer1;
    reg  [WIDTH-1:0] buffer2;
    reg  [WIDTH-1:0] buffer3;
    reg  [WIDTH-1:0] buffer4;
    reg  [WIDTH-1:0] buffer5;
    wire [WIDTH-1:0] binary0;  // 存放每次更新稳定后的位移数据
    wire [WIDTH-1:0] binary1;
    wire [WIDTH-1:0] binary2;
    wire [WIDTH-1:0] binary3;
    wire [WIDTH-1:0] binary4;
    wire [WIDTH-1:0] binary5;
    // SSI_data in the negedge of SSI_clk is stable
    // 在SSI_clk的下降沿读取SSI_data, 实际综合时用SSI_clk下降沿作为触发信号合适吗
    always @(negedge SSI_clk0, negedge rst_n) begin
        if (!rst_n) begin
            buffer0 <= 25'd0;
            buffer1 <= 25'd0;
            buffer2 <= 25'd0;
            buffer3 <= 25'd0;
            buffer4 <= 25'd0;
            buffer5 <= 25'd0;
        end else if (SSI_flag) begin
            buffer0 <= {buffer0[23:0], SSI_data0};  // SSI_clk首先读取MSB
            buffer1 <= {buffer1[23:0], SSI_data1};
            buffer2 <= {buffer2[23:0], SSI_data2};
            buffer3 <= {buffer3[23:0], SSI_data3};
            buffer4 <= {buffer4[23:0], SSI_data4};
            buffer5 <= {buffer5[23:0], SSI_data5};
        end else if (count_SSIclk == 8'd25) begin  // 已经有了25个下降沿了
            buffer0 <= 25'd0;  // 看波形图, buffer稳定的时间很长
            buffer1 <= 25'd0;
            buffer2 <= 25'd0;
            buffer3 <= 25'd0;
            buffer4 <= 25'd0;
            buffer5 <= 25'd0;
        end
    end


    // 一下将格雷码转化为二进制并输出
    genvar i;
    assign binary0[WIDTH-1] = buffer0[WIDTH-1];
    assign binary1[WIDTH-1] = buffer1[WIDTH-1];
    assign binary2[WIDTH-1] = buffer2[WIDTH-1];
    assign binary3[WIDTH-1] = buffer3[WIDTH-1];
    assign binary4[WIDTH-1] = buffer4[WIDTH-1];
    assign binary5[WIDTH-1] = buffer5[WIDTH-1];

    generate
        for (i = 0; i < WIDTH - 1; i = i + 1) begin : gen_binary
            assign binary0[WIDTH-2-i] = binary0[WIDTH-1-i] ^ buffer0[WIDTH-2-i];
            assign binary1[WIDTH-2-i] = binary1[WIDTH-1-i] ^ buffer1[WIDTH-2-i];
            assign binary2[WIDTH-2-i] = binary2[WIDTH-1-i] ^ buffer2[WIDTH-2-i];
            assign binary3[WIDTH-2-i] = binary3[WIDTH-1-i] ^ buffer3[WIDTH-2-i];
            assign binary4[WIDTH-2-i] = binary4[WIDTH-1-i] ^ buffer4[WIDTH-2-i];
            assign binary5[WIDTH-2-i] = binary5[WIDTH-1-i] ^ buffer5[WIDTH-2-i];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            loc_data_gray0 <= 0;
            loc_data_gray1 <= 0;
            loc_data_gray2 <= 0;
            loc_data_gray3 <= 0;
            loc_data_gray4 <= 0;
            loc_data_gray5 <= 0;
        end
        else if (count_1MHz == 72) begin
            loc_data_gray0 <= {{7{1'b0}}, binary0};
            loc_data_gray1 <= {{7{1'b0}}, binary1};
            loc_data_gray2 <= {{7{1'b0}}, binary2};
            loc_data_gray3 <= {{7{1'b0}}, binary3};
            loc_data_gray4 <= {{7{1'b0}}, binary4};
            loc_data_gray5 <= {{7{1'b0}}, binary5};
        end
        else begin
            loc_data_gray0 <= loc_data_gray0;
            loc_data_gray1 <= loc_data_gray1;
            loc_data_gray2 <= loc_data_gray2;
            loc_data_gray3 <= loc_data_gray3;
            loc_data_gray4 <= loc_data_gray4;
            loc_data_gray5 <= loc_data_gray5;
        end
    end


endmodule
/*
loc_data虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data
*/

