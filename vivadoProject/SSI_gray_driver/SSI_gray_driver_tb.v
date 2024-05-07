`timescale 1ns / 1ps

module SSI_gray_driver_tb ();

    reg         clk;
    reg         rst_n;
    reg         SSI_data;
    wire        SSI_clk;
    wire [24:0] loc_data;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #15 rst_n = 1'b1;
    end

    // 100Mhz
    always #5 clk = ~clk;

    always @(posedge SSI_clk) begin
        // $random()生成一个32位随机数，取模2得到0或1
        SSI_data = $random() % 2;
    end

    initial begin
        #300000 $finish;
    end

    SSI_gray_driver u_SSI_gray_driver (
        .clk     (clk),
        .rst_n   (rst_n),
        .SSI_data(SSI_data),
        .SSI_clk (SSI_clk),     // output to sensor
        .loc_data(loc_data)     // output
    );

endmodule
