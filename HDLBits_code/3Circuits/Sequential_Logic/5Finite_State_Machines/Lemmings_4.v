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
    /* 刚开始理解错了题目, FALL的状态转移表写错了, FALL超过20个周期, 老鼠并不是马上死亡, 而是要落地才能死亡
       所以在FALL时要首先判断是否落地, 再判断FALL了多少个周期
    */
    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3, DIG_L = 4, DIG_R = 5, SPLATTER = 6;
    reg [2:0] state, next;

    reg [31:0] count_fill;
    always @(posedge clk, posedge areset) begin
        if (areset) count_fill <= 0;
        else begin
            // 这个判断条件, 如果用~ground, 需要count_fill >= 21 
            // 如果用state==FALL_L || state==FALL_R, 需要count_fill >= 20 
            if (state==FALL_L || state==FALL_R) count_fill <= count_fill + 1;
            else count_fill <= 0;
        end
    end

    // 下坠时间太长
    wire fill_to_long;
    assign fill_to_long = (count_fill >= 20);

    always @(*) begin
        case (state)
            LEFT: next = ground ? (dig ? DIG_L : (bump_left ? RIGHT : LEFT)) : FALL_L;
            RIGHT: next = ground ? (dig ? DIG_R : (bump_right ? LEFT : RIGHT)) : FALL_R;
            FALL_L: next = ground ? (fill_to_long ?  SPLATTER : LEFT) : FALL_L;
            FALL_R: next = ground ? (fill_to_long ? SPLATTER : RIGHT) : FALL_R;
            DIG_L: next = ground ? DIG_L : FALL_L;
            DIG_R: next = ground ? DIG_R : FALL_R;
            SPLATTER: next = SPLATTER;
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
            SPLATTER: {walk_left, walk_right, aaah, digging} = 4'b0000;
            default: ;
        endcase
    end



endmodule
