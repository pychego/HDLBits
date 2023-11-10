// 例化了产生sel和seg的模块以及HC595驱动模块

module digit_led_test (
    input clk,
    input reset_n,
    output seg7_sclk,
    output seg7_rclk,
    output seg7_dio,
    output uart_tx
    );
    
    // 数码管上要显示的内容，最低位对应数码管的最右边
    wire [31:0] disp_data;
    
    wire s_en;
    assign s_en = 1;

    wire [7:0] sel;
    wire [7:0] seg;

    uart_tx_data32_min uart_tx_data32_min_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .data32    (disp_data),
        .uart_tx   (uart_tx)
    );


    counter_time counter_time_inst(
        .clk(clk),
        .reset_n(reset_n),
        .disp_data(disp_data)   // output
    );
    

    digit_led digit_led_inst(
        .clk(clk),
        .reset_n(reset_n),
        .disp_data(disp_data),  // input
        .sel(sel),
        .seg(seg)
    );

    wire [15:0] data;   // 中间变量存放第一个模块的段选和片选信号
    assign data = {seg, sel};

        HC595driver HC595driver_inst(
        .clk(clk),
        .reset_n(reset_n),
        .s_en(s_en),
        .data(data),
        .seg7_sclk(seg7_sclk),
        .seg7_rclk(seg7_rclk),
        .seg7_dio(seg7_dio)
    );

endmodule