`timescale 1ns/1ns
// 测试4个不同频率闪烁的灯

module led_run4_tb ();


    // 定义测试信号
    reg clock;
    reg reset_n;
    wire [3:0] led;

    led_run4 led_run4_0(
        .clock(clock),
        .reset_n(reset_n),
        .led(led)
    );
    
    // 给信号激励
    initial begin
        clock = 0;
        reset_n = 1;
        #1000 reset_n = 0;
        #1000 reset_n = 1;
    end

    always #10 clock = ~clock;

endmodule