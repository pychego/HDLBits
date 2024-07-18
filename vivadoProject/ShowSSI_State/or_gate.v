module or_gate (
    input a,    // 第一个输入
    input b,    // 第二个输入
    output y    // 输出
);

    // 使用连续赋值语句实现或运算
    assign y = a | b;

endmodule