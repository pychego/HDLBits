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
    /* 判断条件写成state_time -1 <= count 比count == state_time -1好很多
    前者可以避免state_time为0,左边突然很大的情况，而后者在state_time为0时需要很长时间才能判断为真
    后者每次复位，判断条件为count == ffffffff, 你先复位再发送数据，当接收到state_time时，count已经超过state_time了
    因此第一轮count一直加到0xffffffff(需要85.89s)， 以后state_time不再为0就正常了

    仿真时没有这个问题，是因为当state_time被赋值的时候，count计数还没到达state_time-1
    */
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            count <= #1  0;
        end else begin
            if (state_time -1 <= count) begin
                count <= #1  0;
            end else begin
                count <= #1  count + 1;
            end
        end
    end

    // led_count计数
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) led_count <= #1  0;
        else begin
            if (state_time -1 <= count) begin
                led_count <= #1  led_count + 1;  // 记满自动回000
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
