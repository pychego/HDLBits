`timescale 1ns / 1ns

module uart_tx_data3_tb ();

    reg        clock;
    reg        reset_n;
    reg  [7:0] n_byte;
    reg        trans_go;
    wire       uart_tx;
    wire       trans_done;


    uart_tx_data3 urat_tx_data3_inst (
        .clock     (clock),
        .reset_n   (reset_n),
        .n_byte    (n_byte),
        .trans_go  (trans_go),   // 以上为输入
        .uart_tx   (uart_tx),
        .trans_done(trans_done)
    );

    // 信号激励
    initial clock = 1'b1;
    always #10 clock = ~clock;

    initial begin
        reset_n  = 1'b0;
        n_byte   = 10;
        trans_go = 1'b0;  // 相当于reset

        #201;
        reset_n  = 1'b1;
        trans_go = 1'b1;
        #20;
        trans_go = 1'b0;
        @(posedge trans_done);

        #10_000000;
        trans_go = 1'b1;
        #20;
        trans_go = 1'b0;
        @(posedge trans_done);

        #10_000000;
        $stop;

    end

endmodule
