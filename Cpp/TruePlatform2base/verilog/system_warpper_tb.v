`timescale 1ns / 1ps

module system_wrapper_tb ();
    reg         ap_clk;
    reg         rst_n;
    reg         ap_start;
    wire        ap_done;
    wire [ 2:0] pose3_address0;
    wire [31:0] pose3_d0;
    wire        pose3_we0;

    initial begin
        ap_clk = 1'b0;
        rst_n = 1'b0;
        ap_start = 1'b0;
        #15 rst_n = 1'b1;
        #20 ap_start = 1'b1;
    end

    always #5 ap_clk = ~ap_clk;

    system_wrapper system_i (
        .ap_clk        (ap_clk),
        .ap_done       (ap_done),
        .ap_rst        (ap_rst),
        .ap_start      (ap_start),
        .pose3_address0(pose3_address0),
        .pose3_d0      (pose3_d0),
        .pose3_we0     (pose3_we0)
    );
endmodule
