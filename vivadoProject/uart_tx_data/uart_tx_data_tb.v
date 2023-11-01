`timescale 1ns / 1ns

module uart_tx_data_tb ();

    // 定义信号
    reg          clock;
    reg          reset_n;
    reg          trans_go;
    reg [40-1:0] data40;
    wire uart_tx, trans_done;

    uart_tx_data2 uart_tx_data_inst (
        .clock     (clock),
        .reset_n   (reset_n),
        .data40    (data40),
        .trans_go  (trans_go),
        .uart_tx   (uart_tx),
        .trans_done(trans_done)  //最后不能加，
    );

    // 信号激励
    initial clock = 1'b1;
    always #10 clock = ~clock;

    initial begin
        reset_n  = 1'b0;
        trans_go = 1'b0;
        data40   = 40'h123456789a;

        #201;  // 错开组合逻辑与clk上升沿的时间
        reset_n  = 1'b1;
        trans_go = 1'b1;
        #20;
        trans_go = 1'b0;  // 脉冲信号
        @(posedge trans_done);

        #10_000000;
        trans_go = 1'b1;
        data40   = 40'ha987654321;
        #20;
        trans_go = 1'b0;
        @(posedge trans_done);

        #10_000000;
        $stop;
    end


endmodule
