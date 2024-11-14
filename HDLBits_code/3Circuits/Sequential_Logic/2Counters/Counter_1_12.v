module top_module (
    input        clk,
    input        reset,
    input        enable,
    output [3:0] Q,
    output       c_enable,
    output       c_load,
    output [3:0] c_d
);

    reg [3:0] q;

    assign c_enable = enable;
    assign c_load = reset | ((Q == 4'd12) && enable);
    assign c_d = 4'd1;

    count4 count4_0 (
        .clk   (clk),
        .enable(c_enable),
        .load  (c_load),
        .d     (c_d),
        .Q     (Q)
    );

endmodule
