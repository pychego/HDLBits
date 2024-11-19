module top_module (
    input  clk,
    input  in,
    input  reset,
    output done
);

    // 这个方法没有使用边沿检测, 感觉很顺利; 就是所有的状态都有一个周期的延后
    // 状态越多, 写起来越简单
    parameter IDLE = 0, START = 1, S1_8 = 2, STOP = 3, WAIT = 4;
    reg [3:0] state, next;

    reg [15:0] count;
    always @(posedge clk) begin
        if (reset) count <= 0;
        else begin
            if (state == START || state == S1_8) count <= count + 1;
            else count <= 0;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next = in ? IDLE : START;
            START: next = S1_8;
            S1_8: next = (count == 8) ? (in ? STOP : WAIT) : S1_8;
            STOP: next = in ? IDLE : START;
            WAIT: next = in ? IDLE : WAIT;
            default: ;
        endcase
    end


    always @(posedge clk) begin
        state = reset ? IDLE : next;
    end

    assign done = (state == STOP);

    // 下午再检查一下这个方法吧, 将状态都明确列出来
    /*  // 使用的状态只有3个,太少了, 这就要用下降沿检测, 不知道哪里出了问题,一直不匹配
// 一般用的状态越少, 就越难写
    parameter S0 = 0, S1 = 1, S2 = 2;
    reg [1:0] state, next;

    reg in_reg;
    always @(posedge clk) begin
        in_reg <= in;
    end

    wire in_negedge;
    assign in_negedge = in_reg & (~in);

    reg [15:0] count;
    always @(posedge clk) begin
        if (reset) count <= 0;
        else begin
            if (state == S1) count <= count + 1;
            else count <= 0;
        end
    end


    always @(*) begin
        case (state)
            S0: begin
                next = (in_negedge) ? S1 : S0;
            end
            S1: begin
                if (count <= 7) next = S1;
                else if (count == 8 && in == 1) next = S2;
                else next = S0;
            end
            S2: begin
                next = (in_negedge) ? S1 : S0;
            end
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state = reset ? S0 : next;
    end

    assign done = (state == S2);
*/

endmodule
