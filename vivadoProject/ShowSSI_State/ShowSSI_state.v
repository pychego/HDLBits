/*
* 控制逻辑
* 根据六个ssi信号输入范围, 判断是否所有ssi都是valid的
* 如果valid, led就按照一定频率闪烁, 否则led关闭
*/


module ShowSSI_state (
    input             clk,           // 系统时钟
    input             rst_n,         // 低电平复位信号
    input      [31:0] data0,
    input      [31:0] data1,
    input      [31:0] data2,
    input      [31:0] data3,
    input      [31:0] data4,
    input      [31:0] data5,
    output reg        SSI_No_Valid,  // 与GPIO接口相或 送入PID的zero信号
    output reg        led            // LED 输出
);

    // 系统时钟频率为 100MHz
    // 测试
    // parameter COUNT_MAX = 10;  // 0.25s 对应的时钟周期数 (100MHz * 0.25s)
    parameter COUNT_MAX = 25_000_000;  // 0.25s 对应的时钟周期数 (100MHz * 0.25s)
    parameter MAX_SSI = 60_0000;  // 超过这个大小的ssi数据无效

    reg [31:0] counter;  // 31 位计数器，足够计数到 COUNT_MAX

    // 生成valid信号
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            SSI_No_Valid <= 1'b1;
        end else if(data0 >=MAX_SSI || data1 >=MAX_SSI || data2 >=MAX_SSI &&
                    data3 >=MAX_SSI || data4 >=MAX_SSI || data5 >=MAX_SSI) begin
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
