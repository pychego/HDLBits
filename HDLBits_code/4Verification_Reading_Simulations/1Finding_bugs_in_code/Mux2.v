module top_module (
    input  [1:0] sel,
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] out
);

    // 在纸上画出mux的连接方式就很好写
    wire [7:0] mux_0_out, mux_1_out;
    mux2 mux_0 (
        sel[0],
        a,
        b,
        mux_0_out
    );
    mux2 mux_1 (
        sel[0],
        c,
        d,
        mux_1_out
    );
    mux2 mux_2 (
        sel[1],
        mux_0_out,
        mux_1_out,
        out
    );


endmodule
