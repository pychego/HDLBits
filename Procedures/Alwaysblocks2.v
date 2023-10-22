// 规定: 在组合模块中使用阻塞赋值, 在时序模块中使用非阻塞赋值
// synthesis verilog_input_version verilog_2001
module top_module(
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff   );

    assign out_assign = a ^ b; // assign语句并行执行

    always @(*) begin  //组合模块中使用阻塞赋值
        out_always_comb = a ^ b;
    end

    always @(posedge clk) begin  //时序模块中使用非阻塞赋值
        out_always_ff <= a ^ b;
    end
endmodule
