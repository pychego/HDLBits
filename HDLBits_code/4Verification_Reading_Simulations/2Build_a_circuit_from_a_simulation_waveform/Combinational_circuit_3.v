module top_module (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);  //

    // 根据卡诺图写逻辑式
    assign q = (a | b)&(c | d);

endmodule
