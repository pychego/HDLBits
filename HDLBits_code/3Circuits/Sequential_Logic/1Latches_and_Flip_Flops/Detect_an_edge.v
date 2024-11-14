module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 最简单的边缘检测电路

    reg [7:0] delay_in;
    always@(posedge clk) begin
        delay_in <= in;
    end

    always@(posedge clk) begin
        pedge <= in & (~delay_in);
    end


endmodule