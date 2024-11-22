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

module SSI_gray_driver (
    input clk,
    input rst_n,
    input SSI_data,

    output reg        SSI_clk,
    output reg [31:0] loc_data_gray
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
        if (!rst_n) SSI_clk <= 1'b1;
        else if (clk_1MHz_en) begin
            if (count_1MHz < 20) SSI_clk <= 1'b1;
            else if (count_1MHz == 20) SSI_clk <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk <= ~SSI_clk;
            else SSI_clk <= SSI_clk;
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
    always @(negedge SSI_clk, negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end


    reg  [WIDTH-1:0] buffer;  // 存放原始的gray数据
    wire [WIDTH-1:0] binary;  // 存放每次更新稳定后的位移数据
    // SSI_data in the negedge of SSI_clk is stable
    // 在SSI_clk的下降沿读取SSI_data, 实际综合时用SSI_clk下降沿作为触发信号合适吗
    always @(negedge SSI_clk, negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 25'd0;
        end else if (SSI_flag) begin
            buffer <= {buffer[23:0], SSI_data};  // SSI_clk首先读取MSB
        end else if (count_SSIclk == 8'd25) begin  // 已经有了25个下降沿了
            buffer <= 25'd0;    // 看波形图, buffer稳定的时间很长
        end
    end


    // 一下将格雷码转化为二进制并输出
    genvar i;
    assign binary[WIDTH-1] = buffer[WIDTH-1];

    generate
        for (i = 0; i < WIDTH - 1; i = i + 1) begin : gen_binary
            assign binary[WIDTH-2-i] = binary[WIDTH-1-i] ^ buffer[WIDTH-2-i];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) loc_data_gray <= 0;
        else if (count_1MHz == 72) loc_data_gray <= {{7{1'b0}}, binary};
        else loc_data_gray <= loc_data_gray;
    end


endmodule
/*
loc_data虽然一直在变, 但是根据BRAM_wr_controller
的时序要求, 是从bram_we=1的期间写入该时刻的 loc_data
*/

