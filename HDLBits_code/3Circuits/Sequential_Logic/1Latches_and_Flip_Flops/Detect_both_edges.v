module top_module(
    input clk,
    input [7:0] in,
    output reg  [7:0] anyedge
);

    reg [7:0] delay_in;
    always@(posedge clk) begin
        delay_in <= in;
    end

    always@(posedge clk) begin
        anyedge <= delay_in ^ in;
    end

endmodule