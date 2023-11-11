`timescale 1ns/1ns

module uart_tx_data32_tb ();

    reg clk;
    reg reset_n;
    reg [31:0] data32;
    reg trans_go;
    wire trans_done;
    wire uart_tx;
    
    uart_tx_data32 uart_tx_data32_inst(
        .clk(clk),
        .reset_n(reset_n),
        .data32(data32),
        .trans_go(trans_go),
        .uart_tx(uart_tx),
        .trans_done(trans_done)
    );

    // 产生激励信号
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        data32 = 32'h87654321;
        trans_go = 0;

        #201;
        reset_n = 1;
        trans_go = 1;
        #20;
        trans_go = 0;
        @(posedge trans_done);

        data32 = 40'h12345678;

        #10_000000;
        trans_go = 1'b1;
        #20;
        trans_go = 1'b0;
        @(posedge trans_done);
        #10_000000;
        $stop;

    end

endmodule