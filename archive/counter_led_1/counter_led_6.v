// 设置使能信号en，en=1时，计数器开始计数，en=0时，计数器停止计数. en周期为10ms
// led灯按照指定的亮灭模式，亮灭模式未知，由用户随机指定，以0.25s为一个变化周期，8个状态一个循环

module counter_led_6 (
    input clock,
    input reset_n,
    input [7:0]sw,
    output reg led // always块内左边要是reg
);
    reg [31:0]count;  // 直接用32位即可
    reg [2:0]led_count;

    reg en; // 使能信号
    reg [31:0]  en_count;
    // en_count计数 范围0~50_0000-1 时间10ms
    //  reset_n是异步低电平复位信号，因此下降沿会触发，
    // 而且在低电平时也触发(因此进入模块之后才有了if(!reset_n)的判断)
    // 电平触发的实现在always内部使用判断条件
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) begin
            en_count <= 0;
        end
        else begin  // clock上升沿
            if (en_count == 50_0000 - 1) begin
                en_count <= 0;
            end
            else en_count <= en_count + 1;
        end
    end

    // // 规定en的使能时间为5ms， 这个5ms正好是led_count的一个周期
    // always @(posedge clock or negedge reset_n) begin
    //     if(!reset_n) begin
    //         en <= 0;
    //     end
    //     else begin
    //         if (en_count <= 25_0000 - 1) begin
    //             en <= 1;
    //         end
    //         else en <= 0;
    //     end
    // end

    // 规定en的使能时间是整个led_count的一个周期
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) begin
            en <= 0;
        end          // 该模块需要led_count的周期小于10ms
        else begin   // en周期开始为1，持续了整个led_count周期，正好到led_count=7状态结束时en=0
            if(en_count == 0) begin
                en <= 1;   // 每10ms初始化一次，之后就一直保持了
            end
            else if (led_count == 7 && count == 31250 -1) begin
                en <= 0;
            end
        end
    end


    // 时钟计数 
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) begin
            count <= 0;
        end
        else  // clock上升沿时，en=1时才计数
            if (en) begin
                if (count == 31250 - 1) begin  // 5/8ms需要31250个时钟周期
                    count <= 0;
                end
                else begin
                    count <= count + 1;
                end
            end
    end

    // led_count计数
    always @(posedge clock or negedge reset_n) begin
        if(!reset_n) 
            led_count <= 0;
        else 
            if (en) begin
                if (count == 31250 - 1) begin
                    led_count <= led_count + 1; // 记满自动回000
                end
            end
    end

    // 以always块描述的信号赋值，被赋值对象必须定义为reg类型
    always@(*) begin   // @ 关注 * 通配符
        case (led_count)
            3'd0: led = sw[0];
            3'd1: led = sw[1];
            3'd2: led = sw[2];
            3'd3: led = sw[3];
            3'd4: led = sw[4];
            3'd5: led = sw[5];
            3'd6: led = sw[6];
            3'd7: led = sw[7]; 
        endcase
    end

endmodule