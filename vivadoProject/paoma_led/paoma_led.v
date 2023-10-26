// 设计8个led等以每个0.5s的速率循环闪烁。 跑马灯=计数器+译码器
// 7010时钟频率20ns，设置0.5s需要25M个时钟周期。
module paoma_led (
    input clock,
    input reset_n,
    output reg [7:0] led
);
    wire reset_n;
    reg [24:0] count; // 25位寄存器，用于增大系统周期
    reg [2:0] led_count; // 3位寄存器，用于控制led灯的闪烁频率
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
            led_count <= 0;
        end
        else if (count == 2500_0000 - 1) begin
            count <= 0;
            // 控制每0.5s led_count加1
            if (led_count == 7)
                led_count <= 0;
            else 
                led_count <= led_count + 1;
        end
        else begin
            count <= count + 1;
        end
    end

    // 3_8译码器
    always @(*) begin
        case (led_count)
            0: led = 8'b0000_0001;
            1: led = 8'b0000_0010;
            2: led = 8'b0000_0100;
            3: led = 8'b0000_1000;
            4: led = 8'b0001_0000;
            5: led = 8'b0010_0000;
            6: led = 8'b0100_0000;
            7: led = 8'b1000_0000;
        endcase
    end
    
endmodule