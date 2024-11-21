// synthesis verilog_input_version verilog_2001
module top_module (
    input            do_sub,
    input      [7:0] a,
    input      [7:0] b,
    output reg [7:0] out,
    output reg       result_is_zero
);  //


    // 原代码的问题是形成了latch, 没有在任何输出状态下都为输出分配确定的值
    // 这里always @(*) 可以检测出out的变化, case和if在仿真中应该是串行的, 在实际综合应该是并行的
    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        if (out == 0) result_is_zero = 1;
        else result_is_zero = 0;
    end

endmodule
