module fsm (
    input      clk,
    input      reset_n,
    input      a,
    output reg k1,
    output reg k2
);

    reg [1:0] state, nextstate;

    parameter Idle = 2'b00, Start = 2'b01, Stop = 2'b10, Clear = 2'b11;

    always @(posedge clk) begin
        if (!reset_n) state <= Idle;
        else state <= nextstate;
    end

    // 每个always块只操作一个变量，比较容易发现问题和改正模块编写中出来的问题
    // 组合逻辑设计nextstate
    always @(state or a)
        case (state)
            Idle:
            if (a) nextstate <= Start;
            else nextstate <= Idle;
            Start:
            if (!a) nextstate <= Stop;
            else nextstate <= Start;
            Stop:
            if (a) nextstate <= Clear;
            else nextstate <= Stop;
            Clear:
            if (!a) nextstate <= Idle;
            else nextstate <= Clear;
            default: nextstate <= 2'bxx;
        endcase


    // 输出k1,k2是组合逻辑，不受clk控制
    always @(state or reset_n or a)
        if (!reset_n) k1 <= 1'b0;
        else if (state == Clear && !a) k1 <= 1'b1;
        else k1 <= 1'b0;

    always @(state or reset_n or a)
        if (!reset_n) k2 <= 1'b0;
        else if (state == Stop && a) k2 <= 1'b1;
        else k2 <= 1'b0;

/*  换种写法
    always @(state or reset_n or a)
        if (!reset_n) k2 <= 1'b0;
        else k2 <= (state == Stop && a);
*/

endmodule
