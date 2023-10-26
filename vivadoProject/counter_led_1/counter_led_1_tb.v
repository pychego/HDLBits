`timescale 1ns/1ns

module counter_led_2_tb ();

    reg clock, reset_n;
    wire led;

    counter_led_2 #(.MCNT(50_000))counter_led_1(
        .clock(clock),
        .reset_n(reset_n),
        .led(led)
    );

    initial begin
        clock = 0;
        reset_n = 1;
        # 100 reset_n = 0;
        # 100 reset_n = 1;
    end
    always #10 clock = ~clock; // 20ns周期
    
endmodule