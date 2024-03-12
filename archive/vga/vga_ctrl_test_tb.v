`timescale 1ns/1ns

module vga_ctrl_test_tb ();
    
    reg clk;
    reg reset_n;
    wire [11:0] vga_RGB;
    wire vga_HS;
    wire vga_VS;



    vga_ctrl_test vga_ctrl_test_inst(
        .clk(clk),
        .reset_n(reset_n),
        .vga_RGB(vga_RGB),
        .vga_HS(vga_HS),
        .vga_VS(vga_VS)    
    );

    initial begin
        clk = 1;
    end
    always #10 clk = ~ clk;

    initial begin
        reset_n = 0;
        #201;
        reset_n = 1;
        #50000000;
        stop;
    end

endmodule