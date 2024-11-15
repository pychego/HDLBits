module top_module (
    input  [2:0] SW,
    input  [1:0] KEY,
    output [2:0] LEDR
);

    wire r0, r1, r2, L, clk;
    wire q2, q1, q0;
    assign {r2, r1, r0} = SW;
    assign {L, clk} = KEY;
    assign LEDR = {q2, q1, q0};

    Mux_and_DFF Mux_and_DFF_inst0 (
        .data0(q2),
        .data1(r0),
        .sel  (L),
        .clk  (clk),
        .q    (q0)
    );

    Mux_and_DFF Mux_and_DFF_inst1 (
        .data0(q0),
        .data1(r1),
        .sel  (L),
        .clk  (clk),
        .q    (q1)
    );

    Mux_and_DFF Mux_and_DFF_inst2 (
        .data0(q1 ^ q2),
        .data1(r2),
        .sel  (L),
        .clk  (clk),
        .q    (q2)
    );


endmodule


module Mux_and_DFF (
    input      data0,
    input      data1,
    input      sel,
    input      clk,
    output reg q
);

    always @(posedge clk) begin
        q <= sel ? data1 : data0;
    end

endmodule
