`timescale 1ns/1ns

module digit_led_tb();
    
    reg clk;
    reg reset_n;
    wire [7:0] seg;
    reg [31:0] disp_data;

    digit_led digit_led_inst(
        .clk(clk),
        .reset_n(reset_n),
        .disp_data(disp_data),
        .seg(seg)
    );

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        disp_data = 32'h0000_0000;
        #201 reset_n = 1;
        # 2000;

        disp_data = 32'h12345678;
        # 10_000_000;

        disp_data = 32'h9abcdef;
        # 10_000_000;

        $stop;


    end


endmodule