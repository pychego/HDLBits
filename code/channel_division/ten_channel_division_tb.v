`include "ten_channel_division.v"


`timescale 1ns / 1ps


module two_channel_division_tb ();

    reg  clk;
    reg  rst_n;
    wire clk10;

    ten_channel_division u_two (
        .clk  (clk),
        .rst_n(rst_n),
        .clk10(clk10)
    );


    initial begin
        $dumpfile("ten_channel_division_tb.vcd");  // 生成仿真波形
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
