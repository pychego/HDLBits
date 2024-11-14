module top_module (
    input             clk,
    input             resetn,
    input      [ 1:0] byteena,
    input      [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 0;
        end else begin
            case (byteena)
                0: ;
                1: q[7:0] <= d[7:0];
                2: q[15:8] <= d[15:8];
                3: q <= d;
                default: ;
            endcase
        end
    end
    
endmodule
