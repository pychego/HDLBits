`timescale 1ns / 1ps
`include "frame_header_detection.v"


module frame_header_detection_tb ();

    reg        clk;
    reg        rst_n;
    reg        frame_head;
    reg  [7:0] din;

    wire       detect;

    frame_header_detection u_frame (
        .clk       (clk),
        .rst_n     (rst_n),
        .frame_head(frame_head),
        .din       (din),
        .detect    (detect)
    );

    always #10 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
        frame_head = 0;

        #23 rst_n = 1;

        #20 frame_head = 1;
        din = 8'h23;
        #20 frame_head = 0;
        din = 8'h00;


        #60 frame_head = 1;
        din = 8'h23;
        #20 frame_head = 0;
        din = 8'h00;

        #60 frame_head = 1;
        din = 8'h23;
        #20 frame_head = 0;
        din = 8'h00;

    end

    initial begin
        $dumpfile("frame_header_detection_tb.vcd");  // 生成仿真波形
        $dumpvars;
        #3000 $finish;
    end




endmodule
