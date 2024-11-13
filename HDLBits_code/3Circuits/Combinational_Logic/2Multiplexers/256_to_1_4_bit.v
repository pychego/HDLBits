module top_module(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    assign out = {in[sel*4+3], in[sel*4+2], in[sel*4+1], in[sel*4]};

    // 不能切片两边都是包含sel的表达式, 下面这个是错的
    // assign out = in[sel*4+3: sel*4];

    // 以下两种写法都可以
    // assign out = in[sel*4 +: 4];	
    // assign out = in[sel*4+3 -:4];
//     [起始位 +: 位宽]  // 从起始位向高位选择指定位宽
//     [起始位 -: 位宽]  // 从起始位向低位选择指定位宽

endmodule