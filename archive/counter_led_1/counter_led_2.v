// 亮0.25s， 灭0.5s，亮0.75s，灭1s

// led 亮0.25, 灭0.75

module counter_led_2 (
    input clock,
    input reset_n,
    output reg led
);
    parameter MCNT = 125_00000;  // 0.25s
    reg [31:0]count;  // 直接用32位即可

    // 时钟计数
    always @(posedge clock or negedge reset_n) begin
        if(! reset_n) begin
            count <= 0;
        end
        else begin   // clock上升沿
            if(count == MCNT*10 - 1) begin
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end 

    // led 亮0.25, 灭0.75
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            led <= 1'b1;
        end
        else begin  // count 0~MCNT/4 - 1
            if (count ==  MCNT*1 - 1) 
                led <= 1'b0;
            else if (count == MCNT*3 - 1)
                led <= 1'b1;
            else if (count == MCNT*6 - 1)
                led <= 1'b0;
            else if (count == MCNT*10 - 1)  // 关键是这个时候回初始状态
                led <= 1'b1;
        end
    end

endmodule