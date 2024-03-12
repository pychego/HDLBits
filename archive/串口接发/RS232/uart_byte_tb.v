// 测试串口通信模块
`timescale 1ns / 1ns
module uart_byte_tb ();

    reg        clock;
    reg        reset_n;
    reg        send_en;
    reg  [3:0] band_set;
    reg  [7:0] data;
    wire       uart_tx;
    wire       tx_done;

    uart_byte uart_byte (
        .clock   (clock),
        .reset_n (reset_n),
        .send_en (send_en),
        .band_set(band_set),
        .data    (data),
        .uart_tx (uart_tx),
        .tx_done (tx_done)
    );

    // 产生激励信号
    initial clock = 1'b1;
    always #10 clock = ~clock;


    // 主要对reg信号进行赋值
    initial begin
        reset_n = 1'b0;
        data = 8'b0;
        send_en = 1'b0;  // 上电进行复位操作
        band_set = 4;

        #201   // 错开clk的上升沿，避免出现输入和clk上升沿同时变化，无法确定信号值
        #100;
        data = 8'h57;
        send_en = 1'b1;
        reset_n = 1'b1;
        #20;
        // 如果没有上升沿，就一直死等
        @(posedge tx_done);  // 阻塞语句，等待发送完成
        send_en = 0;  // 发送完成后，send_en立刻变为0

        #20000;
        data = 8'h75;
        send_en = 1'b1;
        #20;
        @(posedge tx_done);  // 阻塞语句，等待发送完成
        send_en = 0;
        #20000;
        $stop;
    end



endmodule
