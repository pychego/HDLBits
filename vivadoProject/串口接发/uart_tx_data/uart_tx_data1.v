// 串口向电脑发送5字节的数据 data40
// 使用简单的分支语句
module uart_tx_data1 (
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

    reg [2:0] state;  // 对状态分情况讨论
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            trans_done <= 0;
        end else if (state == 0) begin  // 复位等待发送状态
            trans_done <= 0;
            if (trans_go) begin
                data <= data40[7:0];
                send_go <= 1'b1;
                state <= 1;
            end else begin
                send_go <= 1'b0;
                state   <= 0;  // 保持原状态的情况可以不写
            end
        end else if (state == 1) begin  //  state1 是在发送第一组data
            if (tx_done) begin
                data <= data40[15:8];
                send_go <= 1'b1;
                state <= 2;
            end else begin
                send_go <= 1'b0;
                state   <= 1;
            end
        end else if (state == 2) begin
            if (tx_done) begin
                data <= data40[23:16];
                send_go <= 1'b1;
                state <= 3;
            end else begin
                send_go <= 1'b0;
                state   <= 2;
            end
        end else if (state == 3) begin
            if (tx_done) begin
                data <= data40[31:24];
                send_go <= 1'b1;
                state <= 4;
            end else begin
                send_go <= 1'b0;
                state   <= 3;
            end
        end else if (state == 4) begin
            if (tx_done) begin
                data <= data40[39:32];
                send_go <= 1'b1;
                state <= 5;
            end else begin
                send_go <= 1'b0;
                state   <= 4;
            end
        end else if (state == 5) begin  // state=5是在发送第5组data
            if (tx_done) begin
                send_go <= 1'b0;
                trans_done <= 1;
                state <= 0;  // 发送结束回到初始状态
            end else begin
                send_go <= 1'b0;
                state   <= 5;
            end
        end
    end

endmodule
