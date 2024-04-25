`timescale 1ns / 1ps

module system_wrapper_tb ();
    reg         ap_clk;
    wire        ap_done;
    wire        ap_idle;
    wire        ap_ready;
    reg         rst_n;
    reg         ap_start;
    wire [ 2:0] pose2_address0;
    wire [31:0] pose2_d0;
    wire        pose2_we0;

    initial begin
        ap_clk = 1'b0;
        rst_n = 1'b0;
        ap_start = 1'b0;
        #15 rst_n = 1'b1;
        #20 ap_start = 1'b1;
    end

    always #5 ap_clk = ~ap_clk;




    system system_i (
        .ap_clk        (ap_clk),
        .ap_done       (ap_done),
        .ap_idle       (ap_idle),
        .ap_ready      (ap_ready),
        .ap_rst        (~rst_n),
        .ap_start      (ap_start),
        .pose2_address0(pose2_address0),
        .pose2_d0      (pose2_d0),
        .pose2_we0     (pose2_we0)
    );
endmodule
