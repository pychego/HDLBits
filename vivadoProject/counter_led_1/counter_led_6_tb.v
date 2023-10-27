// 测试counter_led_3模块
`timescale 1ns/1ns

module counter_led_6_tb ();

    // 定义信号
    reg clock, reset_n;
    reg [7:0]sw;
    wire led;

    counter_led_6 counter_led_6_inst (
        .clock(clock),
        .reset_n(reset_n),
        .sw(sw),
        .led(led)
    );

    // 信号激励
    initial begin
        clock = 0;
        sw = 8'b10111010;
        reset_n = 1;
        # 100 reset_n = 0;
        # 1000 reset_n = 1;
    end
    always #10 clock = ~clock;
    
endmodule