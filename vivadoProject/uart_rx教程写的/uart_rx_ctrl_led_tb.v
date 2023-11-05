`timescale 1ns / 1ns

module uart_rx_ctrl_led_tb ();

    reg  clock;
    reg  reset_n;
    reg  uart_rx;
    wire led;

    uart_rx_ctrl_led uart_rx_ctrl_led_inst (
        .clock  (clock),
        .reset_n(reset_n),
        .uart_rx(uart_rx),
        .led    (led)
    );

    // 信号激励
    initial clock = 1'b0;
    always #10 clock = ~clock;

    initial begin
        reset_n = 1'b0;
        uart_rx = 1'b1;
        #201;
        reset_n = 1'b1;
        #200;

        uart_tx_byte(8'h55);
        // @ (posedge rx_done);  // 在task完成之前就产生了rx_done上升沿，赶不上了
        #9000;
        uart_tx_byte(8'ha5);
        #9000;
        uart_tx_byte(8'h12);
        #9000;
        uart_tx_byte(8'h34);
        #9000;
        uart_tx_byte(8'h56);
        #9000;
        uart_tx_byte(8'h00);
        #9000;
        uart_tx_byte(8'h9a);
        #9000;
        uart_tx_byte(8'hf0);
        #9_000_0;

        uart_tx_byte(8'h55);
        // @ (posedge rx_done);  // 在task完成之前就产生了rx_done上升沿，赶不上了
        #9000;
        uart_tx_byte(8'ha5);
        #9000;
        uart_tx_byte(8'h12);
        #9000;
        uart_tx_byte(8'h34);
        #9000;
        uart_tx_byte(8'h56);
        #9000;
        uart_tx_byte(8'h00);
        #9000;
        uart_tx_byte(8'h9a);
        #9000;
        uart_tx_byte(8'hf1);
        #9_000_000_0;

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
