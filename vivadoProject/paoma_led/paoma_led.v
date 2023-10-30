
// 设计8个led等以每个0.5s的速率循环闪烁。 跑马灯=计数器+译码器
// 7010时钟频率20ns，设置0.5s需要25M个时钟周期。
module paoma_led (
    input clock,
    input wire reset_n,
    output [7:0] led  // 调用的decoder_3_8已经定义了led为reg，顶层模块不定义
);
    parameter MCNT = 2500_0000; // MCNT = 周期ns / 20ns
    reg [24:0] count; // 25位寄存器，用于增大系统周期
    reg [2:0] led_count; // 3位寄存器，用于控制led灯的闪烁频率

    // 计数，count从0~MCNT-1，然后重新置零
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end
        else if (count == MCNT - 1) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    // 对count和led_count进行分开赋值, 有利于综合
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            led_count <= 0;
        end
        else if (count == MCNT - 1) begin
            // 控制每0.5s led_count加1
            led_count <= led_count + 1;
        end
    end

    // 3_8译码器,调用模块
    decoder_3_8 decoder_3_8(
        .a(led_count[2]),
        .b(led_count[1]),
        .c(led_count[0]),
        .out(led)
    );
    
endmodule