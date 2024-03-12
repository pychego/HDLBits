// 保持fword频率控制字不变, 更改pword相位控制字,对比波形观察pword的作用
`timescale 1ns / 1ns

module DDS_module_tb2 ();

    reg clk;
    reg reset_n;
    reg [31:0] fword_a, fword_b;
    reg [11:0] pword_a, pword_b;
    wire [13:0] data_a, data_b;

    DDS_module DDS_module_inst_a (
        .clk    (clk),
        .reset_n(reset_n),
        .fword  (fword_a),
        .pword  (pword_b),
        .data   (data_a)
    );

    DDS_module DDS_module_inst_b (
        .clk    (clk),
        .reset_n(reset_n),
        .fword  (fword_b),
        .pword  (pword_b),
        .data   (data_b)
    );

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        fword_a = 65536;  //  2^16
        fword_b = 65536;  //  2^16
        pword_a = 0;
        pword_b = 1024;  // 4096相位差360度, 1024相位差90度

        #201;
        reset_n = 1;
        #20_000_000;  // 20ms


        fword_a = 65536 * 1024;  // 2^26
        fword_b = 65536 * 1024;  // 2^26
        pword_a = 0;
        pword_b = 2048;
        #20000000;
        $stop;

    end


endmodule
