// led灯按照指定的亮灭模式，亮灭模式未知，由用户随机指定 每个状态持续时间由TIME确定，8个状态一个循环
module counter_led_3 (
    input            clock,
    input            reset_n,
    input      [7:0] ctrl,
    input     [31:0] state_time,
    output reg       led       // always块内左边要是reg
);
    // parameter MCNT = 125_00000;  // 0.25s
    reg [31:0] count;  // 直接用32位即可
    reg [ 2:0] led_count;

    // 时钟计数
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else begin
            if (count == state_time - 1) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    // led_count计数
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) led_count <= 0;
        else begin
            if (count == state_time - 1) begin
                led_count <= led_count + 1;  // 记满自动回000
            end
        end
    end

    // 以always块描述的信号赋值，被赋值对象必须定义为reg类型
    always @(*) begin  // @ 关注 * 通配符
        case (led_count)
            3'd0: led = ctrl[0];
            3'd1: led = ctrl[1];
            3'd2: led = ctrl[2];
            3'd3: led = ctrl[3];
            3'd4: led = ctrl[4];
            3'd5: led = ctrl[5];
            3'd6: led = ctrl[6];
            3'd7: led = ctrl[7];
        endcase
    end

endmodule
