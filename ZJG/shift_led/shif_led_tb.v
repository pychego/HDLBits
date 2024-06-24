`timescale 1ns / 1ps

module shift_led_tb ();


    reg        i_clk;
    reg        i_rst_n;
    wire [3:0] led;

    initial begin
        i_clk   = 1'b0;
        i_rst_n = 1'b0;
        #15 i_rst_n = 1'b1;
    end

    // 50Mhz
    always #10 i_clk = ~i_clk;

    initial begin
        #300000 $finish;
    end


    shift_led_top u_shift_led_top (
        .i_clk  (i_clk),
        .i_rst_n(i_rst_n),
        .led    (led)
    );


endmodule
