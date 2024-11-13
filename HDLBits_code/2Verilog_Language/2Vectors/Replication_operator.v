module top_module (
    input [7:0] in,
    output [31: 0] out
);

    // 易错, 需要三个大括号
    assign out = {{24{in[7]}}, in};


endmodule