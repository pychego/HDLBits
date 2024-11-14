module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // d don't care
    assign out = a | c&(~b);

endmodule