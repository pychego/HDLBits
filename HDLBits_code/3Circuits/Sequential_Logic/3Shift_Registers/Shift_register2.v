module top_module (
    input  [3:0] SW,
    input  [3:0] KEY,
    output [3:0] LEDR
);

    wire clk, E, L, w;
    wire r3, r2, r1, r0;
    wire q3, q2, q1, q0;

    assign {w, L, E, clk} = KEY;
    assign {r3, r2, r1, r0} = SW;
    assign LEDR = {q3, q2, q1, q0};


    //  创建模块实例 用的是(), 而不是{}; MUXDFF_3是最左边的实例
    MUXDFF MUXDFF_3 (
        .clk(clk),
        .w  (w),
        .r  (r3),
        .E  (E),
        .L  (L),
        .q  (q3)
    );

    MUXDFF MUXDFF_2 (
        .clk(clk),
        .w  (q3),
        .r  (r2),
        .E  (E),
        .L  (L),
        .q  (q2)
    );

    MUXDFF MUXDFF_1 (
        .clk(clk),
        .w  (q2),
        .r  (r1),
        .E  (E),
        .L  (L),
        .q  (q1)
    );

    MUXDFF MUXDFF_0 (
        .clk(clk),
        .w  (q1),
        .r  (r0),
        .E  (E),
        .L  (L),
        .q  (q0)
    );

endmodule


module MUXDFF (
    input      clk,
    input      w,
    r,
    E,
    L,
    output reg q
);

    always @(posedge clk) begin
        // 底层模块的编写一定要仔细, 因为w和q写反了,检查了好久
        q <= L ? r : (E ? w : q);
    end

endmodule
