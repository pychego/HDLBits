module top_module (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);


    parameter LEFT = 0, RIGHT = 1;
    reg state, next;

    always @(*) begin
        case (state)
            LEFT: begin
                if (bump_left && bump_right) next = RIGHT;
                else if (bump_left) next = RIGHT;
                else if (bump_right) next = LEFT;
                else next = LEFT;
            end
            RIGHT: begin
                if (bump_left && bump_right) next = LEFT;
                else if (bump_right) next = LEFT;
                else if (bump_left) next = RIGHT;
                else next = RIGHT;
            end
            default: ;
        endcase
    end


    always @(posedge clk, posedge areset) begin
        state <= areset ? LEFT : next;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);



endmodule
