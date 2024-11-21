module top_module (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);  //

    // 根据卡诺图写逻辑式 , 注意不要写成 b + c
    assign q = b | c;

endmodule
