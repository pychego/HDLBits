`timescale 1ns / 1ps

module DirectSolution_tb ();

    reg         clk;
    reg         rst_n;
    wire [31:0] lengths_q0;
    wire        lengths_ce0;
    wire        pose_ce0;
    wire        pose_we0;
    wire        ap_start;
    wire        ap_done;
    wire        ap_idle;
    wire        ap_ready;
    wire [ 2:0] lengths_address0;
    wire [ 2:0] pose_address0;
    wire [31:0] pose_d0;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #15 rst_n = 1'b1;
    end

    always #5 clk = ~clk;

    initial begin
        #1000000 $finish;
    end

    DirectSolution_top u_DirectSolution_top (
        .clk             (clk),
        .rst_n           (rst_n),
        .lengths_q0      (lengths_q0),
        .lengths_ce0     (lengths_ce0),
        .pose_ce0        (pose_ce0),
        .pose_we0        (pose_we0),
        .ap_start        (ap_start),
        .ap_done         (ap_done),
        .ap_idle         (ap_idle),
        .ap_ready        (ap_ready),
        .lengths_address0(lengths_address0),
        .pose_address0   (pose_address0),
        .pose_d0         (pose_d0)
    );


endmodule
