/*
    计时，sec min hour 显示，传送给digit_led模块
    output [31:0] disp_data = 00 hour min sec
*/

module counter_time (
    input         clk,
    input         reset_n,
    input  [31:0] new_time,
    input         agree_done,
    output [31:0] disp_data
);

    /*
        1. 怎么通过串口将接收到的数据送到sec，min，hour？
           额外定义接收的数据new_time和协议传输完成脉冲信号agree_done 到达时对sec，min，hour进行赋值
    */
    reg [ 7:0] sec;
    reg [ 7:0] min;
    reg [ 7:0] hour;
    reg [31:0] count;  // 最低计数器
    // parameter MCNT = 50_00;          // 0.1ms  测试用
    parameter MCNT = 50_000_000;  // 1s  上板子

    /*
        问题：错误写法 多重驱动！！ 不同的always块中不能对同一个信号赋值
                多重驱动导致顶层综合时综合不出来该子模块
        解决：将对每个信号的赋值打散 分到自己的always块中
        always @(posedge clk) begin     
            if (agree_done) begin
                sec  <= new_time[7:0] / 16 * 10 + new_time[7:0] % 16;   // 将0x12转换为十进制12
                min  <= new_time[15:8] / 16 * 10 + new_time[15:8] % 16;
                hour <= new_time[23:16] / 16 * 10 + new_time[23:16] % 16;
            end
        end
    */

    // count一个周期 1s
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
        end else if (MCNT - 1 <= count) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    // 操作sec
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sec <= 0;
        end else if (agree_done) begin
            sec <= new_time[7:0] / 16 * 10 + new_time[7:0] % 16;
        end else if (MCNT - 1 <= count) begin
            if (sec >= 59) sec <= 0;
            else sec <= sec + 1;
        end

    end

    // 操作min
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            min <= 0;
        end else if (agree_done) begin
            min <= new_time[15:8] / 16 * 10 + new_time[15:8] % 16;
        end else if (MCNT - 1 <= count) begin
            if (sec >= 59) begin  // 此刻是59秒结束的时刻 满足以上条件时， min要变化了
                if (min >= 59) min <= 0;
                else min <= min + 1;
            end
        end
    end

    // 操作hour
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            hour <= 0;
        end else if (agree_done) begin
            hour <= new_time[23:16] / 16 * 10 + new_time[23:16] % 16;
        end else if (MCNT - 1 <= count) begin
            if (sec >= 59) begin      // 此刻是59秒结束的时刻
                if (min >= 59) begin  // 此刻是59分结束的时刻
                    if (hour >= 23) hour <= 0;
                    else hour <= hour + 1;
                end
            end
        end
    end

    assign disp_data[31:24] = 0;
    assign disp_data[23:20] = hour / 10;
    assign disp_data[19:16] = hour % 10;
    assign disp_data[15:12] = min / 10;
    assign disp_data[11:8]  = min % 10;
    assign disp_data[7:4]   = sec / 10;
    assign disp_data[3:0]   = sec % 10;

    // assign disp_data[23:16] = {4'b(hour / 10), 4'b(hour % 10)};  // 报错
    // assign disp_data[15: 8] = {4'b(min  / 10), 4'b(min  % 10)};
    // assign disp_data[ 7: 0] = {4'b(sec  / 10), 4'b(sec  % 10)};

endmodule
