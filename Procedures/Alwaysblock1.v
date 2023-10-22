// synthesis verilog_input_version verilog_2001
module top_module(
    input a, 
    input b,
    output wire out_assign,
    output reg out_alwaysblock
);
    // assign左边必须是net(eg wire)类型，always block左边必须是reg类型
    assign out_assign = a & b;
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule
