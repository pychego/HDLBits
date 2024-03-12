/*
    该模块串口向电脑发送4字节的数据 data32 子模块中设置bps 115200
    uart_tx_data32 input [31:0] data32 待发送的4byte 先发送高位
                   input trans_go       data32开始发送的使能信号 （脉冲信号）
                   output uart_tx       串口输出
                   output trans_done    data32传输结束信号

    作为底层模块不直接参与顶层综合设计

*/
module uart_tx_data32 (
    input             clk,
    input             reset_n,
    input      [31:0] data32,    
    input             trans_go,   
    output            uart_tx,
    output reg        trans_done  
);

    /*  时序控制信号
    send_go uart_tx tx_done data state
    组合逻辑信号
    */

    reg        send_go;
    reg  [7:0] data;  // 每轮要发送的8bit
    wire       tx_done;

    uart_byte uart_byte_inst (
        .clk   (clk),
        .reset_n (reset_n),
        .send_go (send_go),
        .band_set(4),           // 115200
        .data    (data),     
        .uart_tx (uart_tx),     // output
        .tx_done (tx_done)
    );

    reg [2:0] state;  // 状态机
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            trans_done <= 0;
        end else begin
            case (state)  // 状态机用case语句表示
                0: begin
                    trans_done <= 0;
                    if (trans_go) begin
                        data <= data32[31:24];
                        send_go <= 1'b1;
                        state <= 1;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 0;  // 保持原状态的情况可以不写
                    end
                end
                1: begin
                    if (tx_done) begin
                        data <= data32[23:16];  // 先发送高位，先接收高位，先接收的显示靠左边
                        send_go <= 1'b1;
                        state <= 2;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 1;
                    end
                end
                2: begin
                    if (tx_done) begin
                        data <= data32[15:8];
                        send_go <= 1'b1;
                        state <= 3;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 2;
                    end
                end
                3: begin
                    if (tx_done) begin
                        data <= data32[7:0];
                        send_go <= 1'b1;
                        state <= 4;
                    end else begin
                        send_go <= 1'b0;
                        state   <= 3;
                    end
                end
                4: begin
                    if (tx_done) begin
                        send_go <= 1'b0;
                        trans_done <= 1;
                        state <= 0;  // 发送结束回到初始状态
                    end else begin
                        send_go <= 1'b0;
                        state   <= 4;
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
