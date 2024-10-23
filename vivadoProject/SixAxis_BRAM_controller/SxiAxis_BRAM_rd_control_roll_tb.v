`timescale 1ns / 1ps

module SxiAxis_BRAM_rd_control_roll_tb ();

    reg         clk;
    reg         rst_n;
    reg         start;
    wire        bram_en;
    wire [31:0] bram_addr;
    wire        bram_clk;
    reg  [31:0] Ts;
    reg  [31:0] epoch;
    reg  [31:0] addition;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        #15 rst_n = 1'b1;
        #2000000 start = 1'b1;
    end

    always #5 clk = ~clk;

    initial begin
        Ts      = 2;
        epoch   = 5;
        addition = 100;
    end

    initial begin
        #3000000 $finish;
    end

    SxiAxis_BRAM_rd_control_roll u_SxiAxis_BRAM_rd_control_roll (
        .clk          (clk),
        .rst_n        (rst_n),
        .start        (start),
        .bram_en      (bram_en),
        .bram_addr    (bram_addr),
        .bram_clk     (bram_clk),
        .Ts           (Ts),
        .epoch        (epoch),
        .addition     (addition)
    );

    wire [31:0] data_target;
    blk_mem_gen_0 u_blk_mem_gen_0 (
        .clka (bram_clk),    // input wire clka
        .ena  (bram_en),     // input wire ena
        .addra(bram_addr),   // input wire [9 : 0] addra
        .douta(data_target)  // output wire [31 : 0] douta
    );

endmodule
