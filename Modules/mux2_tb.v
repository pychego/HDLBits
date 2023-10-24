`timescale 1ns/1ns  // 时间单位/时间精度
// tb test_bench文件第一行要写的内容

// 测试文件不需要输入输出，只需要实例化被测模块，然后对其进行测试
module mux2_tb();

    reg s_a, s_b, sel;  // 输入信号定义为reg
    wire out;           // 输出信号定义为wire
    // 实例化被测模块
    mux2 mux2(
        .a(s_a),
        .b(s_b),
        .sel(sel),
        .out(out)
    );

    initial begin
        s_a = 0; s_b = 0; sel = 0;
        # 100;  // 延时只能用于测试，不能综合
        s_a = 0; s_b = 1; sel = 0;
        # 100;
        s_a = 1; s_b = 0; sel = 0;
        # 100;
        s_a = 1; s_b = 1; sel = 0;
        # 100;
        s_a = 0; s_b = 0; sel = 1;
        # 100;
        s_a = 0; s_b = 1; sel = 1;
        # 100;
        s_a = 1; s_b = 0; sel = 1;
    end

endmodule