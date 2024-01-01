// Given a 100-bit input vector [99:0], reverse its bit ordering.
// 综合一下看看电路
module top_module( 
    input [99:0] in,
    output [99:0] out
);

    reg [10:0] i;
    always @(*) begin
        for (i = 0; i<100; i++) begin
            out[i] = in[99-i];
        end
    end

endmodule
