module top_module (
    input             clk,
    input             reset,
    output reg [31:0] q
);

    reg [31:0] next_q;

    always @(*) begin
        next_q = {q[0], q[31:1]};
        next_q[21] = q[22] ^ q[0];
        next_q[1] = q[2] ^ q[0];
        next_q[0] = q[1] ^ q[0];
    end

    always @(posedge clk) begin
        if (reset) q <= 1;
        else q <= next_q;
    end

endmodule
