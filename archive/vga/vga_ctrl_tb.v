`timescale 1ns / 1ns

module vga_ctrl_tb ();

    reg         clk;
    reg         reset_n;
    reg  [23:0] data;
    wire        data_request;
    wire [31:0] hcount;
    wire [31:0] vcount;
    wire        vga_HS;
    wire        vga_VS;
    wire        vga_BLK;
    wire [11:0] vga_RGB;

    vga_ctrl vga_ctrl_inst (
        .clk         (clk),
        .reset_n     (reset_n),
        .data        (data),
        .data_request(data_request),
        .hcount      (hcount),
        .vcount      (vcount),
        .vga_HS      (vga_HS),
        .vga_VS      (vga_VS),
        .vga_BLK     (vga_BLK),
        .vga_RGB     (vga_RGB)
    );

    initial clk = 1;
    always #20 clk = ~clk;

    initial begin
        reset_n = 0;
        #201;
        reset_n = 1;
        #20000000;
        $stop;

    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) data <= 0;
        else if (!data_request) data <= data;
        else data <= data + 1;
    end

endmodule
