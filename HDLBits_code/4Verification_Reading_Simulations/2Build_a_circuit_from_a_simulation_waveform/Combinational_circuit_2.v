module top_module (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);  //

    // 即为四个变量同或
    assign q = ~(a ^ b ^ c ^ d);  // Fix me

endmodule
