module top_module (
    input  clk,
    input  in,
    input  areset,
    output out
);

    parameter A = 0, B = 1, C = 2, D = 3;
    reg [3:0] state, next_state;

    // State transition logic
    // 尽量使用三目运算符代替if-else
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

    // State flip-flops with asynchronous reset
    always @(posedge clk, posedge areset ) begin
        if(areset) state <= A;
        else  state <= next_state;
    end

    // Output logic
    assign out = (state == D);


endmodule
