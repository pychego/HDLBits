module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire cout1, cout2;
    wire [31:0] xor_out;
    assign xor_out = b[31: 0] ^ {32{sub}};  //扩展sub并按位异或xor

    add16 a1(a[15:0], xor_out[15:0], sub, sum[15:0], cout1);
    add16 a2(a[31:16], xor_out[31:16], cout1, sum[31:16], cout2);
endmodule
