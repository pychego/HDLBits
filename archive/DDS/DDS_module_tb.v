// 更改fword频率控制字, 测试DDS的输出的信号频率
`timescale 1ns / 1ns

module DDS_module_tb ();

    reg         clk;
    reg         reset_n;
    reg  [31:0] fword;
    reg  [11:0] pword;
    wire [13:0] data;

    DDS_module DDS_module_inst (
        .clk    (clk),
        .reset_n(reset_n),
        .fword  (fword),
        .pword  (pword),
        .data   (data)
    );

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        fword   = 65536;  //  2^16
        pword   = 0;
        #201;
        reset_n = 1;
        #20000000;
        fword = 65536 * 1024;  // 2^26
        #20000000;
        fword = 65536 * 32;  // 2^21
        $stop;

    end


endmodule
