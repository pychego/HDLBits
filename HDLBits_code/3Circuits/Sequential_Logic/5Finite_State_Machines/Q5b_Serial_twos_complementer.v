module top_module (
    input      clk,
    input      areset,
    input      x,
    output reg z
);

    parameter A = 2'b01, B = 2'b10;
    reg [1:0] state, next;

    always @(*) begin
        case (state)
            A: next = x ? B : A;
            B: next = B;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        state <= areset ? A : next;
    end

    always @(*) begin
        case (state)
            A: z = x;
            B: z = ~x;
            default: ;
        endcase
    end

endmodule
