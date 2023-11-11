// 接收串口时间，检测能不能改变hour min sec

module test_change_counter (
    input clk,
    input reset_n,
    input [7:0] data,
    input rx_done,
    output [31:0] disp_data
);

    wire [31:0] new_time;

    uart_cmd uart_cmd_inst (
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .rx_done(rx_done),
        .new_time(new_time),    // output
        .agree_done(agree_done)
    );

    counter_time counter_time_inst (
        .clk(clk),
        .reset_n(reset_n),
        .new_time(new_time),    
        .agree_done(agree_done),
        .disp_data(disp_data)    // output
    );

    
endmodule