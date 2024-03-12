`timescale 1ns / 1ns
// Time scale is set to 1ns/1ns


module mux2_tb ();  //testbench不需要端口，需要实例化被测模块

    // 输入信号定义为reg类型， 输出定义为wire类型
    wire out;
    reg s_a, s_b, sel;
    // 例化模块， 实例名称可以和模块名字一致
    mux2 mux2 (
        .a  (s_a),
        .b  (s_b),
        .sel(sel),
        .out(out)
    );

    // 产生激励
    initial begin
        s_a = 1'b0;
        s_b = 1'b0;
        sel = 1'b0;
        #200;  // 延时200ns, 用于testbench文件，不可综合
        s_a = 1'b0;
        s_b = 1'b0;
        sel = 1'b1;
        #200;
        s_a = 1'b0;
        s_b = 1'b1;
        sel = 1'b0;
        #200;
        s_a = 1'b0;
        s_b = 1'b1;
        sel = 1'b1;
        #200;
        s_a = 1'b0;
        s_b = 1'b1;
        sel = 1'b0;
        #200;
        s_a = 1'b1;
        s_b = 1'b0;
        sel = 1'b0;
        #200;
        s_a = 1'b1;
        s_b = 1'b0;
        sel = 1'b1;
        #200;
        s_a = 1'b1;
        s_b = 1'b1;
        sel = 1'b0;
        #200;
        s_a = 1'b1;
        s_b = 1'b1;
        sel = 1'b1;
        #200;
        $stop;  // modelSim仿真结束
    end

endmodule
