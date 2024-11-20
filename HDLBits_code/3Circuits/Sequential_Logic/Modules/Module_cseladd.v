module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] out1;
    wire [15:0] out2;
    wire sel;
    wire q1, q2;
    add16 a1(a[15:0], b[15:0], 0, sum[15:0], sel);
    add16 a2(a[31:16], b[31:16], 0, out1, q1);
    add16 a3(a[31:16], b[31:16], 1, out2, q2);

    always @(*) begin
        case (sel)
            1'b0: sum[31:16] = out1;
            1'b1: sum[31:16] = out2;
        endcase
    end
endmodule
