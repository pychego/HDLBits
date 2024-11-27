/*
* 控制逻辑
* 根据六个ssi信号输入范围, 判断是否所有ssi都是valid的
* 如果valid, led就按照一定频率闪烁, 否则led关闭

2024.11.27
    1. 之前的ssi2 >=MAX_SSI && ssi3 >=MAX_SSI 是写错了, 现在修改过来了,
    所有的ssi数据之间是想或的
    2. 将MAX_SSI作为了自定义数据的输入接口, 提高系统的灵活性

*/


module ShowSSI_state (
    input             clk,           // 系统时钟
    input             rst_n,         // 低电平复位信号
    input      [31:0] MAX_SSI,
    input      [31:0] ssi0,
    input      [31:0] ssi1,
    input      [31:0] ssi2,
    input      [31:0] ssi3,
    input      [31:0] ssi4,
    input      [31:0] ssi5,
    output reg        SSI_No_Valid,  // 与GPIO接口相或 送入PID的zero信号
    output reg        led            // LED 输出
);

    // 系统时钟频率为 100MHz
    // 测试
    // parameter COUNT_MAX = 10;  // 0.25s 对应的时钟周期数 (100MHz * 0.25s)
    parameter COUNT_MAX = 25_000_000;  // 0.25s 对应的时钟周期数 (100MHz * 0.25s)
    // parameter MAX_SSI = 60_0000;  // 超过这个大小的ssi数据无效

    reg [31:0] counter;  // 31 位计数器，足够计数到 COUNT_MAX

    // 生成valid信号
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            SSI_No_Valid <= 1'b1;
        end else if(ssi0 >=MAX_SSI || ssi1 >=MAX_SSI || ssi2 >=MAX_SSI ||
                    ssi3 >=MAX_SSI || ssi4 >=MAX_SSI || ssi5 >=MAX_SSI) begin
            SSI_No_Valid <= 1'b1;
        end else begin
            SSI_No_Valid <= 1'b0;
        end
    end

    // 闪烁 LED
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 25'd0;
            led <= 1'b0;
        end else if (SSI_No_Valid) begin
            if (counter == COUNT_MAX - 1) begin
                counter <= 25'd0;
                led <= ~led;  // 翻转 LED 状态
            end else begin
                counter <= counter + 1'b1;
            end
        end else begin
            counter <= 25'd0;
            led <= 1'b0;  // 当 valid 为 0 时，LED 保持关闭
        end
    end

endmodule
