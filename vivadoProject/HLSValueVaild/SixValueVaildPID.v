/* 用于承接HLS模块解算出来的数据和数据Vaild信号, 将有效的数据保持下来
 这个模块输入输出都是16bit, 专门承接PID模块的数据
*/

module SixValueVaildPID (
    input clk,
    input rst_n,

    input        vld0,
    input        vld1,
    input        vld2,
    input        vld3,
    input        vld4,
    input        vld5,
    input [15:0] InData0,
    input [15:0] InData1,
    input [15:0] InData2,
    input [15:0] InData3,
    input [15:0] InData4,
    input [15:0] InData5,

    output reg [15:0] OutData0,
    output reg [15:0] OutData1,
    output reg [15:0] OutData2,
    output reg [15:0] OutData3,
    output reg [15:0] OutData4,
    output reg [15:0] OutData5
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            OutData0 <= 0;
            OutData1 <= 0;
            OutData2 <= 0;
            OutData3 <= 0;
            OutData4 <= 0;
            OutData5 <= 0;
        end
    end

    always @(posedge clk) begin
        if (vld0 == 1) OutData0 <= InData0;
        else OutData0 <= OutData0;
    end

    always @(posedge clk) begin
        if (vld1 == 1) OutData1 <= InData1;
        else OutData1 <= OutData1;
    end

    always @(posedge clk) begin
        if (vld2 == 1) OutData2 <= InData2;
        else OutData2 <= OutData2;
    end

    always @(posedge clk) begin
        if (vld3 == 1) OutData3 <= InData3;
        else OutData3 <= OutData3;
    end

    always @(posedge clk) begin
        if (vld4 == 1) OutData4 <= InData4;
        else OutData4 <= OutData4;
    end

    always @(posedge clk) begin
        if (vld5 == 1) OutData5 <= InData5;
        else OutData5 <= OutData5;
    end

endmodule
