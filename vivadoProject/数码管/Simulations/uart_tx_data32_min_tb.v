`timescale 1ns/1ns

module uart_tx_data32_min_tb ();
    
    reg clk;
    reg reset_n;
    reg [31:0] data32;
    wire uart_tx;
    
    uart_tx_data32_min uart_tx_data32_min_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .data32    (data32),
        .uart_tx   (uart_tx)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        data32 = 32'h12345678;
        #201;

        reset_n = 1;
        #6000000;
        data32 = 32'h87654321;
        #12000000;
        $stop;
        
    end

endmodule