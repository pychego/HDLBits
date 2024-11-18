module top_module (
    input      clk,
    input      areset,
    input      bump_left,
    input      bump_right,
    input      ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // 先大概列出状态转移图, 再写代码
    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3;
    reg [1:0] state, next;

    always @(*) begin
        case (state)
            LEFT: next = ground ? (bump_left ? RIGHT : LEFT) : FALL_L;
            RIGHT: next = ground ? (bump_right ? LEFT : RIGHT) : FALL_R;
            FALL_L: next = ground ? LEFT : FALL_L;
            FALL_R: next = ground ? RIGHT : FALL_R;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        state <= areset ? LEFT : next;
    end

    always @(*) begin
        case (state)
            LEFT: {walk_left, walk_right, aaah} = 3'b100;
            RIGHT: {walk_left, walk_right, aaah} = 3'b010;
            FALL_L: {walk_left, walk_right, aaah} = 3'b001;
            FALL_R: {walk_left, walk_right, aaah} = 3'b001;
            default: ;
        endcase
    end



endmodule
