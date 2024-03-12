// 测试counter_led_3模块
`timescale 1ns/1ns

module counter_led_3_tb ();

    // 定义信号
    reg clock, reset_n;
    reg [7:0]sw;
    wire led;

    counter_led_3 #(
        .MCNT(125_00)
    ) counter_led_3_inst (
        .clock(clock),
        .reset_n(reset_n),
        .sw(sw),
        .led(led)
    );

    // 信号激励
    initial begin
        clock = 0;
        sw = 8'b11000111;
        reset_n = 1;
        #12300 reset_n = 0;
        #12300 reset_n = 1;
    end
    always #10 clock = ~clock;
    
endmodule