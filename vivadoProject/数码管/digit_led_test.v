// 例化了产生sel和seg的模块以及HC595驱动模块

module digit_led_test (
    input  clk,
    input  reset_n,
    input  uart_rx,
    output seg7_sclk,
    output seg7_rclk,
    output seg7_dio,
    output uart_tx
);

    // 数码管上要显示的内容，最低位对应数码管的最右边
    wire [31:0] disp_data;

    wire        s_en;
    assign s_en = 1;

    wire [ 7:0] sel;
    wire [ 7:0] seg;

    wire [ 7:0] data;
    wire        rx_done;
    wire [31:0] new_time;


    uart_byte_rx uart_byte_rx_inst (
        .clk     (clk),
        .reset_n (reset_n),
        .band_set(4),        // 115200
        .uart_rx (uart_rx),
        .data    (data),     // output
        .rx_done (rx_done)
    );

    uart_cmd uart_cmd_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .data      (data),
        .rx_done   (rx_done),
        .new_time  (new_time),   // output
        .agree_done(agree_done)
    );


    counter_time counter_time_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .new_time  (new_time),    // input
        .agree_done(agree_done),
        .disp_data (disp_data)    // output
    );

    uart_tx_data32_min uart_tx_data32_min_inst (
        .clk    (clk),
        .reset_n(reset_n),
        .data32 (disp_data),
        .uart_tx(uart_tx)     // output
    );


    digit_led digit_led_inst (
        .clk      (clk),
        .reset_n  (reset_n),
        .disp_data(disp_data),  // input
        .sel      (sel),
        .seg      (seg)
    );

    // wire [15:0] data_seg_sel;  // 中间变量存放第一个模块的段选和片选信号
    // assign data_seg_sel = {seg, sel};

    HC595driver HC595driver_inst (
        .clk      (clk),
        .reset_n  (reset_n),
        .s_en     (s_en),
        .data     ({seg, sel}),
        .seg7_sclk(seg7_sclk),   // output
        .seg7_rclk(seg7_rclk),
        .seg7_dio (seg7_dio)
    );

endmodule
