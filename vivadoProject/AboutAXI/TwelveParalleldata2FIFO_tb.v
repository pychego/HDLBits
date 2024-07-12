`timescale 1ns / 1ps

module TwelveParalleldata2FIFO_tb ();
    reg         clk;
    reg         rst_n;
    reg  [31:0] data0;
    reg  [31:0] data1;
    reg  [31:0] data2;
    reg  [31:0] data3;
    reg  [31:0] data4;
    reg  [31:0] data5;
    reg  [31:0] data6;
    reg  [31:0] data7;
    reg  [31:0] data8;
    reg  [31:0] data9;
    reg  [31:0] data10;
    reg  [31:0] data11;

    wire [31:0] M_AXIS_tdata;
    wire [ 3:0] M_AXIS_tkeep;
    wire        M_AXIS_tlast;
    reg         M_AXIS_tready;
    wire        M_AXIS_tvalid;

    TwelveParalleldata2FIFO uut (
        .clk          (clk),
        .rst_n        (rst_n),
        .data0        (data0),
        .data1        (data1),
        .data2        (data2),
        .data3        (data3),
        .data4        (data4),
        .data5        (data5),
        .data6        (data6),
        .data7        (data7),
        .data8        (data8),
        .data9        (data9),
        .data10       (data10),
        .data11       (data11),
        .M_AXIS_tdata (M_AXIS_tdata),
        .M_AXIS_tkeep (M_AXIS_tkeep),
        .M_AXIS_tlast (M_AXIS_tlast),
        .M_AXIS_tready(M_AXIS_tready),
        .M_AXIS_tvalid(M_AXIS_tvalid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        M_AXIS_tready = 0;
        data0 = 32'h00000000;
        data1 = 32'h00000001;
        data2 = 32'h00000002;
        data3 = 32'h00000003;
        data4 = 32'h00000004;
        data5 = 32'h00000005;
        data6 = 32'h00000006;
        data7 = 32'h00000007;
        data8 = 32'h00000008;
        data9 = 32'h00000009;
        data10 = 32'h0000000A;
        data11 = 32'h0000000B;
        #15 rst_n = 1;
        #43 M_AXIS_tready = 1;
    end

endmodule
