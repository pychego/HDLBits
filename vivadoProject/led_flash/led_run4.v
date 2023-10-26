// 实例化4个led灯

module led_run4 (
    input clock,
    input reset_n,
    output [3:0] led   // 底层模块定义变量类型，这里不再定义
);
    // 需要修改输入输出信号的类型吗?
    // MCNT = 需要延时的ns数 / 20ns
    led_flash #(.MCNT(2500_0000*1)) led_flash0(
        .clock(clock),
        .reset_n(reset_n),
        .led(led[0])
    );

    led_flash #(.MCNT(2500_0000*2)) led_flash1(
        .clock(clock),
        .reset_n(reset_n),
        .led(led[1])
    );

    led_flash #(.MCNT(2500_0000*3)) led_flash2(
        .clock(clock),
        .reset_n(reset_n),
        .led(led[2])
    );

    led_flash #(.MCNT(2500_0000*4)) led_flash3(
        .clock(clock),
        .reset_n(reset_n),
        .led(led[3])
    );
    
endmodule