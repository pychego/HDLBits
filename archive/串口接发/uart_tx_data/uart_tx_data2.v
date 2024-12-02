// 功能同uart_tx_data1相同，使用状态机完成，发送一个byte用一个状态
// 串口向电脑发送5字节的数据
module uart_tx_data2 (
    input             clock,
    input             reset_n,
    input      [39:0] data40,     // 40bit data
    input             trans_go,   // 类似于send_go, 管40bit
    output            uart_tx,
    output reg        trans_done  // 40bit传输结束
);

    /*  时序控制信号
    send_go uart_tx tx_done data state
    组合逻辑信号
    */
    reg        send_go;
    reg  [7:0] data;  // 每轮要发送的8bit
    wire       tx_done;

    uart_byte uart_byte_inst (
        .clock   (clock),
        .reset_n (reset_n),
        .send_go (send_go),
        .band_set(4),        // 115200
        .data    (data),     // 以上为输入
        .uart_tx (uart_tx),
        .tx_done (tx_done)
    );

    reg [2:0] state;  // 状态机
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            trans_done <= 0;
        end else begin
            case (state)  // 状态机用case语句表示
                0: begin
                    trans_done <= 0;
                    if (trans_go) begin
                        data <= data40[7:0];
                        send_go <= 1'b1;
                        state <= 1;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 0;  // 保持原状态的情况可以不写
                    end
                end
                1: begin
                    if (tx_done) begin
                        data <= data40[15:8];
                        send_go <= 1'b1;
                        state <= 2;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 1;
                    end
                end
                2: begin
                    if (tx_done) begin
                        data <= data40[23:16];
                        send_go <= 1'b1;
                        state <= 3;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 2;
                    end
                end
                3: begin
                    if (tx_done) begin
                        data <= data40[31:24];
                        send_go <= 1'b1;
                        state <= 4;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 3;
                    end
                end
                4: begin
                    if (tx_done) begin
                        data <= data40[39:32];
                        send_go <= 1'b1;
                        state <= 5;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 4;
                    end
                end
                5: begin
                    if (tx_done) begin
                        send_go <= 1'b0;
                        trans_done <= 1;
                        state <= 0;  // 发送结束回到初始状态
                    end else begin
                        send_go <= 1'b0;
                        state   <= 5;
                    end
                end
                default: begin
                    state <= 0;
                    trans_done <= 0;
                end
            endcase
        end
    end

endmodule
