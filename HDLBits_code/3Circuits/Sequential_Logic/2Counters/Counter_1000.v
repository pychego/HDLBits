module top_module (
    input        clk,
    input        reset,
    output       OneHertz,
    output [2:0] c_enable
);


    wire [3:0] q1, q2, q3;

    assign c_enable[0] = !reset;
    assign c_enable[1] = (q1 == 9);
    assign c_enable[2] = (q2 == 9)&&(q1==9);

    bcdcount bcdcount_0 (
        .clk   (clk),
        .reset (reset),
        .enable(c_enable[0]),
        .Q     (q1)
    );

    bcdcount bcdcount_1 (
        .clk   (clk),
        .reset (reset),
        .enable(c_enable[1]),
        .Q     (q2)
    );

    bcdcount bcdcount_2 (
        .clk   (clk),
        .reset (reset),
        .enable(c_enable[2]),
        .Q     (q3)
    );

    assign OneHertz = (q3==9)&&(q2 == 9)&&(q1==9);

endmodule
