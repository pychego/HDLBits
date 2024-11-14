module top_module (
    input  clk,
    input  x,
    output z
);

    wire d1, d2, d3;
    wire q1, q2, q3;

    assign d1 = x ^ q1;
    assign d2 = x & ~q2;
    assign d3 = x | ~q3;

    assign z = ~(q1 | q2 | q3);

    DFF dff_1 (
        .clk  (clk),
        .d    (d1),
        .q    (q1)
    );

    DFF dff_2 (
        .clk  (clk),
        .d    (d2),
        .q    (q2)
    );

    DFF dff_3 (
        .clk  (clk),
        .d    (d3),
        .q    (q3)
    );

endmodule


module DFF (
    input      clk,
    input      d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end


endmodule
