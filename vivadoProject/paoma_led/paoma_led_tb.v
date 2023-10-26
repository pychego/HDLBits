`timescale 1ns/1ns

module paoma_led_tb ();

    // 定义信号 模块输入为reg 模块输出为wire
    reg clock, reset_n;
    wire [7:0] led;

    // 实例化模型
    paoma_led #(.MCNT(25_000))paoma_led(
        .clock(clock),
        .reset_n(reset_n),
        .led(led)
    );

    // 信号激励
    initial begin
        clock = 0;
    end
    always #10 clock = ~clock; // 20ns周期

    initial begin
        reset_n = 0;  
        #4100000000 reset_n = 1;  //4.1s后复位
    end
    
endmodule