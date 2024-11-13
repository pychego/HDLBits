module top_module (
    input a,
    input b,
    output out
);
    // 同或门
    assign out = (a&b)|((~a)&(~b));

endmodule