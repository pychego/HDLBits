`timescale 1ns / 1ns

module digit_led_test_tb ();

    reg        clk;
    reg        reset_n;
    wire [7:0] sel;
    wire [7:0] seg;

    digit_led_test digit_led_test_inst (
        .clk    (clk),
        .reset_n(reset_n),
        .sel    (sel),
        .seg    (seg)
    );

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        #201 reset_n = 1;

        #20_000_000;
        $stop;
    end

endmodule
