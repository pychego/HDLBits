module top_module(
    input a, 
    input b,
    output wire out_assign,
    output reg out_alwaysblock
);

    // 二者完成的功能完全一致, 综合的电路没有区别
    assign out_assign = a & b;

    always@(*) begin
        out_alwaysblock = a & b;
    end


endmodule