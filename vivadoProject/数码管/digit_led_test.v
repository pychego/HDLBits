//digit_led的测试模块，送32位显示数据

module digit_led_test (
    input clk,
    input reset_n,
    output [7:0] sel,
    output [7:0] seg
);
    
    wire [31:0] disp_data;
    assign disp_data = 32'h12345678;

    digit_led digit_led_inst(
        .clk(clk),
        .reset_n(reset_n),
        .disp_data(disp_data),
        .sel(sel),
        .seg(seg)
    );

endmodule