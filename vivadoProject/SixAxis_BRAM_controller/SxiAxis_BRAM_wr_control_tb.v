`timescale 1ns / 1ns

module SxiAxis_BRAM_wr_control_tb ();

    reg         clk;
    reg         rst_n;
    reg         start;
    wire        bram_en;
    wire [ 3:0] bram_we;
    wire [31:0] bram_addr;
    wire        bram_clk;
    reg  [31:0] bram_count;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        #15 rst_n = 1'b1;
        #2000000 start = 1'b1;
    end

    always #5 clk = ~clk;

    initial begin
        bram_count = 10;  // 1000
    end

    initial begin
        #3000000 $finish;
    end

    SxiAxis_BRAM_wr_control u_SxiAxis_BRAM_wr_control (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start),
        .bram_en     (bram_en),
        .bram_we     (bram_we),
        .bram_addr   (bram_addr),
        .bram_clk    (bram_clk),
        .bram_count  (bram_count)
    );

endmodule
