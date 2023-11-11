// 每分钟发送一次data32

module uart_tx_data32_min (
    input         clk,
    input         reset_n,
    input  [31:0] data32,
    output        uart_tx
);

    reg  trans_go;
    wire trans_done;
    reg  [31:0] count;
    parameter MCNT = 500_00000;  // 1s  上板子
    // parameter MCNT = 500_000;  // 10ms 仿真

    uart_tx_data32 uart_tx_data32_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .data32    (data32),
        .trans_go  (trans_go),   // input
        .uart_tx   (uart_tx),    // output
        .trans_done(trans_done)
    );

    // 操作count
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) count <= 0;
        else if (count <= MCNT - 1) count <= count + 1;
        else count <= 0;
    end

    // 操作trans_go 每个count周期（1min）刚开始令trans_go为1
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) trans_go <= 0;
        else if (count == 1) trans_go <= 1;
        else trans_go <= 0;
    end


endmodule
