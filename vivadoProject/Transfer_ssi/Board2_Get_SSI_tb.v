`timescale 1ns / 1ps

module Board2_Get_SSI_tb ();

    reg  clk;
    reg  rst_n;
    reg  SSI_data2SSI;
    wire SSI_flag2Board1;
    wire SSI_clk2SSI;
    wire SSI_clk2Board1;
    wire SSI_data2Board1;
    wire led;
    wire test_B33IO;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #15 rst_n = 1'b1;
    end

    // 100Mhz
    always #5 clk = ~clk;

    always @(posedge SSI_clk2SSI) begin
        // $random()生成一个32位随机数，取模2得到0或1
        SSI_data2SSI = $random() % 2;
    end

    initial begin
        #300000 $finish;
    end

    Board2_Get_SSI u_Board2_Get_SSI (
        .clk            (clk),
        .rst_n          (rst_n),
        .SSI_data       (SSI_data2SSI),
        .SSI_clk2SSI    (SSI_clk2SSI),      // output to sensor
        .SSI_clk2Board1 (SSI_clk2Board1),   // output
        .SSI_flag2Board1(SSI_flag2Board1),
        .SSI_data2Board1(SSI_data2Board1),  // output
        .led            (led),               // Indicating Board2 is working
        .test_B33IO     (test_B33IO)
    );

endmodule
