module top_module (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    parameter OFF = 0, ON = 1;
    reg state, next_state;

    always @(*) begin
        case (state)
            ON:
            if (k == 1) next_state <= OFF;
            else next_state <= ON;
            OFF:
            if (j == 1) next_state <= ON;
            else next_state <= OFF;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if (areset) state <= OFF;
        else state <= next_state;
    end

    assign out = (state ==ON);



endmodule
