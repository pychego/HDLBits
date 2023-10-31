// 串口向电脑发送5字节的数据

module uart_tx_data (
    input clock,
    input reset_n,
    input data40,   // 40bit data
    input trans_go,  // 类似于send_go, 管40bit
    output uart_tx
);
    
    uart_byte uart_byte_inst(
        .clock(clock),
        .reset_n(reset_n),
        .send_go(send_go),
        .band_set(4),
        .data(data),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );

endmodule
