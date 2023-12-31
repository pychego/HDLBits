// 减少state至2或3,适用于发送n字节的数据,发送状态用计数器实现
// 设置计数时间,每计一个数发送1byte数据

// 不输入待发送数据 第一个字节发送1，第二个字节发送2

/* 根据时序图可知uart开始发送落后于trans_go上升沿5个clk，
    trans_go -> send_go -> send_en -> count计数为1 -> bps_count=1 ->uart_tx=0 共5个clock

*/
module uart_tx_data3 (
    input            clock,
    input            reset_n,
    input      [7:0] n_byte,     // 发送n字节数据
    input            trans_go,
    output           uart_tx,
    output reg       trans_done  // ci
);
    // 时序控制信号 send_go send_count tx_done 
    // 组合逻辑信号
    reg        send_go;
    reg  [7:0] send_count;  // 记录已经发送几个byte数据
    wire       tx_done;
    reg  [7:0] data;  // 每轮要发送的8bit

    uart_byte uart_byte_inst (
        .clock   (clock),
        .reset_n (reset_n),
        .send_go (send_go),
        .band_set(4),        // 115200
        .data    (data),     // 以上为输入
        .uart_tx (uart_tx),
        .tx_done (tx_done)
    );

    // data值为轮次 send_count
    reg [1:0] state;
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            trans_done <= 0;
            send_count <= 0;
        end else begin
            case (state)
                0: begin  // 等待发送数据
                    trans_done <= 0;
                    data <= send_count;
                    if (trans_go) begin
                        send_go <= 1'b1;
                        send_count <= 1'b1;
                        data <= 1'b1;
                        state <= 1;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 0;
                    end
                end
                1: begin  // 正在发送数据
                    if (send_count == n_byte && tx_done == 1) begin  // 数据发送结束
                        send_go <= 1'b0;
                        trans_done <= 1'b1;
                        send_count <= 0;
                        state <= 0;
                    end else if (tx_done) begin  // 当前byte发送完成接着发送下一个
                        send_count <= send_count + 1;
                        data <= send_count + 1;
                        send_go <= 1'b1;
                    end else begin  // 当前byte发送未完成, 继续发送
                        send_go <= 1'b0;
                    end
                end
                default: begin
                    send_go <= 1'b0;
                    state   <= 0;
                end
            endcase
        end
    end


endmodule
