module SixAxis_Process_Control (
    input clk,
    input rst_n,
    input start,

    output reg Solution_ap_start,
    output reg PID_ap_start,
    output reg Compensate_ap_start
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // One round of count_10kHz is 1ms, which is a control cycle
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Solution_ap_start <= 1'b0;
        end else if (cnt==1000 && count_10kHz==3)  // 在count_10kHz==3的开始一小会才触发该条件，并保持一个clk周期
            Solution_ap_start <= 1'b1;
        else Solution_ap_start <= 1'b0;
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Compensate_ap_start <= 1'b0;
        end else if (cnt==1000 && count_10kHz==6)  // 在count_10kHz==6的刚开始才触发该条件，并保持一个clk周期
            Compensate_ap_start <= 1'b1;
        else Compensate_ap_start <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PID_ap_start <= 1'b0;
        end else if (cnt==1000 && count_10kHz==7)  // 在count_10kHz==7的刚开始才触发该条件，并保持一个clk周期
            PID_ap_start <= 1'b1;
        else PID_ap_start <= 1'b0;
    end



    /*
2024.6.20
    目前仅添加了PID_ap_start信号，一个控制周期给一个上升沿，保证PID每周期运行一次
2024.7.11
    在count_10kHz==3的开始一小会才触发Solution_ap_start信号，并保持一个clk周期 正反解的开始信号都是这个
2024.8.23
    目前准备在已有的正反解模块后面加入解耦的补偿模块,该模块应该耗时不多 ,在6该开始一小段时间开始进行补偿腿长计算
    8.24
     添加了Compensate_ap_start信号，当正反解结束之后进行补偿雅可比矩阵的计算
     修改了PID_ap_start的触发条件，现在是在count_10kHz==7的刚开始才触发该条件，并保持一个clk周期

*/


endmodule
