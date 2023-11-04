`timescale 1ns / 1ns

module uart_byte_rx_tb ();

    // 定义信号
    reg        clock;
    reg        reset_n;
    reg        uart_rx;
    wire [7:0] data;
    wire       rx_done;

    uart_byte_rx uart_byte_rx_inst (
        .clock   (clock),
        .reset_n (reset_n),
        .band_set(4),
        .uart_rx (uart_rx),
        .data    (data),
        .rx_done (rx_done)
    );

    // 定义激励
    initial clock = 1'b1;
    always #10 clock = ~clock;

    initial begin
        reset_n = 1'b0;
        uart_rx = 1'b1;
        #201;
        reset_n = 1'b1;
        #200;

        uart_tx_byte(8'h5a);
        // @ (posedge rx_done);  // 在task完成之前就产生了rx_done上升沿，赶不上了
        #9000;

        uart_tx_byte(8'ha5);
        #9000;

        uart_tx_byte(8'h86);
        #9000;
        $stop;
    end

    task uart_tx_byte(input [7:0] tx_data);
        begin
            uart_rx = 1'b1;
            #20;
            uart_rx = 0;  // 起始位
            #8680;
            uart_rx = tx_data[0];
            #8680;
            uart_rx = tx_data[1];
            #8680;
            uart_rx = tx_data[2];
            #8680;
            uart_rx = tx_data[3];
            #8680;
            uart_rx = tx_data[4];
            #8680;
            uart_rx = tx_data[5];
            #8680;
            uart_rx = tx_data[6];
            #8680;
            uart_rx = tx_data[7];
            #8680;
            uart_rx = 1'b1;  // 停止位
            #8680;
        end
    endtask

endmodule
