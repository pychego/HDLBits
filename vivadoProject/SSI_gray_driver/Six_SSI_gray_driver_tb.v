`timescale 1ns / 1ps

module SSI_gray_driver_tb ();

    reg         clk;
    reg         rst_n;
    reg         SSI_data0;
    reg         SSI_data1;
    reg         SSI_data2;
    reg         SSI_data3;
    reg         SSI_data4;
    reg         SSI_data5;
    wire        SSI_clk0;
    wire        SSI_clk1;
    wire        SSI_clk2;
    wire        SSI_clk3;
    wire        SSI_clk4;
    wire        SSI_clk5;
    wire [31:0] loc_data_gray0;
    wire [31:0] loc_data_gray1;
    wire [31:0] loc_data_gray2;
    wire [31:0] loc_data_gray3;
    wire [31:0] loc_data_gray4;
    wire [31:0] loc_data_gray5;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #15 rst_n = 1'b1;
    end

    // 100Mhz
    always #5 clk = ~clk;

    always @(posedge SSI_clk0) begin
        // $random()生成一个32位随机数，取模2得到0或1
        SSI_data0 = $random() % 2;
        SSI_data1 = $random() % 3;
        SSI_data2 = $random() % 4;
        SSI_data3 = $random() % 5;
        SSI_data4 = $random() % 6;
        SSI_data5 = $random() % 7;
    end

    initial begin
        #300000 $finish;
    end

    Six_SSI_gray_driver u_Six_SSI_gray_driver (
        .clk      (clk),
        .rst_n    (rst_n),
        .SSI_data0(SSI_data0),
        .SSI_data1(SSI_data1),
        .SSI_data2(SSI_data2),
        .SSI_data3(SSI_data3),
        .SSI_data4(SSI_data4),
        .SSI_data5(SSI_data5),
        .SSI_clk0 (SSI_clk0),   // output to sensor
        .SSI_clk1 (SSI_clk1),   // output to sensor
        .SSI_clk2 (SSI_clk2),   // output to sensor
        .SSI_clk3 (SSI_clk3),   // output to sensor
        .SSI_clk4 (SSI_clk4),   // output to sensor
        .SSI_clk5 (SSI_clk5),   // output to sensor
        .loc_data_gray0(loc_data_gray0),  // output
        .loc_data_gray1(loc_data_gray1),  // output
        .loc_data_gray2(loc_data_gray2),  // output
        .loc_data_gray3(loc_data_gray3),  // output
        .loc_data_gray4(loc_data_gray4),  // output
        .loc_data_gray5(loc_data_gray5)   // output
    );

endmodule
