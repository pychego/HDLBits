module top_module (
    input            clk,
    input            a,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (~a) begin
            if (q < 6) q <= q + 1;
            else q <= 0;
        end else q <= 4;
    end


endmodule
