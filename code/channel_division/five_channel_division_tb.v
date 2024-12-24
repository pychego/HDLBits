`include "five_channel_division.v"


`timescale 1ns / 1ps


module five_channel_division_tb ();

    reg  clk;
    reg  rst_n;
    wire clk_out;

    five_channel_division u_five (
        .clk  (clk),
        .rst_n(rst_n),
        .clk_out(clk_out)
    );


    initial begin
        $dumpfile("five_channel_division_tb.vcd");  // 生成仿真波形
        $dumpvars;
        clk   = 0;
        rst_n = 0;
        #13 rst_n = 1;
    end

    // 在vscode中仿真要加这一句, 不然就会一直仿真下去, 卡死
    initial begin
        #3000 $finish;
    end


    always #5 clk <= ~clk;


endmodule
