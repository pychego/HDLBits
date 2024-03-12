module blcok_noblock_tb ();

    // 定义信号
    reg clock, reset_n;
    reg a, b, c;
    wire [1:0] out;

    blcok_noblock blcok_noblock_inst (
        .a(a),
        .b(b),
        .c(c),
        .clock(clock),
        .reset_n(reset_n),
        .out(out)
    );

    // 信号激励
    initial begin
        clock = 0;
        reset_n = 0;
        # 10 reset_n = 1;
        # 20 a = 0; b = 0; c = 0;  // 测试下延时为21的情况, 可以让组合逻辑变化避开clk上升沿
        # 20 a = 0; b = 0; c = 1;
        # 20 a = 0; b = 1; c = 0;
        # 20 a = 0; b = 1; c = 1;
        # 20 a = 1; b = 0; c = 0;
        # 20 a = 1; b = 0; c = 1;
        # 20 a =1; b = 1; c = 0;
        # 20 a = 1; b = 1; c = 1;
        

    // 测试时c从1到0的瞬间和clk上升沿瞬间同时到达，因为
    // c不受时钟的控制，仿真是c看作了1（这个和仿真器有关）
    // d为非阻塞赋值时，clk上升沿来到是看d之前的值
    end
    always #10 clock = ~clock;
    
endmodule