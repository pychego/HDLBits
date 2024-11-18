module top_module (
    input      clk,
    input      areset,
    input      bump_left,
    input      bump_right,
    input      ground,
    input      dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // 先大概列出状态转移图, 再写代码
    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3, DIG_L = 4, DIG_R = 5;
    reg [2:0] state, next;

    always @(*) begin
        case (state)
            LEFT: next = ground ? (dig ? DIG_L : (bump_left ? RIGHT : LEFT)) : FALL_L;
            RIGHT: next = ground ? (dig ? DIG_R : (bump_right ? LEFT : RIGHT)) : FALL_R;
            FALL_L: next = ground ? LEFT : FALL_L;
            FALL_R: next = ground ? RIGHT : FALL_R;
            DIG_L: next = ground ? DIG_L : FALL_L;
            DIG_R: next = ground ? DIG_R : FALL_R;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        state <= areset ? LEFT : next;
    end

    always @(*) begin
        case (state)
            LEFT: {walk_left, walk_right, aaah, digging} = 4'b1000;
            RIGHT: {walk_left, walk_right, aaah, digging} = 4'b0100;
            FALL_L: {walk_left, walk_right, aaah, digging} = 4'b0010;
            FALL_R: {walk_left, walk_right, aaah, digging} = 4'b0010;
            DIG_L: {walk_left, walk_right, aaah, digging} = 4'b0001;
            DIG_R: {walk_left, walk_right, aaah, digging} = 4'b0001;
            default: ;
        endcase
    end



endmodule
