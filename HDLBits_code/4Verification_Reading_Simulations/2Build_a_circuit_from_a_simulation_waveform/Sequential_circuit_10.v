module top_module (
    input      clk,
    input      a,
    input      b,
    output     q,
    output reg state
);

    always @(posedge clk) begin
        if (a && b) state <= 1;
        else if (a == 0 && b == 0) state <= 0;
        else state <= state;
    end

    assign q = (a ^ b ^ state);


endmodule
