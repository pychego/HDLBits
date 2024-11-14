module top_module (
    input         clk,
    input         reset,
    output [ 3:1] ena,
    output [15:0] q
);

    assign ena[1] = q[3:0] == 9;
    assign ena[2] = (q[3:0] == 9) && (q[7:4] == 9);
    assign ena[3] = (q[3:0] == 9) && (q[7:4] == 9) && (q[11:8] == 9);

    bcdcount bcdcount_0 (
        .clk   (clk),
        .reset (reset),
        .enable(1),
        .q     (q[3:0])
    );

    bcdcount bcdcount_1 (
        .clk   (clk),
        .reset (reset),
        .enable(ena[1]),
        .q     (q[7:4])
    );

    bcdcount bcdcount_2 (
        .clk   (clk),
        .reset (reset),
        .enable(ena[2]),
        .q     (q[11:8])
    );

    bcdcount bcdcount_3 (
        .clk   (clk),
        .reset (reset),
        .enable(ena[3]),
        .q     (q[15:12])
    );

endmodule



module bcdcount (
    input            clk,
    input            reset,
    input            enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 0;
        else begin
            if (enable) begin
                // 判断条件写成了if(q<=9), 问题找了半天
                if (q == 9) q <= 0;
                else q <= q + 1;
            end else q <= q;
        end
    end

endmodule
