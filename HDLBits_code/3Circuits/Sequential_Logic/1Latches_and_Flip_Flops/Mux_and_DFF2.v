module top_module(
    input clk,
    input w, R, E, L,
    output reg Q
);

    wire d;
    assign d = L ? R : (E ? w : Q);

    always@(posedge clk) begin
        Q <= d;
    end

endmodule