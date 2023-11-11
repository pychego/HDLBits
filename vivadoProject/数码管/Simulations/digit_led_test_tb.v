`timescale 1ns / 1ns

module digit_led_test_tb ();

    reg  clk;
    reg  reset_n;
    reg  uart_rx;
    wire seg7_sclk;
    wire seg7_rclk;
    wire seg7_dio;
    wire uart_tx;

    digit_led_test digit_led_test_inst (
        .clk      (clk),
        .reset_n  (reset_n),
        .uart_rx  (uart_rx),
        .seg7_sclk(seg7_sclk),  // output
        .seg7_rclk(seg7_rclk),
        .seg7_dio (seg7_dio),
        .uart_tx  (uart_tx)
    );

    // 信号激励
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        uart_rx = 1;
        # 201;

        reset_n = 1;
        # 10_000_000;
        $stop;

    end



endmodule
