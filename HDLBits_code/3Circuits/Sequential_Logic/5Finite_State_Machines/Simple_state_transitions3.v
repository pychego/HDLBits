module top_module (
    input            in,
    input      [1:0] state,
    output reg [1:0] next_state,
    output           out
);

//  没有clk的FSM
    parameter A = 0, B = 1, C = 2, D = 3;
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) next_state = A;
                else next_state = B;
            end
            B: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
            C: begin
                if (in == 0) next_state = A;
                else next_state = D;
            end
            D: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
            default: ;
        endcase
    end

    assign out = (state == D);



endmodule
