`timescale 1ns/1ns


module urat_byte_test_tb (
);


    reg clock;     // initial中信号为reg
    reg reset_n;
    wire uart_tx;


    uart_byte_test uart_byte_test_inst (
        .clock(clock),
        .reset_n(reset_n),
        .uart_tx(uart_tx)
    );

    // 激励信号
    initial clock = 1'b1;
    always #10 clock = ~clock;

    initial begin
        // 初始复位;
        reset_n = 1'b0;
        
        # 201;
        reset_n = 1'b1;
        # 50_000000;
        $stop;
    end
    
endmodule