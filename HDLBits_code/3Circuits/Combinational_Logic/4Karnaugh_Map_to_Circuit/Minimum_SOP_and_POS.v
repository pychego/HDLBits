module top_module(
    input a, b, c, d,
    output out_sop, out_pos
);


    // 感觉这一题有毛病啊
    // 可能题目要求是利用无关项化简到最简
    assign out_sop =  c&d | (~a)&(~b)&c;
    // 一系列最小项之和等于与之相反项的最大项之积;
    assign out_pos = out_sop;
endmodule