/* 用于承接HLS模块解算出来的数据和数据Vaild信号, 将有效的数据保持下来
*/

module TwelveValueVaild (
    input clk,
    input rst_n,

    input        vld1,
    input        vld2,
    input        vld3,
    input        vld4,
    input        vld5,
    input        vld6,
    input        vld7,
    input        vld8,
    input        vld9,
    input        vld10,
    input        vld11,
    input        vld12,
    input [31:0] InData1,
    input [31:0] InData2,
    input [31:0] InData3,
    input [31:0] InData4,
    input [31:0] InData5,
    input [31:0] InData6,
    input [31:0] InData7,
    input [31:0] InData8,
    input [31:0] InData9,
    input [31:0] InData10,
    input [31:0] InData11,
    input [31:0] InData12,

    output reg [31:0] OutData1,
    output reg [31:0] OutData2,
    output reg [31:0] OutData3,
    output reg [31:0] OutData4,
    output reg [31:0] OutData5,
    output reg [31:0] OutData6,
    output reg [31:0] OutData7,
    output reg [31:0] OutData8,
    output reg [31:0] OutData9,
    output reg [31:0] OutData10,
    output reg [31:0] OutData11,
    output reg [31:0] OutData12
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            OutData1 <= 0;
            OutData2 <= 0;
            OutData3 <= 0;
            OutData4 <= 0;
            OutData5 <= 0;
            OutData6 <= 0;
            OutData7 <= 0;
            OutData8 <= 0;
            OutData9 <= 0;
            OutData10 <= 0;
            OutData11 <= 0;
            OutData12 <= 0;
        end
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

    always @(posedge clk) begin
        if (vld6 == 1) OutData6 <= InData6;
        else OutData6 <= OutData6;
    end

    always @(posedge clk) begin
        if (vld7 == 1) OutData7 <= InData7;
        else OutData7 <= OutData7;
    end

    always @(posedge clk) begin
        if (vld8 == 1) OutData8 <= InData8;
        else OutData8 <= OutData8;
    end

    always @(posedge clk) begin
        if (vld9 == 1) OutData9 <= InData9;
        else OutData9 <= OutData9;
    end

    always @(posedge clk) begin
        if (vld10 == 1) OutData10 <= InData10;
        else OutData10 <= OutData10;
    end

    always @(posedge clk) begin
        if (vld11 == 1) OutData11 <= InData11;
        else OutData11 <= OutData11;
    end

    always @(posedge clk) begin
        if (vld12 == 1) OutData12 <= InData12;
        else OutData12 <= OutData12;
    end


endmodule
