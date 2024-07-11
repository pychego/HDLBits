`timescale 1ns / 1ps

module SixValueVaild_tb ();

    reg         clk;
    reg         rst_n;
    reg         vld0;
    reg         vld1;
    reg         vld2;
    reg         vld3;
    reg         vld4;
    reg         vld5;
    reg  [31:0] InData0;
    reg  [31:0] InData1;
    reg  [31:0] InData2;
    reg  [31:0] InData3;
    reg  [31:0] InData4;
    reg  [31:0] InData5;
    wire [31:0] OutData0;
    wire [31:0] OutData1;
    wire [31:0] OutData2;
    wire [31:0] OutData3;
    wire [31:0] OutData4;
    wire [31:0] OutData5;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        vld0 = 1'b0;
        vld1 = 1'b0;
        vld2 = 1'b0;
        vld3 = 1'b0;
        vld4 = 1'b0;
        vld5 = 1'b0;
        InData0 = 1;
        InData1 = 2;
        InData2 = 3;
        InData3 = 4;
        InData4 = 5;
        InData5 = 6;
        #15 rst_n = 1'b1;
        #20 vld0 = 1'b1;
        #20 vld0 = 1'b0;
        #20 vld1 = 1'b1;
        #20 vld1 = 1'b0;
        #20 vld2 = 1'b1;
        #20 vld2 = 1'b0;
        #20 vld3 = 1'b1;
        #20 vld3 = 1'b0;
        #20 vld4 = 1'b1;
        #20 vld4 = 1'b0;
        #20 vld5 = 1'b1;
        #20 vld5 = 1'b0;
        InData0 = 7;
        InData1 = 8;
        InData2 = 9;
        InData3 = 10;
        InData4 = 11;
        InData5 = 12;
        #20 vld0 = 1'b1;
        #20 vld0 = 1'b0;
        #20 vld1 = 1'b1;
        #20 vld1 = 1'b0;
        #20 vld2 = 1'b1;
        #20 vld2 = 1'b0;
        #20 vld3 = 1'b1;
        #20 vld3 = 1'b0;
        #20 vld4 = 1'b1;
        #20 vld4 = 1'b0;
        #20 vld5 = 1'b1;
        #20 vld5 = 1'b0;
    end

    always #5 clk = ~clk;

    SixValueVaild u_SixValueVaild (
        .clk     (clk),
        .rst_n   (rst_n),
        .vld0    (vld0),
        .vld1    (vld1),
        .vld2    (vld2),
        .vld3    (vld3),
        .vld4    (vld4),
        .vld5    (vld5),
        .InData0 (InData0),
        .InData1 (InData1),
        .InData2 (InData2),
        .InData3 (InData3),
        .InData4 (InData4),
        .InData5 (InData5),
        .OutData0(OutData0),
        .OutData1(OutData1),
        .OutData2(OutData2),
        .OutData3(OutData3),
        .OutData4(OutData4),
        .OutData5(OutData5)
    );



endmodule
