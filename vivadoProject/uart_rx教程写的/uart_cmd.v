// 连接uart_byte_rx和counter_led_3
// 考虑实际的延迟，可以将 <= 改为 <= #1
module uart_cmd (
    input             clock,
    input             reset_n,
    input      [ 7:0] data,       // 串口接收到的数据
    input             rx_done,
    output reg [ 7:0] ctrl,
    output reg [31:0] state_time
);

    reg flag;  // 用于标记是否接收到了协议
    reg  [7:0] memory[7:0];

    // 数据移位更新
    // 或者此处使用clk上升沿，将rx_done作为条件判断
    always @(posedge rx_done or negedge reset_n) begin
        if (!reset_n) begin
            flag <= #1  1'b0;       // 移位寄存器没必要复位
            memory[0] <= #1  8'h00;
            memory[1] <= #1  8'h00;
            memory[2] <= #1  8'h00;
            memory[3] <= #1  8'h00;
            memory[4] <= #1  8'h00;
            memory[5] <= #1  8'h00;
            memory[6] <= #1  8'h00;
            memory[7] <= #1  8'h00;
        end else begin  // 移位寄存，memory[0]是最新的数据
            memory[0] <= #1  memory[1];
            memory[1] <= #1  memory[2];
            memory[2] <= #1  memory[3];
            memory[3] <= #1  memory[4];
            memory[4] <= #1  memory[5];
            memory[5] <= #1  memory[6];
            memory[6] <= #1  memory[7];
            memory[7] <= #1  data;
        end
    end

    // 必须先移位再判断，如果移位和判断在同一时刻，判断的是之前的数据
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            ctrl <= #1  8'h00;
            state_time <= #1  32'h00000000;
        end else if (rx_done) begin
            if (memory[0] == 8'h55 && memory[1] == 8'ha5 && memory[7] == 8'hf0) begin
                ctrl <= #1  memory[6];
                state_time <= #1  {memory[5], memory[4], memory[3], memory[2]};
                flag <= #1  1'b1;
            end
        end else flag <= #1  1'b0;
    end

    /*
    // 解决先移位后对比的另一个办法 使用寄存器让r_rx_done比rx_done晚一个节拍
    reg r_rx_done;
    always @(posedge clock) begin
        r_rx_done <= rx_done;
    end
    // 使用rx_done电平信号进行移位
    // r_rx_done电平信号进行协议比对
    */
endmodule
