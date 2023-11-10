`timescale 1ns/1ns

module HC595driver_tb ();
    
    reg clk;
    reg reset_n;
    reg s_en;
    reg [15:0] data;
    wire seg7_sclk;
    wire seg7_rclk;
    wire seg7_dio;


    HC595driver HC595driver_inst(
        .clk(clk),
        .reset_n(reset_n),
        .s_en(s_en),
        .data(data),
        .seg7_sclk(seg7_sclk),
        .seg7_rclk(seg7_rclk),
        .seg7_dio(seg7_dio)
    );

    // 信号激励
    initial clk = 0;
    always #20 clk = ~clk;

    initial begin
        reset_n = 0;
        data = 16'h0000;
        s_en = 0;
        # 201;

        reset_n = 1;
        # 500;
        data = 16'h47a9;
        s_en = 1;
        # 20;
        s_en = 0;
        # 200000;

        data = 16'h5832;
        s_en = 1;
        # 20;
        s_en = 0;
        # 200000;
        $stop;

    end
    

endmodule