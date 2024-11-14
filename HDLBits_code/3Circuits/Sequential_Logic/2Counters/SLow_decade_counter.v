module top_module (
    input            clk,
    input            slowena,
    input            reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 0;
        else begin
            if (!slowena) q <= q;
            else begin
                if (q == 9) q <= 0;
                else q <= q + 1;
            end
        end
    end

endmodule
