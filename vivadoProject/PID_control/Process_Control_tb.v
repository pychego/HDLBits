`timescale 1ns / 1ps

module Process_Control_tb ();

    reg  clk;
    reg  rst_n;
    reg  start;

    wire PID_ap_start;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        #15 rst_n = 1'b1;
        #100 start = 1'b1;
    end

    // 10MHz
    always #5 clk = ~clk;

    Process_Control my_Processe_Control_0 (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start),
        .PID_ap_start(PID_ap_start)
    );


    initial begin
        #3000000 $finish;
    end


endmodule
