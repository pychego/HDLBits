module top_module(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;
    // xor 异或门
    assign out_xor = ^in;


endmodule