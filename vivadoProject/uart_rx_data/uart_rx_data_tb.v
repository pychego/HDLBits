`timescale 1ns/1ns

module uart_rx_data_tb ();

    // 定义信号
    reg clock, reset_n;
    reg uart_rx;
    wire [7:0] data;
    wire rx_done;


    uart_rx_data uart_rx_data_inst(
        .clock      (clock),
        .reset_n    (reset_n),
        .uart_rx    (uart_rx),
        .band_set     (4),
        .data       (data),
        .rx_done    (rx_done)
    ); 

    // 信号激励
    initial clock = 1'b1;
    always #10 clock = ~clock;

    initial begin
        reset_n = 1'b0;
        uart_rx = 1'b1;

        #201;
        reset_n = 1'b1;
        #20;
        uart_rx = 1'b0; // start位
        #104160;
        uart_rx = 1'b1; // 低位
        #104160;
        uart_rx = 1'b0;
        #104160;
        uart_rx = 1'b1;
        #104160;
        uart_rx = 1'b0;
        #104160;
        uart_rx = 1'b1;
        #104160;
        uart_rx = 1'b1;
        #104160;
        uart_rx = 1'b0;
        #104160;
        uart_rx = 1'b0;
        #104160;
        uart_rx = 1'b1; // stop位
        #104160;
        # 10_000000;
        $stop;
        
    end
    
endmodule